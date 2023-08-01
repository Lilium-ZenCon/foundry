// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface ICarbonCredit {
    function grantMinterRole(address _company, bytes32 MINTER_ROLE) external;
    function revokeMinterRole(address _company, bytes32 MINTER_ROLE) external;
    function mint(address _company, uint256 _amount) external;
    function burn(address _company, uint256 _amount) external;
    function allowance(address _agent, address _ERC20Portal) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
}