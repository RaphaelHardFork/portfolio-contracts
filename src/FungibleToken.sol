//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/contracts/utils/Address.sol";

contract FungibleToken is ERC20 {
    using Address for address payable;

    address private _recipient;

    constructor(address recipient_) ERC20("FungibleToken", "ERC20") {
        require(recipient_ != address(0), "FT: recipient is zero");
        _recipient = recipient_;
    }

    function mint(uint256 amount) external {
        require(amount <= 50 * 10**18, "Cannot mint more than 50 tokens");
        require(balanceOf(msg.sender) <= 10**18, "You already have tokens");
        _mint(msg.sender, amount);
    }

    function mintMore(uint256 amount) external payable {
        require(msg.value > 0, "Mint more require some values");
        payable(_recipient).sendValue(msg.value);
        _mint(msg.sender, amount);
    }

    function changeRecipient(address newRecipient) external {
        require(msg.sender == _recipient && newRecipient != address(0), "FT: only recipient");
        _recipient = newRecipient;
    }

    function recipient() public view returns (address) {
        return _recipient;
    }
}
