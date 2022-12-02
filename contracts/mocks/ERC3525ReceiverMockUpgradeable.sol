// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";
import "../IERC3525ReceiverUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract ERC3525ReceiverMockUpgradeable is Initializable, IERC165Upgradeable, IERC3525ReceiverUpgradeable {
    enum Error {
        None,
        RevertWithMessage,
        RevertWithoutMessage,
        Panic
    }

    bytes4 private _retval;
    Error private _error;

    event Received(address operator, uint256 fromTokenId, uint256 toTokenId, uint256 value, bytes data, uint256 gas);

    function __ERC3525ReceiverMock_init(bytes4 retval, Error error) internal onlyInitializing {
        __ERC3525ReceiverMock_init_unchained(retval, error);
    }

    function __ERC3525ReceiverMock_init_unchained(bytes4 retval, Error error) internal onlyInitializing {
        _retval = retval;
        _error = error;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return
            interfaceId == type(IERC165Upgradeable).interfaceId || 
            interfaceId == type(IERC3525ReceiverUpgradeable).interfaceId;
    } 

    function onERC3525Received(
        address operator, 
        uint256 fromTokenId, 
        uint256 toTokenId, 
        uint256 value, 
        bytes calldata data
    ) public override returns (bytes4) {
        if (_error == Error.RevertWithMessage) {
            revert("ERC3525ReceiverMock: reverting");
        } else if (_error == Error.RevertWithoutMessage) {
            revert();
        } else if (_error == Error.Panic) {
            uint256 a = uint256(0) / uint256(0);
            a;
        }
        emit Received(operator, fromTokenId, toTokenId, value, data, gasleft());
        return _retval;
    }


    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[59] private __gap;
}