// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

/**
 * @title ILilium
 * @dev ILilium interface to interact with Lilium contract
 */
interface ILilium {
    function getToken(address _certifier) external view returns (address);
}
