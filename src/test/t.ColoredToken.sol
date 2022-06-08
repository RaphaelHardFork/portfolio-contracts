// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../ColoredToken.sol";
import "./cheatCodes.sol";

contract ColoredToken_test is DSTest {
    CheatCodes vm = CheatCodes(HEVM_ADDRESS);
    ColoredToken public nft;
    address public shop; // mock for shop

    function setUp() public {
        nft = new ColoredToken();
        shop = address(10);
        nft.setShop(shop);
    }

    function testMintColor(uint256 id_) public {
        vm.startPrank(shop);
        vm.assume(id_ <= 0xffffff);
        nft.mintColor(id_, address(1));
        assertEq(nft.ownerOf(id_), address(1));
    }

    function testCannotMintColor() public {
        vm.startPrank(shop);
        vm.expectRevert("No more than 0xFFFFFF");
        nft.mintColor(0xffffff1, address(1));

        nft.mintColor(0xaaffee, address(1));
        vm.expectRevert("ERC721: token already minted");
        nft.mintColor(0xaaffee, address(2));

        vm.expectRevert("Users cannot have several colors");
        nft.mintColor(0xaa5fee, address(1));

        vm.startPrank(address(5));
        vm.expectRevert("Only shop have access");
        nft.mintColor(0xffffee, address(5));
    }

    function testBurnColor(uint256 id_) public {
        vm.assume(id_ <= 0xffffff);
        vm.startPrank(shop);
        nft.mintColor(id_, address(1));
        assertEq(nft.balanceOf(address(1)), 1);
        vm.startPrank(address(1));
        nft.burnColor(id_);
        assertEq(nft.balanceOf(address(1)), 0);
    }

    function testCannotBurnColor() public {
        vm.startPrank(shop);
        nft.mintColor(0x123456, address(1));
        vm.expectRevert("You should own the color");
        nft.burnColor(0x123456);
    }

    function testCannotHaveSeveralColor() public {
        vm.startPrank(shop);
        nft.mintColor(0x123456, address(1));
        nft.mintColor(0x112233, address(2));

        vm.startPrank(address(1));
        vm.expectRevert("Users cannot have several colors");
        nft.transferFrom(address(1), address(2), 0x123456);
    }

    function testViewOwner(uint256 id_) public {
        vm.assume(id_ <= 0xffffff);
        assertEq(nft.ownerOf(id_), address(0));
    }
}
