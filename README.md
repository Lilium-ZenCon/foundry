# Project Documentation

This repository contains essential documentation to guide you through the setup and usage of the project. Follow the steps below to get started:

## 1. Setting Up Environment

- Before you begin, make sure you have the required environment variables properly configured. Create an environment by executing the following command:

    ```bash
    $ make env
    ```

Ensure you provide the necessary parameters in the generated environment file.

- To load the environment variables, use:

    ```bash
    $ source env
    ```

## 2. Deployment

- As we are using the Foundry framework to develop robustness contracts, an important change must be made in the rollup submodule:

    ```bash
    $ cd lib/rollups/onchain/rollups/contracts/library/LibOutputValidation.sol
    ```

    - Change line 16 to ```import {MerkleV2} from "../../../rollups-arbitration/lib/solidity-util/contracts/MerkleV2.sol";``` instead ```import {MerkleV2} from "@cartesi/util/contracts/MerkleV2.sol";```.

### 2.1 Deploy contracts on localhost

- To deploy the DeployLilium.s.sol script on localhost, use the following command, replacing placeholders with appropriate values:

    ```bash
    $ forge script script/DeployLilium.s.sol --rpc-url $HARDHAT_RPC_URL --private-key $PRIVATE_KEY_LILIUM_LOCALHOST --broadcast -vvvvv
    ```

### 2.2 Deploy contracts on testnet

- To deploy the DeployLilium.s.sol script on testnet, use the following command, replacing placeholders with appropriate values:

    ```bash
    $ forge script script/DeployLilium.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY_LILIUM --etherscan-api-key $ETHERSCAN_API_KEY --verify --broadcast -vvvvv
    ```

## 3. Interacting with Application:

- We have two ways to interact with the Lilium DApp depending on where it has been deployed.

### 3.1 Interacting with locally deployed application

- After the deploy on localhost (hardhat), we can create a certifier calling the function "newCertifier" from Lilium contract address:

    ```bash
    $ cast send <LILIUM_CONTRACT_ADDRESS> "newCertifier(string, string, address, string, string, uint8)" "QmRSAi9LVTuzN3zLu3kKeiESDug27gE3F6CFYvuMLFrt2C" "Verra" 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 "VERRA" "VRR" 18 --rpc-url $HARDHAT_RPC_URL --private-key $PRIVATE_KEY_LILIUM_LOCALHOST
    ```

- Now, as Certifier Agent, we can create a company with the cast command below:

    ```bash
    $ cast send <CERTIFIER_CONTRACT_ADDRESS> "newCompany(string, string, string, string, uint256, uint256, address)" "QmQp9iagQS9uEQPV7hg5YGwWmCXxAs2ApyBCkpcu9ZAK6k" "Gerdau" "Brazil" "Steelworks" 1000000000000 10000 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC --rpc-url $HARDHAT_RPC_URL --private-key $PRIVATE_KEY_CERTIFIER_LOCALHOST
    ```

- Before all of this, we, as company agent, have the interface with Cartesi Rollups ready to be called by Auction ans Verifier flows, but before of this we need deploy the cartesi machines verifier and auction, and then after this call the function ```setAuxiliarContracts``` to inform to the deployed DApp what addresses should he call.

    ```bash
    $ cast send <COMPANY_CONTRACT_ADDRESS> "setAuxiliarContracts(address, address)" <AUCTION-CARTESI-MACHINE-CONTRACT-ADDRESS> <VERIFIER-CARTESI-MACHINE-CONTRACT-ADDRESS> --rpc-url $HARDHAT_RPC_URL --private-key $PRIVATE_KEY_COMPANY_LOCALHOST
    ```

- Now, as the company's agent, we need to add a hardware address to the company by providing the HARDWARE_ROLE to your address. This hardware will check the real world state:

    ```bash
    $ cast send <COMPANY_CONTRACT_ADDRESS> "addHardwareDevice(address)" <HARDWARE-ADDRESS> --rpc-url $HARDHAT_RPC_URL --private-key $PRIVATE_KEY_COMPANY_LOCALHOST
    ```

- 

### 3.2 Interacting with testnet deployed application
@TODO

## 3. Generating Documentation

Generate project documentation using:

```bash
forge doc
```

This command generates documentation based on the project's code and structure.

## 4. Viewing Documentation Locally

View the generated documentation locally by serving it on a local server at port 4000. Use:

```bash
forge doc --serve --port 4000
```

Access the documentation through your web browser by navigating to <http://localhost:4000>.

Explore and understand the project using the provided documentation. If you encounter any issues or need assistance, please reach out for support.
