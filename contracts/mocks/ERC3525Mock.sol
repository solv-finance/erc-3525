//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "../ERC3525Upgradeable.sol";
import "../utils/StringConvertor.sol";

contract ERC3525Mock is ERC3525Upgradeable {

    using StringConvertor for uint256;

    /**
     * @notice Properties of the slot, which determine the value of slot.
     */
    struct SlotDetail {
        address underlying;
        uint8 vestingType;
        uint32 maturity;
        uint32 term;
    }

    // slot => slotDetail
    mapping(uint256 => SlotDetail) private _slotDetails;

    function initialize(
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) public initializer {
        ERC3525Upgradeable.__ERC3525_init(name_, symbol_, decimals_);
    }

    function mint(
        address minter_,
        address underlying_,
        uint8 vestingType_,
        uint32 maturity_,
        uint32 term_,
        uint256 value_
    ) public {
        uint256 slot = _getSlot(underlying_, vestingType_, maturity_, term_);
        _slotDetails[slot] = SlotDetail({
            underlying: underlying_,
            vestingType: vestingType_,
            maturity: maturity_,
            term: term_
        });
        
        ERC3525Upgradeable._mintValue(minter_, slot, value_);
    }

    function getSlotDetail(uint256 slot_) public view returns (address, uint8, uint32, uint32) {
        SlotDetail storage slotDetail = _slotDetails[slot_];
        return (
            slotDetail.underlying, 
            slotDetail.vestingType, 
            slotDetail.maturity, 
            slotDetail.term
        );
    }

    /**
     * @dev Generate the value of slot by utilizing keccak256 algorithm to calculate the hash 
     * value of multi properties.
     */
    function _getSlot(
        address underlying_,
        uint8 vestingType_,
        uint32 maturity_,
        uint32 term_
    ) internal pure virtual returns (uint256 slot_) {
        return 
            uint256(
                keccak256(
                    abi.encodePacked(
                        underlying_,
                        vestingType_,
                        maturity_,
                        term_
                    )
                )
            );
    }

    function contractURI() public view override returns (string memory) {
        return 
            string(
                abi.encodePacked(
                    /* solhint-disable */
                    'data:application/json;base64,',
                    Base64.encode(
                        abi.encodePacked(
                            '{"name":"', 
                            name(),
                            '","description":"',
                            _contractDescription(),
                            '","image":"',
                            _contractImage(),
                            '","valueDecimals":"', 
                            uint256(valueDecimals()).toString(),
                            '"}'
                        )
                    )
                    /* solhint-enable */
                )
            );
    }

    function slotURI(uint256 slot_) public view override returns (string memory) {
        return
            string(
                abi.encodePacked(
                    /* solhint-disable */
                    'data:application/json;base64,',
                    Base64.encode(
                        abi.encodePacked(
                            '{"name":"', 
                            _slotName(slot_),
                            '","description":"',
                            _slotDescription(slot_),
                            '","image":"',
                            _slotImage(slot_),
                            '","properties":',
                            _slotProperties(slot_),
                            '}'
                        )
                    )
                    /* solhint-enable */
                )
            );
    }

    function tokenURI(uint256 tokenId_) public view override returns (string memory) {
        return 
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        abi.encodePacked(
                            /* solhint-disable */
                            '{"name":"',
                            _tokenName(tokenId_),
                            '","description":"',
                            _tokenDescription(tokenId_),
                            '","image":"',
                            _tokenImage(tokenId_),
                            '","balance":"',
                            balanceOf(tokenId_).toString(),
                            '","slot":"',
                            slotOf(tokenId_).toString(),
                            '","properties":',
                            _tokenProperties(tokenId_),
                            "}"
                            /* solhint-enable */
                        )
                    )
                )
            );
    }

    function _contractDescription() internal view virtual returns (string memory) {
        return "";
    }

    function _contractImage() internal view virtual returns (bytes memory) {
        return "";
    }

    function _slotName(uint256 slot_) internal view virtual returns (string memory) {
        slot_;
        return "";
    }

    function _slotDescription(uint256 slot_) internal view virtual returns (string memory) {
        slot_;
        return "";
    }

    function _slotImage(uint256 slot_) internal view virtual returns (bytes memory) {
        slot_;
        return "";
    }

    function _slotProperties(uint256 slot_) internal view returns (string memory) {
        SlotDetail storage slotDetail = _slotDetails[slot_];
        return 
            string(
                /* solhint-disable */
                abi.encodePacked(
                    '[',
                        abi.encodePacked(
                            '{"name":"underlying",',
                            '"description":"Address of the underlying token locked in this contract.",',
                            '"value":"', Strings.toHexString(uint256(uint160(slotDetail.underlying))), '",',
                            '"order":1,', 
                            '"display_type":"string"},'
                        ),
                        abi.encodePacked(
                            '{"name":"vesting_type",',
                            '"description":"Vesting type that represents the releasing mode of underlying assets.",',
                            '"value":', uint256(slotDetail.vestingType).toString(), ',',
                            '"order":2,', 
                            '"display_type":"number"},'
                        ),
                        abi.encodePacked(
                            '{"name":"maturity",',
                            '"description":"Maturity that all underlying assets would be completely released.",',
                            '"value":', uint256(slotDetail.maturity).toString(), ',',
                            '"order":3,', 
                            '"display_type":"date"},'
                        ),
                        abi.encodePacked(
                            '{"name":"term",',
                            '"description":"The length of the locking period (in seconds)",',
                            '"value":', uint256(slotDetail.term).toString(), ',',
                            '"order":4,', 
                            '"display_type":"number"}'
                        ),
                    ']'
                )
                /* solhint-enable */
            );
    }

    function _tokenName(uint256 tokenId_) internal view virtual returns (string memory) {
        // solhint-disable-next-line
        return 
            string(
                abi.encodePacked(
                    IERC3525Metadata(msg.sender).name(), 
                    " #", tokenId_.toString()
                )
            );
    }

    function _tokenDescription(uint256 tokenId_) internal view virtual returns (string memory) {
        tokenId_;
        return "";
    }


    function _tokenImage(uint256 tokenId_) internal view virtual returns (bytes memory) {
        tokenId_;
        return "";
    }

    function _tokenProperties(uint256 tokenId_) internal view returns (string memory) {
        uint256 slot = slotOf(tokenId_);
        SlotDetail storage slotDetail = _slotDetails[slot];
        
        return 
            string(
                abi.encodePacked(
                    /* solhint-disable */
                    '{"underlying":"',
                    Strings.toHexString(uint256(uint160(slotDetail.underlying))),
                    '","vesting_type":"',
                    uint256(slotDetail.vestingType).toString(),
                    '","maturity":',
                    uint256(slotDetail.maturity).toString(),
                    ',"term":',
                    uint256(slotDetail.term).toString(),
                    '}'
                    /* solhint-enable */
                )
            );
    }

}