//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "ds-test/test.sol";
import "./cheatCodes.sol";
import "../library/IdToColor.sol";

contract IdToColor_test is DSTest {
    using IdToColor for uint256;
    CheatCodes vm = CheatCodes(HEVM_ADDRESS);

    function testOutput() public {
        uint256 color = 0x1a0000;
        assertEq(color.toColor(), "#1A0000");
    }
}
