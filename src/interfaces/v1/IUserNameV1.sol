//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

interface IUserNameV1 {
    function setName(string memory name_, address user) external;

    function getName(address account) external view returns (string memory);

    function resolveName(string memory name_) external view returns (address);
}
