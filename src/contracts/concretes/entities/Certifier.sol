// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {IPFS} from "@libraries/function/IPFS.sol";
import {Company} from "@contracts/concretes/entities/Company.sol";
import {CompanyData} from "@libraries/storage/CompanyData.sol";

import {CertifierData} from "@libraries/storage/CertifierData.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract Certifier is AccessControl {
    CertifierData.Certifier public certifier;

    mapping(address => address[]) clients;

    bytes32 constant AGENT_ROLE = keccak256("AGENT_ROLE");

    constructor(string memory _cid, string memory _name, address _token, address _agent) {
        certifier.cid = _cid;
        certifier.name = _name;
        certifier.token = _token;
        _grantRole(DEFAULT_ADMIN_ROLE, _agent);
        _grantRole(AGENT_ROLE, _agent);
    }

    function getURI() public view returns (string memory) {
        return IPFS.getURI(certifier.cid);
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

    function newCompany(
        string memory _cid,
        string memory _name,
        address _token,
        string memory _country,
        string memory _industry,
        uint256 _allowance,
        uint256 _compensation,
        address _agent
    ) public onlyRole(AGENT_ROLE) {
        Company company = new Company(
            _cid,
            _name,
            _token,
            _country,
            _industry,
            _allowance,
            _compensation,
            _agent
        );
        setClient(address(company));
    }
}
