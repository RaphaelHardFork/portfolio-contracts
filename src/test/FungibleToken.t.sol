// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../FungibleToken.sol";
import "./cheatCodes.sol";

contract FungibleToken_test is DSTest {
    CheatCodes vm = CheatCodes(HEVM_ADDRESS);
    FungibleToken ft;

    function setUp() public {
        ft = new FungibleToken();
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
        vm.expectRevert(bytes("You have enough tokens"));
        ft.mint(45 * 10**18);
    }
}
