// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {MerkleProof} from "openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";
import {LibDiamond} from "../libraries/LibDiamond.sol";
import {ERC721Facet} from "./ERC721Facet.sol";

contract MerkleFacet {
    bytes32 public merkleRoot;

    function setMerkleRoot(bytes32 _merkleRoot) external {

        merkleRoot = _merkleRoot;
    }

    function claim(uint256 tokenId, bytes32[] calldata proof) external {
        LibDiamond.DiamondStorage storage l = LibDiamond.diamondStorage();

        // Verify that the user is in the merkle tree
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender, tokenId));
        require(MerkleProof.verify(proof, merkleRoot, leaf), "Invalid proof");

        // Mint the NFT to the user
        _mint(msg.sender, tokenId);
    }

    function _mint(address to, uint256 tokenId) internal {
        // Logic to mint the ERC721 token
        ERC721Facet._mint(to, tokenId);
    }
}
