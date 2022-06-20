// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Test.sol";
import "forge-std/Vm.sol";

import "../Cards.sol";

contract Cards_test is DSTest, Test {
    using stdStorage for StdStorage;

    Cards public cards;
    address public constant SHOP = address(501);
    address public constant OWNER = address(301);

    function setUp() public {
        vm.startPrank(OWNER);
        cards = new Cards("ipfs://{hash}/");
        cards.setShop(SHOP, true);
    }

    function testDeliverBooster(uint256 randomNumber) public {
        vm.warp(randomNumber);
        vm.roll(randomNumber / 2);
        vm.startPrank(SHOP);

        cards.deliverBooster(address(2));
        uint256[] memory shopCards = cards.boosterLink(10003);
        for (uint256 i = 0; i < 5; i++) {
            assertGe(cards.balanceOf(SHOP, shopCards[i]), 1);
        }

        assertEq(cards.balanceOf(address(2), 10003), 1);
    }

    function testBuyAllBooster() public {
        uint256 randomNumber = 3689;
        vm.warp(randomNumber);
        vm.roll(randomNumber / 2);
        vm.startPrank(SHOP);

        for (uint256 i = 0; i < 1998; i++) {
            cards.deliverBooster(address(2));
        }

        // check distribution
        assertEq(cards.remainingBooster(), 0);
        for (uint256 i = 1; i <= 54; i++) {
            assertEq(cards.balanceOf(SHOP, i), 180);
        }
        for (uint256 i = 55; i <= 54 * 2; i++) {
            assertEq(cards.balanceOf(SHOP, i), 5);
        }
    }

    function testCannotBuyBooster() public {
        uint256 randomNumber = 3689;
        vm.warp(randomNumber);
        vm.roll(randomNumber / 2);

        vm.startPrank(address(5));
        vm.expectRevert("Shopable: shop not allowed");
        cards.deliverBooster(address(2));

        vm.startPrank(SHOP);
        for (uint256 i = 0; i < 1998; i++) {
            cards.deliverBooster(address(2));
        }

        vm.expectRevert("No more items in reserve");
        cards.deliverBooster(address(2));
    }

    function testDeliverCards(uint256 randomNumber) public {
        vm.warp(randomNumber);
        vm.roll(randomNumber / 2);
        vm.startPrank(SHOP);
        cards.deliverBooster(address(2));
        uint256[] memory shopCards = cards.boosterLink(10003);
        cards.deliverCards(address(2), 10003);
        assertEq(cards.balanceOf(address(2), 10003), 0);
        for (uint256 i = 0; i < 5; i++) {
            assertGe(cards.balanceOf(address(2), shopCards[i]), 1);
        }
    }

    function testDeliverAllCards() public {
        uint256 randomNumber = 3689;
        vm.warp(randomNumber);
        vm.roll(randomNumber / 2);
        vm.startPrank(SHOP);

        for (uint256 i = 0; i < 1998; i++) {
            cards.deliverBooster(address(2));
            cards.deliverCards(address(2), 10003 + i);
            assertEq(cards.balanceOf(address(2), 10003 + i), 0);
        }
        for (uint256 i = 1; i <= 54; i++) {
            assertEq(cards.balanceOf(address(2), i), 180);
        }
        for (uint256 i = 55; i <= 54 * 2; i++) {
            assertEq(cards.balanceOf(address(2), i), 5);
        }
    }

    function testCannotDeliverCards(uint256 randomNumber) public {
        vm.warp(randomNumber);
        vm.roll(randomNumber / 2);
        vm.startPrank(SHOP);
        cards.deliverBooster(address(2));
        vm.startPrank(address(5));
        vm.expectRevert("Shopable: shop not allowed");
        cards.deliverCards(address(2), 10003);
    }

    function testUri() public {
        assertEq(cards.uri(69), "ipfs://{hash}/69.json");
        assertEq(cards.uri(10000), "ipfs://{hash}/10000.json");
        assertEq(cards.uri(19000), "ipfs://{hash}/10000.json");
    }
}
