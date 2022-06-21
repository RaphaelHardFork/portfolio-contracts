//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract OracleETHAt1000 {
    function lastestAnswer() external pure returns (int256) {
        return 1000 * 10**8;
    }
}
