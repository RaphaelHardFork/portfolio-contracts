// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../FungibleToken.sol";
import "./cheatCodes.sol";

contract ETHOracle {
    function lastestAnswer() external pure returns (int256) {
        return 1050 * 10**8;
    }
}

contract FungibleToken_test is DSTest {
    CheatCodes vm = CheatCodes(HEVM_ADDRESS);
    address constant OWNER = address(501);
    FungibleToken public ft;
    Oracle public oracle;

    function setUp() public {
        address _oracle = address(new ETHOracle());
        vm.startPrank(OWNER);
        ft = new FungibleToken();
        ft.setOracle(Oracle(_oracle));
    }

    function testMint(uint256 amount) public {
        // fuzzed test
        vm.assume(amount <= 50);
        vm.startPrank(address(1));
        ft.mint(amount * 10**18);
        assertEq(ft.balanceOf(address(1)), amount * 10**18);
    }

    function testMultipleMint(uint256 amount) public {
        // Mint for 50 user
        uint256 totalSupply;
        vm.assume(amount <= 50);
        for (uint256 i = 0; i < 50; i++) {
            address _user = address(uint160(50 + i));
            if (_user == address(0)) continue;
            vm.prank(_user);
            ft.mint(amount * 10**18);
            totalSupply += amount * 10**18;
        }
        assertEq(ft.totalSupply(), totalSupply);
    }

    function testCannotMint(uint256 amount) public {
        vm.startPrank(address(1));
        vm.assume(amount <= 50 && amount > 5);
        vm.expectRevert(bytes("Mint no more than 50 tokens"));
        ft.mint((amount + 51) * 10**18);

        ft.mint(amount * 10**18);
        vm.expectRevert(bytes("You have enough tokens"));
        ft.mint(amount * 10**18);
    }

    function testMintMore(uint256 amount) public {
        vm.startPrank(address(1));
        vm.deal(address(1), 50 * 10**18);
        vm.assume(amount > 50 && amount <= 1000);

        ft.mintMore{value: 1 * 10**18}(amount * 10**18);
        assertEq(ft.balanceOf(address(1)), amount * 10**18);
    }

    function testCannotMintMore(uint256 userValue) public {
        vm.startPrank(address(1));
        vm.deal(address(1), 50 * 10**18);
        vm.assume(
            userValue < 900000000000000 && ft.ethToUsd(userValue) < 10**18
        );

        vm.expectRevert(bytes("You must donate at least 1$"));
        ft.mintMore{value: userValue}(500 * 10**18);
    }
}
