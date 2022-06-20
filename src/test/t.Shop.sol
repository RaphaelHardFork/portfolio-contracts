// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "../Shop.sol";
import "../FungibleToken.sol";
import "../UserName.sol";
import "../ColoredToken.sol";
import "../Cards.sol";

contract Shop_test is DSTest {
    Vm vm = Vm(HEVM_ADDRESS);
    uint256 public constant FIFTY = 50 * 10**18;
    address public constant OWNER = address(301);
    Shop public shop;
    FungibleToken public money;
    UserName public names;
    ColoredToken public colors;
    Cards public cards;

    function setUp() public {
        vm.startPrank(OWNER);
        money = new FungibleToken();
        colors = new ColoredToken();
        names = new UserName();
        cards = new Cards("ipfs://{hash}/");
        shop = new Shop(money, names, colors, cards);
        colors.setShop(address(shop), true);
        names.setShop(address(shop), true);
        cards.setShop(address(shop), true);
    }

    function testBuyName(string memory name_) public {
        vm.assume(bytes(name_).length > 0 && bytes(name_).length <= 32);
        vm.startPrank(address(1));
        money.approve(address(shop), FIFTY);
        money.mint(FIFTY);
        shop.buyName(name_);

        assertEq(money.balanceOf(address(1)), FIFTY - shop.itemPrices(0));
        assertEq(names.getName(address(1)), name_);
        assertEq(names.resolveName(name_), address(1));
    }

    function testCannotBuyName(string memory name_) public {
        vm.assume(bytes(name_).length > 0 && bytes(name_).length <= 32);
        vm.startPrank(address(1));
        money.approve(address(shop), FIFTY);
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        shop.buyName(name_);

        money.mint(FIFTY);
        money.approve(address(shop), 0);
        vm.expectRevert("ERC20: insufficient allowance");
        shop.buyName(name_);
    }

    function testBuyColor(uint256 id_) public {
        vm.assume(id_ <= 0xFFFFFF);
        vm.startPrank(address(1));
        money.mint(FIFTY);
        money.approve(address(shop), FIFTY);

        shop.buyColor(id_);
        assertEq(money.balanceOf(address(1)), FIFTY - shop.itemPrices(1));
        assertEq(colors.balanceOf(address(1)), 1);
    }

    function testCannotBuyColor(uint256 id_) public {
        vm.assume(id_ <= 0xFFFFFF);
        vm.startPrank(address(1));
        money.approve(address(shop), FIFTY);
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        shop.buyColor(id_);

        money.mint(FIFTY);
        money.approve(address(shop), 0);
        vm.expectRevert("ERC20: insufficient allowance");
        shop.buyColor(id_);
    }

    function testBuyBooster(uint256 randomNumber) public {
        vm.warp(randomNumber);
        vm.roll(randomNumber / 2);
        vm.startPrank(address(1));
        money.mint(FIFTY);
        money.approve(address(shop), FIFTY);
        shop.buyBooster();

        uint256[] memory shopCards = cards.boosterLink(10003);
        for (uint256 i = 0; i < 5; i++) {
            assertGe(cards.balanceOf(address(shop), shopCards[i]), 1);
        }
        assertEq(cards.balanceOf(address(1), 10003), 1);
    }

    function testCannotBuyBooster(uint256 randomNumber) public {
        vm.warp(randomNumber);
        vm.roll(randomNumber / 2);
        vm.startPrank(address(1));
        money.approve(address(shop), FIFTY);
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        shop.buyBooster();

        money.mint(FIFTY);
        money.approve(address(shop), 0);
        vm.expectRevert("ERC20: insufficient allowance");
        shop.buyBooster();
    }

    function testOpenBooster(uint256 randomNumber) public {
        vm.warp(randomNumber);
        vm.roll(randomNumber / 2);
        vm.startPrank(address(1));
        money.mint(FIFTY);
        money.approve(address(shop), FIFTY);
        shop.buyBooster();
        uint256[] memory shopCards = cards.boosterLink(10003);
        shop.openBooster(10003);

        for (uint256 i = 0; i < 5; i++) {
            assertGe(cards.balanceOf(address(1), shopCards[i]), 1);
        }
        assertEq(cards.balanceOf(address(1), 10003), 0);
    }

    function testCannotOpenBooster() public {
        vm.startPrank(address(1));
        vm.expectRevert("You must own the booster");
        shop.openBooster(10003);
    }

    function testGetRecipes() public {
        vm.startPrank(address(1));
        money.mint(FIFTY);
        money.approve(address(shop), FIFTY);

        shop.buyName("name");
        shop.buyColor(0xEEAAFF);
        shop.buyBooster();

        vm.startPrank(OWNER);
        shop.getRecipes();
        assertEq(
            money.balanceOf(OWNER),
            shop.itemPrices(0) + shop.itemPrices(1) + shop.itemPrices(2)
        );
        assertEq(money.balanceOf(address(shop)), 0);
    }

    function testCannotGetRecipes() public {
        vm.startPrank(address(1));
        money.mint(FIFTY);
        money.approve(address(shop), FIFTY);

        shop.buyName("name");
        shop.buyColor(0xEEAAFF);
        shop.buyBooster();

        vm.expectRevert("Ownable: caller is not the owner");
        shop.getRecipes();
    }
}
