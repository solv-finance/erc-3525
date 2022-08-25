//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC3525Upgradeable.sol";

contract ERC3525MintableUpgradeable is ERC3525Upgradeable {

    function initialize(
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) public initializer {
        ERC3525Upgradeable.__ERC3525_init(name_, symbol_, decimals_);
    }

    function mint(
        address minter_,
        uint256 slot_,
        uint256 value_
    ) public virtual {
        ERC3525Upgradeable._mintValue(minter_, slot_, value_);
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     */
    uint256[50] private __gap;
}
