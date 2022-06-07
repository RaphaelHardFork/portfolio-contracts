//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

interface IColoredToken {
    function mintColor(uint256 id_, address receiver) external;

    function burnColor(uint256 id_) external;
}
