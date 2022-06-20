//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "../library/IdToColor.sol";

contract IdToColor_test is DSTest {
    using IdToColor for uint256;

    Vm vm = Vm(HEVM_ADDRESS);

    function testOutput() public {
        uint256 color = 0x1a0000;
        assertEq(color.toColor(), "#1A0000");
    }
}
