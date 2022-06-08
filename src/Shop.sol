//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC1155/IERC1155Receiver.sol";
import "openzeppelin-contracts/contracts/token/ERC1155/IERC1155.sol";
import "./interfaces/IColoredToken.sol";
import "./interfaces/IUserName.sol";
import "./interfaces/ICards.sol";

contract Shop is IERC1155Receiver {
    uint256 public immutable colorPrice;
    IColoredToken public colors;
    IUserName public names;
    ICards public cards;
    IERC20 public fungibleToken;

    constructor(
        IColoredToken colorToken,
        IERC20 fungibleToken_,
        IUserName names_,
        ICards cards_
    ) {
        colorPrice = 12 * 10**18;
        colors = colorToken;
        fungibleToken = fungibleToken_;
        names = names_;
        cards = cards_;
    }

    function buyColor(uint256 id_) external {
        fungibleToken.transferFrom(msg.sender, address(this), colorPrice);
        colors.mintColor(id_, msg.sender);
    }

    function buyName(string memory name_) external {
        fungibleToken.transferFrom(msg.sender, address(this), colorPrice / 2);
        names.setName(name_, msg.sender);
    }

    function buyBooster() external {
        fungibleToken.transferFrom(msg.sender, address(this), colorPrice);
        cards.deliverBooster(msg.sender);
    }

    function openBooster(uint256 tokenId) external {
        require(
            IERC1155(address(cards)).balanceOf(msg.sender, tokenId) > 0,
            "You should have a booster"
        );
        cards.deliverCards(msg.sender, tokenId);
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
