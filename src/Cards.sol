//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";

import "./abstracts/Reserve.sol";
import "./abstracts/Shopable.sol";
import "./interfaces/ICards.sol";

contract Cards is ICards, Reserve, Shopable, ERC1155Supply {
    string public name = "Useless playing cards";
    string public symbol = "CARDS";

    uint256 private _lastBoosterId;
    uint256[] internal _cardsAmount;
    mapping(uint256 => uint256[]) private _boosterLink;

    constructor(string memory uri_) ERC1155(uri_) {
        _setReserve(9990);
        _lastBoosterId = 10002;
        uint256[] memory cardsAmount = new uint256[](5);
        cardsAmount[0] = 1;
        cardsAmount[1] = 1;
        cardsAmount[2] = 1;
        cardsAmount[3] = 1;
        cardsAmount[4] = 1;
        _cardsAmount = cardsAmount;
    }

    function deliverBooster(address account) external override onlyShop {
        unchecked {
            _lastBoosterId++;
        }
        _mint(account, _lastBoosterId, 1, "");

        uint256[] memory cards = _findEdition(
            _drawReserve(block.number * block.timestamp, 5)
        );

        _boosterLink[_lastBoosterId] = cards;
        _mintBatch(msg.sender, cards, _cardsAmount, "");
    }

    function deliverCards(address account, uint256 boosterId)
        external
        override
        onlyShop
    {
        uint256[] memory cards = _boosterLink[boosterId];
        _burn(account, boosterId, 1);
        safeBatchTransferFrom(msg.sender, account, cards, _cardsAmount, "");
        delete _boosterLink[boosterId];
    }

    function uri(uint256 tokenId) public view override returns (string memory) {
        string memory stringId = tokenId >= 10000
            ? "10000"
            : Strings.toString(tokenId);

        return
            string(
                abi.encodePacked(
                    super.uri(0), // constructor=> "ipfs://{hash}/"
                    stringId,
                    ".json"
                )
            );
    }

    function _findEdition(uint256[] memory cards_)
        internal
        pure
        returns (uint256[] memory)
    {
        uint256[] memory cards = new uint256[](5);

        for (uint256 i = 0; i < 5; ) {
            uint256 edition = cards_[i] < 9720 ? 1 : 55;
            cards[i] = ((cards_[i] - 1) % 54) + edition;
            unchecked {
                ++i;
            }
        }

        return cards;
    }
}
