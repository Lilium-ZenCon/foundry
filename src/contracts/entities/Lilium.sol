// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {IPFS} from "@libraries/function/IPFS.sol";
import {ICarbonCredit} from "@interfaces/ICarbonCredit.sol";
import {LiliumData} from "@libraries/storage/LiliumData.sol";
import {Certifier} from "@contracts/entities/Certifier.sol";
import {CarbonCredit} from "@contracts/token/ERC20/CarbonCredit.sol";



contract Lilium {
    LiliumData.Lilium public lilium;

    mapping(address => address) public tokens;

    error Unouthorized();

    event NewCertifier(address _certifier, address _token);

    constructor(
        string memory _cid,
        address _InputBox,
        address _EtherPortal,
        address _ERC20Portal,
        address _PriceFeed,
        address _agent
    ) {
        lilium.cid = _cid;
        lilium.cartesiInputBox = _InputBox;
        lilium.cartesiEtherPortal = _EtherPortal;
        lilium.cartesiERC20Portal = _ERC20Portal;
        lilium.parityRouter = _PriceFeed;
        lilium.agent = _agent;
    }

    /**
     * @notice Restrict function to agent
     * @dev This modifier restrict function to agent
     */
    modifier onlyAgent() {
        if (msg.sender != lilium.agent) {
            revert Unouthorized();
        }
        _;
    }

    /**
     * @notice Get Cartesi Certifier Contract Address
     * @dev This function get cartesi certifier contract address. This function is external because it is called by certifier contract
     * @return address of cartesi certifier contract
     */
    function getToken(address _certifier) external view returns (address) {
        return tokens[_certifier];
    }

    /**
     * @notice Get Lilium URI
     * @dev This function get lilium URI using IPFS library
     * @return string URI
     */
    function getURI() public view returns (string memory) {
        return IPFS.getURI(lilium.cid);
    }

    /**
     * @notice Create new certifier
     * @dev This function create new certifier contract and token contract
     * @param _cid IPFS CID
     * @param _name certifier name
     * @param _agent certifier agent address
     * @param tokenName token name
     * @param tokenSymbol token symbol
     * @param decimals token decimals
     */
    function newCertifier(
        string memory _cid,
        string memory _name,
        address _agent,
        string memory tokenName,
        string memory tokenSymbol,
        uint256 decimals
    ) public onlyAgent {
        Certifier certifier = new Certifier(
            _cid,
            _name,
            address(this),
            _agent,
            lilium.agent,
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
