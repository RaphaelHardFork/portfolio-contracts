// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "../abstracts/Reserve.sol";

contract ReserveMock is Reserve {
    function drawReserve(uint256 draws)
        external
        returns (uint256[] memory result)
    {
        result = _drawReserve(43432546553423, draws);
    }

    function setReserve(uint256 reserveSize_) external {
        _setReserve(reserveSize_);
    }
}

contract Reserve_test is DSTest {
    Vm vm = Vm(HEVM_ADDRESS);
    ReserveMock reserve;

    function setUp() public {
        reserve = new ReserveMock();
        reserve.setReserve(100);
    }

    function testSetReserve() public {
        assertEq(reserve.reserveSize(), 100);
    }

    function testDrawReserve() public {
        reserve.drawReserve(5);
        assertEq(reserve.reserveSize(), 95);
    }

    function testAllDrain() public {
        for (uint256 i = 0; i < 10; i++) {
            reserve.drawReserve(10);
        }
        assertEq(reserve.reserveSize(), 0);
    }

    function testFailSetReserve() public {
        reserve.setReserve(200);
    }

    function testCannotSetReserve() public {
        vm.expectRevert(bytes("Reserve still active"));
        reserve.setReserve(200);
    }

    function testCannotDrawMoreThan10() public {
        vm.expectRevert(bytes("Too much draws"));
        reserve.drawReserve(20);
    }

    function testCannotDrawMoreThanReserve() public {
        for (uint256 i = 0; i < 9; i++) {
            reserve.drawReserve(10);
        }
        reserve.drawReserve(5);
        vm.expectRevert(bytes("No more items in reserve"));
        reserve.drawReserve(10);
    }
}
