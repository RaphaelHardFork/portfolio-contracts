//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "../interfaces/v1/IUserNameV1.sol";
import "../abstracts/Shopable.sol";

contract UserNameV1 is Shopable, IUserNameV1 {
    // upgrade Shopable!
}
