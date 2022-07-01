//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/utils/Address.sol";

interface Oracle {
    function lastestAnswer() external view returns (int256);

    function latestRoundData()
        external
        pure
        returns (
            uint80,
            int256,
            uint256,
            uint256,
            uint80
        );
}

contract FungibleToken is ERC20, Ownable {
    using Address for address payable;

    uint256 internal constant PRECISION = 10**25;
    uint256 internal constant ETHER = 10**18;
    Oracle private _oracle;

    constructor() ERC20("FungibleToken", "FT") {}

    function mint(uint256 amount) public {
        require(amount <= 50 * 10**18, "Mint no more than 50 tokens");
        require(balanceOf(msg.sender) <= 5 * 10**18, "You have enough tokens");
        _mint(msg.sender, amount);
    }

    function mintMore(uint256 amount) external payable returns (bool) {
        if (amount <= 50 * 10**18) {
            mint(amount);
            return true;
        }
        require(amount <= 1000 * 10**18, "Mint no more than 1000 tokens");
        require(ethToUsd(msg.value) >= 10**18, "You must donate at least 1$");
        _mint(msg.sender, amount);
        return true;
    }

    function setOracle(address oracle) external onlyOwner {
        require(oracle != address(0), "Oracle is not address zero");
        _oracle = Oracle(oracle);
    }

    function withdraw() external onlyOwner {
        payable(msg.sender).sendValue(address(this).balance);
    }

    function ethToUsd(uint256 amount) public view returns (uint256) {
        uint256 price = _priceToDecimal18();
        return (amount * price) / ETHER;
    }

    function usdToEth(uint256 amount) public view returns (uint256) {
        uint256 price = _priceToDecimal18();
        return (amount * ETHER) / price;
    }

    function _priceToDecimal18() internal view returns (uint256) {
        (, int256 price, , , ) = _oracle.latestRoundData();
        uint256 priceConverted = (uint256(price) * PRECISION) / 10**8;
        return (priceConverted * ETHER) / PRECISION;
    }
}
