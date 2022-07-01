//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC1155/IERC1155Receiver.sol";
import "openzeppelin-contracts/contracts/token/ERC1155/IERC1155.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

import "../interfaces/IColoredToken.sol";
import "../interfaces/IUserName.sol";
import "../interfaces/ICards.sol";

contract Shop is IERC1155Receiver, Ownable {
    uint256 public immutable itemPrice;
    IERC20 public fungibleToken;
    IUserName public names;
    IColoredToken public colors;
    ICards public cards;

    constructor(
        IERC20 fungibleToken_,
        IUserName names_,
        IColoredToken colorToken,
        ICards cards_
    ) {
        itemPrice = 4 * 10**18;
        fungibleToken = fungibleToken_;
        names = names_;
        colors = colorToken;
        cards = cards_;
    }

    function buyName(string memory name_) external {
        fungibleToken.transferFrom(msg.sender, address(this), itemPrice);
        names.setName(name_, msg.sender);
    }

    function buyColor(uint256 id_) external {
        fungibleToken.transferFrom(msg.sender, address(this), itemPrice * 3);
        colors.mintColor(id_, msg.sender);
    }

    function buyBooster() external {
        fungibleToken.transferFrom(msg.sender, address(this), itemPrice * 2);
        cards.deliverBooster(msg.sender);
    }

    function openBooster(uint256 tokenId) external {
        require(
            IERC1155(address(cards)).balanceOf(msg.sender, tokenId) > 0,
            "You must own the booster"
        );
        cards.deliverCards(msg.sender, tokenId);
    }

    function getRecipes() external onlyOwner {
        uint256 ftBalance = fungibleToken.balanceOf(address(this));
        fungibleToken.transfer(msg.sender, ftBalance);
    }

    /**
     * Item:
     *  0: names
     *  1: colors
     *  2: boosters
     */
    function itemPrices(uint256 item) public view returns (uint256) {
        return
            item == 0 ? itemPrice : item == 1 ? itemPrice * 3 : itemPrice * 2;
    }

    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes calldata
    ) external pure returns (bytes4) {
        return
            bytes4(
                keccak256(
                    "onERC1155Received(address,address,uint256,uint256,bytes)"
                )
            );
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] calldata,
        uint256[] calldata,
        bytes calldata
    ) external pure returns (bytes4) {
        return
            bytes4(
                keccak256(
                    "onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"
                )
            );
    }

    function supportsInterface(bytes4) external pure returns (bool) {
        return true;
    }
}
