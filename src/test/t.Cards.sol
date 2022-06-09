// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "./cheatCodes.sol";

import "../Cards.sol";

contract Cards_test is DSTest {
    CheatCodes vm = CheatCodes(HEVM_ADDRESS);
    Cards public cards;
    address public shop = address(1);

    function setUp() public {
        cards = new Cards("ipfs://{hash}/");
        cards.setShop(shop);
        vm.warp(365);
        vm.roll(125);
    }

    function testDeliverBooster() public {
        vm.startPrank(shop);

        cards.deliverBooster(address(2));

        assertEq(cards.balanceOf(address(2), 10003), 1);
    }

    function testDeliverCards() public {
        vm.startPrank(shop);
        cards.deliverBooster(address(2));
        cards.deliverCards(address(2), 10003);
        assertEq(cards.balanceOf(address(2), 10003), 0);
    }

    function testUri() public {
        vm.startPrank(shop);
        cards.deliverBooster(address(2));
        assertEq(cards.uri(69), "ipfs://{hash}/69.json");
        assertEq(cards.uri(10000), "ipfs://{hash}/10000.json");
        assertEq(cards.uri(19000), "ipfs://{hash}/10000.json");
    }
}
