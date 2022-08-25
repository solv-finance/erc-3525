//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC3525MintableUpgradeable.sol";

contract ERC3525BurnableUpgradeable is ERC3525MintableUpgradeable {
    function burn(uint256 tokenId_) public {
        require(_msgSender() == ERC3525Upgradeable.ownerOf(tokenId_), "only owner");
        ERC3525Upgradeable._burn(tokenId_);
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     */
    uint256[50] private __gap;
}
