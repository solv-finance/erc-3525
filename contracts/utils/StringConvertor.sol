// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

library StringConvertor {
    using Strings for uint256;

    /**
     * @dev Converts a `uint256` to its ASCII `string` representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        return value.toString();
    }

    function uint2decimal(uint256 self, uint8 decimals) internal pure returns (bytes memory) {
        uint256 base = 10**decimals;
        string memory round = (self / base).toString();
        string memory fraction = (self % base).toString();
        uint256 fractionLength = bytes(fraction).length;

        bytes memory fullStr = abi.encodePacked(round, ".");
        if (fractionLength < decimals) {
            for (uint8 i = 0; i < decimals - fractionLength; i++) {
                fullStr = abi.encodePacked(fullStr, "0");
            }
        }

        return abi.encodePacked(fullStr, fraction);
    }

    function trim(bytes memory self, uint256 cutLength) internal pure returns (bytes memory newString) {
        newString = new bytes(self.length - cutLength);
        uint256 index = newString.length;
        unchecked {
            while (index-- > 0) {
                newString[index] = self[index];
            }
        }
    }

    function addThousandsSeparator(bytes memory self) internal pure returns (bytes memory newString) {
        if (self.length <= 6) {
            return self;
        }

        newString = new bytes(self.length + (self.length - 4) / 3);
        uint256 oriIndex = self.length - 1;
        uint256 newIndex = newString.length - 1;
        for (uint256 i = 0; i < self.length; i++) {
            unchecked {
                if (i >= 6 && i % 3 == 0) {
                    newString[newIndex--] = ",";
                }
                newString[newIndex--] = self[oriIndex--];
            }
        }
    }
}
