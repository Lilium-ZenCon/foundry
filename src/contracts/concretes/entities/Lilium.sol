// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {IPFS} from "@libraries/function/IPFS.sol";
import {LiliumData} from "@libraries/storage/LiliumData.sol";
import {Certifier} from "@contracts/concretes/entities/Certifier.sol";
import {CarbonCredit} from "@contracts/concretes/token/ERC20/CarbonCredit.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract Lilium is AccessControl {
    mapping(address => address[]) clients;

    LiliumData.Lilium public lilium;

    bytes32 constant AGENT_ROLE = keccak256("AGENT_ROLE");

    constructor(string memory _cid, string memory _name, address _agent) {
        lilium.cid = _cid;
        lilium.name = _name;
        _grantRole(DEFAULT_ADMIN_ROLE, _agent);
        _grantRole(AGENT_ROLE, _agent);
    }

    function getURI() public view returns (string memory) {
        return IPFS.getURI(lilium.cid);
    }

    function addAgent(address _newAagent) public onlyRole(AGENT_ROLE) {
        _grantRole(DEFAULT_ADMIN_ROLE, _newAagent);
        _grantRole(AGENT_ROLE, _newAagent);
    }

    function removeAgent(address _agent) public onlyRole(AGENT_ROLE) {
        _revokeRole(DEFAULT_ADMIN_ROLE, _agent);
        _revokeRole(AGENT_ROLE, _agent);
    }

    function setClient(address _client) private {
        clients[address(this)].push(_client);
    }

    function newCertifier(
        string memory _cid,
        string memory _name,
        address _agent,
        string memory tokenName,
        string memory tokenSymbol,
        uint256 decimals
    ) public onlyRole(AGENT_ROLE) {
        CarbonCredit token = new CarbonCredit(
            tokenName,
            tokenSymbol,
            decimals,
            _agent
        );
        Certifier certifier = new Certifier(
            _cid,
            _name,
            _agent,
            address(token)
        );
        setClient(address(certifier));
    }
}
