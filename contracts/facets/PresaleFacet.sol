// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibDiamond} from "../libraries/LibDiamond.sol";
import {ERC721Facet} from "./ERC721Facet.sol";

contract PresaleFacet {
    uint256 public constant PRICE_PER_NFT = 1 ether / 30; // 1 ETH = 30 NFTs
    uint256 public constant MINIMUM_PURCHASE = 0.01 ether;

    function buyPresale() external payable {
        require(msg.value >= MINIMUM_PURCHASE, "Minimum purchase is 0.01 ETH");

        uint256 numNFTs = msg.value / PRICE_PER_NFT;
        require(numNFTs > 0, "Not enough ETH for any NFTs");

        LibDiamond.DiamondStorage storage l = LibDiamond.diamondStorage();
        
        for (uint256 i = 0; i < numNFTs; i++) {
            // Mint NFTs sequentially
            uint256 tokenId = l._nextTokenId++;
            _mint(msg.sender, tokenId);
        }
    }

    function _mint(address to, uint256 tokenId) internal {
        ERC721Facet._mint(to, tokenId);
    }
}
