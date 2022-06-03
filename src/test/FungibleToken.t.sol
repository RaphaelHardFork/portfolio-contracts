// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../FungibleToken.sol";
import "./cheatCodes.sol";

contract FungibleToken_test is DSTest {
    CheatCodes vm = CheatCodes(HEVM_ADDRESS);
    FungibleToken ft;

    function setUp() public {
        ft = new FungibleToken(address(1));
    }

    function testMint() public {
        vm.prank(address(1));
        ft.mint(45 * 10**18);
        assertEq(ft.balanceOf(address(1)), 45 * 10**18);
    }

    function testMintFuzz(uint256 amount) public {
        vm.assume(amount <= 50);
        vm.startPrank(address(1));
        ft.mint(amount * 10**18);
        assertEq(ft.balanceOf(address(1)), amount * 10**18);
    }

    function testCannotMint() public {
        vm.startPrank(address(1));
        vm.expectRevert(bytes("Cannot mint more than 50 tokens"));
        ft.mint(51 * 10**18);

        ft.mint(45 * 10**18);
        vm.expectRevert(bytes("You already have tokens"));
        ft.mint(45 * 10**18);
    }

    function testMintMore() public {
        vm.deal(address(1), 0);
        vm.deal(address(2), 10000);
        vm.startPrank(address(2));
        ft.mintMore{value: 5000}(75 * 10**18);
        assertEq(ft.balanceOf(address(2)), 75 * 10**18);
        assertEq(address(1).balance, 5000);
        assertEq(address(2).balance, 5000);
    }

    function testCannotMintMore() public {
        vm.startPrank(address(2));
        vm.expectRevert(bytes("Mint more require some values"));
        ft.mintMore(75 * 10**18);
    }

    function testChangeRecipient() public {
        vm.startPrank(address(1));
        ft.changeRecipient(address(2));
        assertEq(ft.recipient(), address(2));
    }

    function testCannotChangeRecipient() public {
        vm.startPrank(address(2));
        vm.expectRevert(bytes("FT: only recipient"));
        ft.changeRecipient(address(3));
        vm.startPrank(address(1));
        vm.expectRevert(bytes("FT: only recipient"));
        ft.changeRecipient(address(0));
    }
}
