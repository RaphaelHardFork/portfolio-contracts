// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Shop.sol";
import "../FungibleToken.sol";
import "../ColoredToken.sol";
import "./cheatCodes.sol";

contract Shop_test is DSTest {
    CheatCodes vm = CheatCodes(HEVM_ADDRESS);
    FungibleToken public money;
    ColoredToken public nft;
    Shop public shop;

    function setUp() public {
        money = new FungibleToken();
        nft = new ColoredToken();
        shop = new Shop(nft, money);
        nft.setShop(address(shop));
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
}
