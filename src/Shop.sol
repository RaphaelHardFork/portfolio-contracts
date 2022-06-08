//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IColoredToken.sol";
import "./interfaces/IUserName.sol";

contract Shop {
    uint256 public immutable colorPrice;
    IColoredToken public colors;
    IUserName public names;
    IERC20 public fungibleToken;

    constructor(
        IColoredToken colorToken,
        IERC20 fungibleToken_,
        IUserName names_
    ) {
        colorPrice = 12 * 10**18;
        colors = colorToken;
        fungibleToken = fungibleToken_;
        names = names_;
    }

    function buyColor(uint256 id_) external {
        fungibleToken.transferFrom(msg.sender, address(this), colorPrice);
        colors.mintColor(id_, msg.sender);
    }

    function buyName(string memory name_) external {
        fungibleToken.transferFrom(msg.sender, address(this), colorPrice / 2);
        names.setName(name_, msg.sender);
    }
}
