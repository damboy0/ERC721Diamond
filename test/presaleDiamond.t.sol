// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/Diamond.sol";
import "../contracts/facets/ERC721Facet.sol";
import "../contracts/facets/MerkleFacet.sol";
import "../contracts/facets/PresaleFacet.sol";
import "openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";

contract TestContract is Test {
    Diamond diamond;
    ERC721Facet erc721Facet;
    MerkleFacet merkleFacet;
    PresaleFacet presaleFacet;

    bytes32 merkleRoot = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;

    function setUp() public {
        // Deploy Diamond and Facets
        diamond = new Diamond();
        erc721Facet = new ERC721Facet();
        merkleFacet = new MerkleFacet();
        presaleFacet = new PresaleFacet();

        // Initialize the diamond with facets
        diamond.addFacet(address(erc721Facet));
        diamond.addFacet(address(merkleFacet));
        diamond.addFacet(address(presaleFacet));

        // Set the Merkle root for the MerkleFacet
        merkleFacet.setMerkleRoot(merkleRoot);
    }

    function testPresaleBuy() public {
        uint256 value = 0.03 ether; // Buy 0.03 ETH worth of NFTs
        presaleFacet.buyPresale{value: value}();

        assertEq(erc721Facet.balanceOf(address(this)), 3); // Should receive 3 NFTs
    }

    function testClaimWithValidMerkleProof() public {
        // Declare and initialize the Merkle proof
        bytes32; // Create an array with 2 elements
        proof[0] = 0xabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdef;
        proof[1] = 0xabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdefabcdef;

        // Try claiming an NFT with the valid proof
        merkleFacet.claim(1, proof);

        // Check if the NFT was claimed correctly
        assertEq(erc721Facet.ownerOf(1), address(this));
    }
}
