//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

interface ICards {
    function deliverBooster(address account) external;

    function deliverCards(address account, uint256 boosterId) external;
}
