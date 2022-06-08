//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/utils/Address.sol";
import "openzeppelin-contracts/contracts/utils/Base64.sol";

import "./library/IdToColor.sol";
import "./interfaces/IColoredToken.sol";
import "./abstracts/Shopable.sol";

contract ColoredToken is ERC721, IColoredToken, Shopable {
    using IdToColor for uint256;
    uint256 public immutable maxColor;

    constructor() ERC721("ColoredToken", "COLOR") {
        maxColor = 0xffffff;
    }

    function mintColor(uint256 id_, address receiver)
        external
        override
        onlyShop
    {
        require(id_ <= maxColor, "No more than 0xFFFFFF");
        _mint(receiver, id_);
    }

    function burnColor(uint256 id_) external override {
        require(ownerOf(id_) == msg.sender, "You should own the color");
        _burn(id_);
    }

    function ownerOf(uint256 id) public view override returns (address) {
        if (!_exists(id)) {
            return address(0);
        }
        return super.ownerOf(id);
    }

    function tokenURI(uint256 tokenId)
        public
        pure
        override
        returns (string memory)
    {
        string memory baseURI = _baseURI();
        string
            memory metadata = '{"name":"Beautiful color","description":"Small, on-chain, circle with unique color",';
        string memory image = _baseImage(tokenId);
        return
            string(
                abi.encodePacked(
                    baseURI,
                    Base64.encode(
                        bytes(
                            abi.encodePacked(metadata, '"image":"', image, '"}')
                        )
                    )
                )
            );
    }

    function _beforeTokenTransfer(
        address,
        address to,
        uint256
    ) internal view override {
        if (to != address(0)) {
            require(balanceOf(to) == 0, "Users cannot have several colors");
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function _baseImage(uint256 tokenId) internal pure returns (string memory) {
        string memory color = tokenId.toColor();

        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(
                        abi.encodePacked(
                            '<svg xmlns="http://www.w3.org/2000/svg" width="750" height="750" viewBox="0 0 100 100"><circle cx="50" cy="50" r="25" fill="',
                            color,
                            '" /></svg>'
                        )
                    )
                )
            );
    }
}
