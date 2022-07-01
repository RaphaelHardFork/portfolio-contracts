//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC1155/IERC1155Receiver.sol";

import "../v0/ColoredToken.sol";
import "../v0/Cards.sol";

/**
 * Integrate the possibility to change the contracts
 */

contract ShopV1 is
    Initializable,
    UUPSUpgradeable,
    OwnableUpgradeable,
    IERC1155Receiver
{
    uint256 private itemPrice;
    IERC20 public fungible;
    ColoredToken public colors;
    Cards public cards;

    event ItemPriceSet(uint256 price);

    function __Shop_init() external initializer {
        __Ownable_init_unchained();
    }

    function setItemPrice(uint256 price) external onlyOwner {
        itemPrice = price;
    }

    function getRecipes() external onlyOwner {
        uint256 ftBalance = fungible.balanceOf(address(this));
        fungible.transfer(msg.sender, ftBalance);
    }

    function setColors(address colorsAddr) external onlyOwner {
        colors = ColoredToken(colorsAddr);
    }

    function buyColor(uint256 id_) external {
        fungible.transferFrom(msg.sender, address(this), itemPrice * 3);
        colors.mintColor(id_, msg.sender);
    }

    function setCards(address cardsAddr) external onlyOwner {
        cards = Cards(cardsAddr);
    }

    function buyBooster() external {
        fungible.transferFrom(msg.sender, address(this), itemPrice * 2);
        cards.deliverBooster(msg.sender);
    }

    function openBooster(uint256 tokenId) external {
        require(
            IERC1155(address(cards)).balanceOf(msg.sender, tokenId) > 0,
            "You must own the booster"
        );
        cards.deliverCards(msg.sender, tokenId);
    }

    /**
     * Items:
     *  0: colors
     *  1: boosters
     */
    function itemPrices(uint256 item) public view returns (uint256) {
        return item == 0 ? itemPrice * 3 : itemPrice * 2;
    }

    // ------------------------------ Interfaces needed

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

    // -------------------------- UUPS contract upgrade function
    function _authorizeUpgrade(address) internal view override {
        require(msg.sender == owner(), "Shop: wrong upgrader");
    }
}
