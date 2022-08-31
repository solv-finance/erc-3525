// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IERC3525TokenIdGenerator {

    function getNewTokenIdForMinting(uint256 fromTokenId) external returns (uint256);

    // function getNewTokenIdFor

}