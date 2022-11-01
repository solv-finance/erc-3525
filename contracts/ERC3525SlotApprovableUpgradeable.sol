// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "./ERC3525SlotEnumerableUpgradeable.sol";
import "./extensions/IERC3525SlotApprovable.sol";

contract ERC3525SlotApprovableUpgradeable is Initializable, ContextUpgradeable, ERC3525SlotEnumerableUpgradeable, IERC3525SlotApprovable {

    // @dev owner => slot => operator => approved
    mapping(address => mapping(uint256 => mapping(address => bool))) private _slotApprovals;

    function __ERC3525SlotApprovable_init() internal onlyInitializing {
    }

    function __ERC3525SlotApprovable_init_unchained() internal onlyInitializing {
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC3525SlotEnumerableUpgradeable) returns (bool) {
        return
            interfaceId == type(IERC3525SlotApprovable).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function setApprovalForSlot(
        address owner_,
        uint256 slot_,
        address operator_,
        bool approved_
    ) public payable virtual override {
        require(_msgSender() == owner_ || isApprovedForAll(owner_, _msgSender()), "ERC3525SlotApprovable: caller is not owner nor approved for all");
        _setApprovalForSlot(owner_, slot_, operator_, approved_);
    }

    function isApprovedForSlot(
        address owner_,
        uint256 slot_,
        address operator_
    ) public view virtual override returns (bool) {
        return _slotApprovals[owner_][slot_][operator_];
    }

    function approve(address to_, uint256 tokenId_) public payable virtual override(IERC721, ERC3525Upgradeable) {
        address owner = ERC3525Upgradeable.ownerOf(tokenId_);
        uint256 slot = ERC3525Upgradeable.slotOf(tokenId_);
        require(to_ != owner, "ERC3525: approval to current owner");

        require(
            _msgSender() == owner || 
            ERC3525Upgradeable.isApprovedForAll(owner, _msgSender()) ||
            ERC3525SlotApprovableUpgradeable.isApprovedForSlot(owner, slot, _msgSender()),
            "ERC3525: approve caller is not owner nor approved for all/slot"
        );

        _approve(to_, tokenId_);
    }

    function approve(uint256 tokenId_, address to_, uint256 value_) public payable virtual override(IERC3525, ERC3525Upgradeable) {
        address owner = ERC3525Upgradeable.ownerOf(tokenId_);
        uint256 slot = ERC3525Upgradeable.slotOf(tokenId_);
        require(to_ != owner, "ERC3525: approval to current owner");

        require(
            _msgSender() == owner || 
            ERC3525Upgradeable.isApprovedForAll(owner, _msgSender()) ||
            ERC3525SlotApprovableUpgradeable.isApprovedForSlot(owner, slot, _msgSender()),
            "ERC3525: approve caller is not owner nor approved for all/slot"
        );
        
        _approveValue(tokenId_, to_, value_);
    }

    function _setApprovalForSlot(
        address owner_,
        uint256 slot_,
        address operator_,
        bool approved_
    ) internal virtual {
        require(owner_ != operator_, "ERC3525SlotApprovable: approve to owner");
        _slotApprovals[owner_][slot_][operator_] = approved_;
        emit ApprovalForSlot(owner_, slot_, operator_, approved_);
    }

    function _isApprovedOrOwner(address operator_, uint256 tokenId_) internal view virtual override returns (bool) {
        _requireMinted(tokenId_);
        address owner = ERC3525Upgradeable.ownerOf(tokenId_);
        uint256 slot = ERC3525Upgradeable.slotOf(tokenId_);
        return (
            operator_ == owner ||
            getApproved(tokenId_) == operator_ ||
            ERC3525Upgradeable.isApprovedForAll(owner, operator_) ||
            ERC3525SlotApprovableUpgradeable.isApprovedForSlot(owner, slot, operator_)
        );
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     */
    uint256[49] private __gap;
}