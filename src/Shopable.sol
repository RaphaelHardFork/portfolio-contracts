//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

abstract contract Shopable {
    address public shop;

    function setShop(address shop_) external {
        if (shop != address(0)) {
            require(msg.sender == shop, "Only shop have access");
        }
        shop = shop_;
    }

    modifier onlyShop() {
        require(msg.sender == shop, "Only shop have access");
        _;
    }
}
