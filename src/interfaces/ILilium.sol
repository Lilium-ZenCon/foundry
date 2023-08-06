// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

interface ILilium {
    function getToken(address _certifier) external view returns (address);
}