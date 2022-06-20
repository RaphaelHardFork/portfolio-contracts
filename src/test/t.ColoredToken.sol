// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../ColoredToken.sol";
import "./cheatCodes.sol";

contract ColoredToken_test is DSTest {
    CheatCodes vm = CheatCodes(HEVM_ADDRESS);
    address public constant SHOP = address(501); // mock for shop
    address public constant OWNER = address(301);
    ColoredToken public nft;

    function setUp() public {
        vm.startPrank(OWNER);
        nft = new ColoredToken();
        nft.setShop(SHOP, true);
    }

    function testMintColor(uint256 id_) public {
        vm.startPrank(SHOP);
        vm.assume(id_ <= 0xffffff);
        nft.mintColor(id_, address(1));
        assertEq(nft.ownerOf(id_), address(1));
    }

    function testCannotMintColor(uint256 tokenId) public {
        vm.assume(tokenId <= 0xffffff && tokenId != 0);
        vm.startPrank(SHOP);
        vm.expectRevert("No more than 0xFFFFFF");
        nft.mintColor(0xffffff1, address(1));

        nft.mintColor(tokenId, address(1));
        vm.expectRevert("ERC721: token already minted");
        nft.mintColor(tokenId, address(2));

        vm.expectRevert("Users cannot have several colors");
        nft.mintColor((tokenId + tokenId) % 0xFFFFFF, address(1));

        vm.startPrank(address(5));
        vm.expectRevert("Shopable: shop not allowed");
        nft.mintColor(tokenId, address(5));
    }

    function testCannotHaveSeveralColor(uint256 tokenId) public {
        vm.assume(tokenId <= 0xffffff && tokenId != 0);
        vm.startPrank(SHOP);
        nft.mintColor(tokenId, address(1));
        nft.mintColor((tokenId + tokenId) % 0xFFFFFF, address(2));

        vm.startPrank(address(1));
        vm.expectRevert("Users cannot have several colors");
        nft.transferFrom(address(1), address(2), tokenId);
    }

    function testBurnColor(uint256 tokenId) public {
        vm.assume(tokenId <= 0xffffff);
        vm.startPrank(SHOP);
        nft.mintColor(tokenId, address(1));
        assertEq(nft.balanceOf(address(1)), 1);

        vm.startPrank(address(1));
        vm.deal(address(1), 10**18);
        nft.burnColor{value: 10**15}(tokenId);
        assertEq(nft.balanceOf(address(1)), 0);
        assertEq(address(nft).balance, 10**15);
    }

    function testCannotBurnColor(uint256 tokenId) public {
        vm.assume(tokenId <= 0xffffff);
        vm.startPrank(SHOP);
        vm.deal(SHOP, 10**18);
        nft.mintColor(tokenId, address(1));
        vm.expectRevert("You should own the color");
        nft.burnColor{value: 10**15}(tokenId);

        vm.startPrank(address(1));
        vm.expectRevert("Cost must at least 0.00005 ETH");
        nft.burnColor(tokenId);
    }

    function testViewOwner(uint256 tokenId) public {
        vm.assume(tokenId <= 0xffffff);
        assertEq(nft.ownerOf(tokenId), address(0));
    }

    function testWithdraw() public {
        uint256 tokenId = 0xFFEEAA;
        vm.startPrank(SHOP);
        nft.mintColor(tokenId, address(1));

        vm.startPrank(address(1));
        vm.deal(address(1), 10**18);
        nft.burnColor{value: 10**15}(tokenId);

        vm.startPrank(OWNER);
        nft.withdraw();
        assertEq(OWNER.balance, 10**15);
    }

    event ShopManaged(address indexed shop, bool indexed active);

    function testSetShop(address shop) public {
        vm.assume(shop != address(0) && shop != OWNER && shop != SHOP);
        vm.startPrank(OWNER);
        vm.expectEmit(true, true, false, true);
        emit ShopManaged(shop, true);
        nft.setShop(shop, true);
        assertTrue(nft.shops(shop));
    }

    function testCannotAsNonOwner(address shop) public {
        vm.assume(shop != address(0) && shop != OWNER && shop != SHOP);
        uint256 tokenId = 0xFFEEAA;
        vm.startPrank(SHOP);
        nft.mintColor(tokenId, address(1));

        vm.startPrank(address(1));
        vm.deal(address(1), 10**18);
        nft.burnColor{value: 10**15}(tokenId);

        vm.startPrank(address(2));
        vm.expectRevert("Ownable: caller is not the owner");
        nft.withdraw();

        vm.expectRevert("Ownable: caller is not the owner");
        nft.setShop(shop, true);
    }
}
