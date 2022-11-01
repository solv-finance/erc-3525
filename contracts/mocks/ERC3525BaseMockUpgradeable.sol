// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "../ERC3525Upgradeable.sol";

contract ERC3525BaseMockUpgradeable is Initializable, ContextUpgradeable, ERC3525Upgradeable {

    function initialize(string memory name_, string memory symbol_, uint8 decimals_) public virtual initializer {
        __ERC3525AllRound_init(name_, symbol_, decimals_);
    }

    function __ERC3525AllRound_init(string memory name_, string memory symbol_, uint8 decimals_) internal onlyInitializing {
        __ERC3525_init_unchained(name_, symbol_, decimals_);
    }

    function __ERC3525AllRound_init_unchained() internal onlyInitializing{
    }

    function mint(
        address mintTo_,
        uint256 tokenId_,
        uint256 slot_,
        uint256 value_
    ) public virtual {
        ERC3525Upgradeable._mint(mintTo_, tokenId_, slot_, value_);
    }

    function mintValue(
        uint256 tokenId_,
        uint256 value_
    ) public virtual {
        ERC3525Upgradeable._mintValue(tokenId_, value_);
    }

    function burn(uint256 tokenId_) public virtual {
        require(_isApprovedOrOwner(_msgSender(), tokenId_), "ERC3525: caller is not token owner nor approved");
        ERC3525Upgradeable._burn(tokenId_);
    }

    function burnValue(uint256 tokenId_, uint256 burnValue_) public virtual {
        require(_isApprovedOrOwner(_msgSender(), tokenId_), "ERC3525: caller is not token owner nor approved");
        ERC3525Upgradeable._burnValue(tokenId_, burnValue_);
    }

    uint256[50] private __gap;
}