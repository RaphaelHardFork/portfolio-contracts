// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "./cheatCodes.sol";
import "../UserName.sol";
import "../Shop.sol";
import "../FungibleToken.sol";
import "../ColoredToken.sol";

contract Shop_test is DSTest {
    CheatCodes vm = CheatCodes(HEVM_ADDRESS);
    FungibleToken public money;
    ColoredToken public nft;
    Shop public shop;
    UserName public names;

    function setUp() public {
        money = new FungibleToken();
        nft = new ColoredToken();
        names = new UserName();
        shop = new Shop(nft, money, names);
        nft.setShop(address(shop));
        names.setShop(address(shop));
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
}
