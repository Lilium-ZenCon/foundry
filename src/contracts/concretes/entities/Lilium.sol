// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {IPFS} from "@libraries/function/IPFS.sol";
import {ICarbonCredit} from "@interfaces/ICarbonCredit.sol";
import {LiliumData} from "@libraries/storage/LiliumData.sol";
import {Certifier} from "@contracts/concretes/entities/Certifier.sol";
import {CarbonCredit} from "@contracts/concretes/token/ERC20/CarbonCredit.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract Lilium is AccessControl {
    LiliumData.Lilium public lilium;

    mapping(address => address) public tokens;

    bytes32 constant AGENT_ROLE = keccak256("AGENT_ROLE");
    bytes32 constant COMPANY_ROLE = keccak256("COMPANY_ROLE");

    event NewCertifier(address _certifier, address _token);

    constructor(
        string memory _cid,
        string memory _name,
        address _InputBox,
        address _EtherPortal,
        address _ERC20Portal,
        address _PriceFeed,
        address _agent
    ) {
        lilium.cid = _cid;
        lilium.name = _name;
        lilium.cartesiInputBox = _InputBox;
        lilium.cartesiEtherPortal = _EtherPortal;
        lilium.cartesiERC20Portal = _ERC20Portal;
        lilium.parityRouter = _PriceFeed;
        _grantRole(DEFAULT_ADMIN_ROLE, _agent);
        _grantRole(AGENT_ROLE, _agent);
    }

    function getToken(address _certifier) external view returns (address) {
        return tokens[_certifier];
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

    function newCertifier(
        string memory _cid,
        string memory _name,
        address _agent,
        address _masterAgent,
        string memory tokenName,
        string memory tokenSymbol,
        uint256 decimals
    ) public onlyRole(AGENT_ROLE) {
        Certifier certifier = new Certifier(
            _cid,
            _name,
            address(this),
            _agent,
            _masterAgent,
            lilium.cartesiInputBox,
            lilium.cartesiEtherPortal,
            lilium.cartesiERC20Portal
        );
        CarbonCredit token = new CarbonCredit(
            tokenName,
            tokenSymbol,
            decimals,
            address(certifier),
            lilium.parityRouter,
            lilium.cartesiInputBox
        );
        tokens[address(certifier)] = address(token);
        emit NewCertifier(address(certifier), address(token));
    }
}
