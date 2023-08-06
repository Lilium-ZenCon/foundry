// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface ICarbonCredit {
    function setCartesi(address _cartesiCertifier) external;
    function mint(address _company, uint256 _amount) external;
    function grantRole(bytes32 role, address account) external;
}