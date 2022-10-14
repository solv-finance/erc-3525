// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

library StringConvertor {

    using Strings for uint256;

    /**
     * @dev Converts a `uint256` to its decimals representation according to the specified decimals.
     */
    function toDecimalsString(uint256 value, uint8 decimals) 
        internal
        pure
        returns (bytes memory)
    {
        uint256 base = 10 ** decimals;
        string memory round = (value / base).toString();
        string memory fraction = (value % base).toString();
        uint256 fractionLength = bytes(fraction).length;

        bytes memory fullStr = abi.encodePacked(round, '.');
        if (fractionLength < decimals) {
            for (uint8 i = 0; i < decimals - fractionLength; i++) {
                fullStr = abi.encodePacked(fullStr, '0');
            }
        }

        return abi.encodePacked(fullStr, fraction);
    }

    /**
     * @dev Trim a string from the right according to the specified cut length.
     */
    function trimRight(bytes memory self, uint256 cutLength) 
        internal 
        pure
        returns (bytes memory newString)
    {
        newString = new bytes(self.length - cutLength);
        for (uint256 index = 0; index < newString.length; index++) {
            newString[index] = self[index];
        }
    }

    /**
     * @dev Add thousands separator to a numeric string.
     */
    function addThousandsSeparator(bytes memory self) 
        internal
        pure
        returns (bytes memory newString) 
    {
        uint256 roundLength = 0;
        for (uint256 i = 0; i < self.length; i++) {
            if (self[i] != '.') {
                roundLength++;
            } else {
                break;
            }
        }

        if (roundLength <= 3) {
            newString = self;
        } else {
            newString = new bytes(self.length + (roundLength - 1) / 3);
            uint256 newIndex = 0;
            for (uint256 oriIndex = 0; oriIndex < self.length; oriIndex++) {
                newString[newIndex++] = self[oriIndex];
                if (oriIndex < roundLength - 1 && (roundLength - oriIndex - 1) % 3 == 0) {
                    newString[newIndex++] = ',';
                }
            }
        }
    }

}
