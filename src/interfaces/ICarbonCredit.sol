// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface ICarbonCredit {
    function mint(address _company, uint256 _amount) external;
    function retire(address _sender, uint256 _amount) external;
}