// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IERC3525MetadataDescriptor {

    function generateContractURI() external view returns (string memory);

    function generateSlotURI(uint256 slot) external view returns (string memory);
    
    function generateTokenURI(uint256 tokenId) external view returns (string memory);

}