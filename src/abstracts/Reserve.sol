//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

/**
 * @dev Contract designed to have a renewable stock for NFT launch
 *      This contract is designed to provide id from 1 to X (no zero allowed)
 * */

abstract contract Reserve {
    uint256 private _reserveSize;
    mapping(uint256 => uint256) private _reserve;

    function _drawReserve(uint256 _randomNumber, uint256 draws) internal returns (uint256[] memory selection) {
        require(draws <= 10, "Too much draws");
        require(_reserveSize >= draws, "No more items in reserve");

        uint256 randomNumber = _randomNumber % _reserveSize; // between 0 and {_reserveSize - 1}
        selection = new uint256[](draws);

        // loops for draws, each loop change {reserve}
        for (uint256 i = 0; i < draws; ) {
            selection[i] = _selectIndex(randomNumber);
            if (_reserveSize == 0) break;
            unchecked {
                randomNumber = (randomNumber * randomNumber) % _reserveSize;
                ++i;
            }
        }
    }

    function _selectIndex(uint256 index) internal returns (uint256 id) {
        index = index == 0 ? 1 : index;

        // assign id
        id = _reserve[index] == 0 ? index : _reserve[index];
        // swap
        _reserve[index] = _reserve[_reserveSize] == 0 ? _reserveSize : _reserve[_reserveSize];
        delete _reserve[_reserveSize];
        // pop
        --_reserveSize;
    }

    function _setReserve(uint256 reserveSize_) internal {
        require(_reserveSize == 0, "Reserve still active");
        _reserveSize = reserveSize_;
    }

    function reserveSize() external view returns (uint256) {
        return _reserveSize;
    }

    function reserveAt(uint256 index) external view returns (uint256) {
        return _reserve[index];
    }
}
