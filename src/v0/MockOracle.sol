//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract MockOracle {
    function lastestAnswer() external pure returns (int256) {
        return 1000 * 10**8;
    }

    function latestRoundData()
        external
        pure
        returns (
            uint80,
            int256 answer,
            uint256,
            uint256,
            uint80
        )
    {
        answer = 1000 * 10**8;
    }
}
