//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/utils/Address.sol";
import "openzeppelin-contracts/contracts/utils/Base64.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";

import "../library/IdToColor.sol";
import "../interfaces/IColoredToken.sol";
import "../abstracts/Shopable.sol";

contract ColoredToken is ERC721, IColoredToken, Shopable {
    using Address for address payable;
    using Strings for uint256;
    using IdToColor for uint256;
    uint256 public immutable maxColor;

    constructor() ERC721("Unique Color Token", "COLOR") {
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

    function burnColor(uint256 id_) external payable override {
        require(msg.value >= 5 * 10**13, "Cost must at least 0.00005 ETH");
        require(ownerOf(id_) == msg.sender, "You should own the color");
        _burn(id_);
    }

    function withdraw() external onlyOwner {
        payable(msg.sender).sendValue(address(this).balance);
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
        string memory color = tokenId.toColor();
        string memory metadata = string(
            abi.encodePacked(
                '{"name":"Unique Color Token ',
                color,
                '","description":"This is a unique color from the Unique Color Token collection, ',
                color,
                " is the ",
                tokenId.toString(),
                ' on 16 777 215 colors.",'
            )
        );
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

    function contractURI() public pure returns (string memory) {
        string memory baseURI = _baseURI();
        string memory cover = _baseCover();
        return
            string(
                abi.encodePacked(
                    baseURI,
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"Unique Color Token","description":"This collection contains the 16 777 215 colors from 0x000000 to 0xFFFFFF, represented by the tokenID. Only one token from this collection can be held per account, so choose your color wisely. All metadata is stored on-chain (because its size is not that big).","image":"',
                                cover,
                                '"}'
                            )
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

    function _baseCover() internal pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(
                        '<svg xmlns="http://www.w3.org/2000/svg" width="750" height="750" viewBox="0 0 100 100"><circle cx="55" cy="40" r="15" fill="#00225577" /><circle cx="45" cy="60" r="17" fill="#99EE3377" /><circle cx="50" cy="80" r="30" fill="#DD228877" /><circle cx="80" cy="30" r="25" fill="#22CCEE77" /><circle cx="20" cy="20" r="19" fill="#66229977" /><circle cx="20" cy="70" r="13" fill="#EEDD3377" /><circle cx="80" cy="80" r="10" fill="#EE551177" /><circle cx="40" cy="30" r="20" fill="#4477DD77" /></svg>'
                    )
                )
            );
    }
}
