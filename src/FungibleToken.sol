//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract FungibleToken is ERC20 {
    constructor() ERC20("FungibleToken", "ERC20") {}

    function mint(uint256 amount) external {
        require(amount <= 50 * 10**18, "Cannot mint more than 50 tokens");
        require(balanceOf(msg.sender) <= 5 * 10**18, "You have enough tokens");
        _mint(msg.sender, amount);
    }
}
