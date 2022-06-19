//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/access/Ownable.sol";

/**
 * @notice Inspired by Controllable.sol
 * https://github.com/ensdomains/ens-contracts/blob/master/contracts/wrapper/Controllable.sol
 * */

abstract contract Shopable is Ownable {
    mapping(address => bool) public shops;

    event ShopManaged(address indexed shop, bool indexed active);

    function setShop(address shop, bool active) external onlyOwner {
        shops[shop] = active;
        emit ShopManaged(shop, active);
    }

    modifier onlyShop() {
        require(shops[msg.sender], "Shopable: shop not allowed");
        _;
    }
}
