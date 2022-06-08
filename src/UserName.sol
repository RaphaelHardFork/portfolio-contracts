//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "./interfaces/IUserName.sol";
import "./abstracts/Shopable.sol";

contract UserName is Shopable, IUserName {
    mapping(address => string) private _names;
    mapping(bytes32 => address) private _resolvers;

    function setName(string memory name_, address user)
        external
        override
        onlyShop
    {
        require(
            bytes(name_).length <= 32 && bytes(name_).length > 0,
            "Name length is not accepted"
        );
        bytes32 digest = keccak256(bytes(name_));

        string memory oldName = getName(user);
        if (bytes(oldName).length != 0) {
            delete _resolvers[keccak256(bytes(oldName))];
        }

        require(
            _resolvers[digest] == address(0),
            "This name is already chosen"
        );
        _resolvers[digest] = user;
        _names[user] = name_;
    }

    function getName(address account)
        public
        view
        override
        returns (string memory)
    {
        return _names[account];
    }

    function resolveName(string memory name_)
        public
        view
        override
        returns (address)
    {
        return _resolvers[keccak256(bytes(name_))];
    }
}
