// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "../UserName.sol";
import "../Shop.sol";
import "../FungibleToken.sol";
import "../ColoredToken.sol";
import "../Cards.sol";

contract Shop_test is DSTest {
    Vm vm = Vm(HEVM_ADDRESS);
    FungibleToken public money;
    ColoredToken public nft;
    Shop public shop;
    UserName public names;
    Cards public cards;

    function setUp() public {
        money = new FungibleToken();
        nft = new ColoredToken();
        names = new UserName();
        cards = new Cards("ipfs://{hash}/");
        shop = new Shop(nft, money, names, cards);
        nft.setShop(address(shop), true);
        names.setShop(address(shop), true);
        cards.setShop(address(shop), true);
    }

    function testBuyColor(uint256 id_) public {
        uint256 amount = 50 * 10**18;
        vm.assume(id_ <= 0xFFFFFF);
        vm.startPrank(address(1));
        money.mint(amount);
        money.approve(address(shop), amount);

        shop.buyColor(id_);
        assertEq(money.balanceOf(address(1)), amount - shop.colorPrice());
        assertEq(nft.balanceOf(address(1)), 1);
    }

    function testCannotBuyColor() public {
        vm.startPrank(address(1));
        money.approve(address(shop), 50 * 10**18);
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        shop.buyColor(0xFFAADD);

        money.mint(50 * 10**18);
        money.approve(address(shop), 0);
        vm.expectRevert("ERC20: insufficient allowance");
        shop.buyColor(0xFFAADD);
    }

    function testBuyName() public {
        vm.startPrank(address(1));
        money.approve(address(shop), 50 * 10**18);
        money.mint(50 * 10**18);
        shop.buyName("name");

        assertEq(names.getName(address(1)), "name");
        assertEq(names.resolveName("name"), address(1));
    }

    function testCannotBuyName() public {
        vm.startPrank(address(1));
        money.approve(address(shop), 50 * 10**18);
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        shop.buyName("name");

        money.mint(50 * 10**18);
        money.approve(address(shop), 0);
        vm.expectRevert("ERC20: insufficient allowance");
        shop.buyName("name");
    }

    function testBuyBooster() public {
        vm.startPrank(address(1));
        money.mint(50 * 10**18);
        money.approve(address(shop), 50 * 10**18);
        shop.buyBooster();

        assertEq(cards.balanceOf(address(1), 10003), 1);
    }

    function testCannotBuyBooster() public {
        vm.startPrank(address(1));
        money.approve(address(shop), 50 * 10**18);
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        shop.buyBooster();

        money.mint(50 * 10**18);
        money.approve(address(shop), 0);
        vm.expectRevert("ERC20: insufficient allowance");
        shop.buyBooster();
    }

    function testOpenBooster() public {
        vm.startPrank(address(1));
        money.mint(50 * 10**18);
        money.approve(address(shop), 50 * 10**18);
        shop.buyBooster();

        shop.openBooster(10003);

        assertEq(cards.balanceOf(address(1), 10003), 0);
    }

    function testCannotOpenBooster() public {
        vm.startPrank(address(1));
        vm.expectRevert("You should have a booster");
        shop.openBooster(10003);
    }
}
