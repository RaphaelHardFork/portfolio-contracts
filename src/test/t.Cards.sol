// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "../Cards.sol";

contract Cards_test is DSTest {
    Vm vm = Vm(HEVM_ADDRESS);
    Cards public cards;
    address public constant SHOP = address(501);
    address public constant OWNER = address(301);

    function setUp() public {
        vm.startPrank(OWNER);
        cards = new Cards("ipfs://{hash}/");
        cards.setShop(SHOP, true);
        vm.warp(365);
        vm.roll(125);
    }

    function testDeliverBooster() public {
        vm.startPrank(SHOP);

        cards.deliverBooster(address(2));

        assertEq(cards.balanceOf(address(2), 10003), 1);
    }

    function testDeliverCards() public {
        vm.startPrank(SHOP);
        cards.deliverBooster(address(2));
        cards.deliverCards(address(2), 10003);
        assertEq(cards.balanceOf(address(2), 10003), 0);
    }

    function testUri() public {
        vm.startPrank(SHOP);
        cards.deliverBooster(address(2));
        assertEq(cards.uri(69), "ipfs://{hash}/69.json");
        assertEq(cards.uri(10000), "ipfs://{hash}/10000.json");
        assertEq(cards.uri(19000), "ipfs://{hash}/10000.json");
    }
}
