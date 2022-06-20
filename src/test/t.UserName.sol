//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "../UserName.sol";

contract UserName_test is DSTest {
    Vm vm = Vm(HEVM_ADDRESS);
    UserName public name;
    address public shop = address(1);

    function setUp() public {
        name = new UserName();
        name.setShop(shop, true);
    }

    function testSetName() public {
        string memory name_ = "test_name";
        assertEq(name.getName(address(1)), "");
        assertEq(name.resolveName(name_), address(0));

        vm.startPrank(shop);
        name.setName(name_, address(1));
        assertEq(name.getName(address(1)), name_);
        name.setName("user1-newname", address(1));
        assertEq(name.getName(address(1)), "user1-newname");
    }

    function testCannotSetName() public {
        vm.startPrank(address(2));
        vm.expectRevert("Shopable: shop not allowed");
        name.setName("not work", address(1));

        vm.startPrank(shop);
        vm.expectRevert("Name length is not accepted");
        name.setName("", address(1));

        vm.expectRevert("Name length is not accepted");
        name.setName("|8BYTES-|8BYTES-|8BYTES-|8BYTES-+", address(1));

        name.setName("A", address(1));
        vm.expectRevert("This name is already chosen");
        name.setName("A", address(2));
    }

    function testResetName() public {
        vm.startPrank(shop);
        name.setName("A", address(1));
        name.setName("B", address(1));
        name.setName("A", address(3));
    }
}
