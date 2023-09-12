# Project Documentation

This repository contains essential documentation to guide you through the setup and usage of the project. Follow the steps below to get started:

## 1. Setting Up Environment

- Before you begin, make sure you have the required environment variables properly configured. Create an environment by executing the following command:

    ```bash
    $ make env
    ```

- Ensure you provide the necessary parameters in the generated environment file.

    - To load the environment variables, use:

        ```bash
        $ source env
        ```

## 2. Deployment

- As we are using the Foundry framework to develop robustness contracts, an important change must be made in the rollup submodule:

    ```bash
    $ cat lib/rollups/onchain/rollups/contracts/library/LibOutputValidation.sol
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
    $ forge script script/DeployLilium.s.sol --rpc-url $SEPOLIA_RPC_URL --etherscan-api-key $ETHERSCAN_API_KEY --verify --broadcast -vvvvv
    ```

## 3. Interacting with Application:

- We have two ways to interact with the Lilium DApp depending on where it has been deployed.

### 3.1 Interacting with locally deployed application

- After the deploy on localhost (hardhat), we can create a certifier calling the function "newCertifier" from Lilium contract address:

    ```bash
    $ cast send <LILIUM-CONTRACT-ADDRESS> "newCertifier(string, string, address, string, string, uint8)" "QmRSAi9LVTuzN3zLu3kKeiESDug27gE3F6CFYvuMLFrt2C" "Verra" $CERTIFIER_ADDRESS_HARDHAT "VERRA" "VRR" 18 --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY_LILIUM
    ```

- Now, as Certifier Agent, we can create a company with the cast command below:

    ```bash
    $ cast send <CERTIFIER-CONTRACT-ADDRESS> "newCompany(string, string, string, string, uint256, uint256, address)" "QmQp9iagQS9uEQPV7hg5YGwWmCXxAs2ApyBCkpcu9ZAK6k" "Gerdau" "Brazil" "Steelworks" 1000000000000 10000 $COMPANY_ADDRESS_HARDHAT --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY_LILIUM
    ```

- Before this you need deploy mocked auxiliary contracts to precede to the next step:

    ```bash
    $ forge script script/DeployMockAuxiliary.s.sol --rpc-url $HARDHAT_RPC_URL --broadcast -vvvvv
    ```

- Before all of this, we, as company agent, have the interface with Cartesi Rollups ready to be called by Auction ans Verifier flows, but before of this we need deploy the cartesi machines verifier and auction, and then after this call the function ```setAuxiliarContracts``` to inform to the deployed DApp what addresses should he call.

    ```bash
    $ cast send <COMPANY-CONTRACT-ADDRESS> "setAuxiliarContracts(address, address)" <AUCTION-CARTESI-MACHINE-CONTRACT-ADDRESS> <VERIFIER-CARTESI-MACHINE-CONTRACT-ADDRESS> --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY_LILIUM
    ```

- Now, as the company's agent, we need to add a hardware address to the company by providing the HARDWARE_ROLE to your address. This hardware will check the real world state:

    ```bash
    $ cast send <COMPANY_CONTRACT_ADDRESS> "addHardwareDevice(address)" $HARDWARE_ADDRESS_HARDHAT --rpc-url $HARDHAT_RPC_URL --private-key $PRIVATE_KEY_COMPANY_LOCALHOST
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

make lilium

make certifier lilium="0x09635F643e140090A9A8Dcd712eD6285858ceBef" cid="QmRSAi9LVTuzN3zLu3kKeiESDug27gE3F6CFYvuMLFrt2C" name="Verra" token_name="VERRA" token_symbol="VRR" token_decimals="18"

make company certifier="0xe73bc5bd4763a3307ab5f8f126634b7e12e3da9b" cid="QmQp9iagQS9uEQPV7hg5YGwWmCXxAs2ApyBCkpcu9ZAK6k" name="Gerdau" country="Brazil" industry="Steelworks" allowance="1000000000000" compensation_per_hour="10000"

make auxiliary company="0x4c0b513b595e1439ed7eff0e4d23543c3f135b92" verifier="0x142105FC8dA71191b3a13C738Ba0cF4BC33325e2" auction="0x142105FC8dA71191b3a13C738Ba0cF4BC33325e2"

cast send 0x5a723220579C0DCb8C9253E6b4c62e572E379945 "addInput(address, bytes)" 0x142105FC8dA71191b3a13C738Ba0cF4BC33325e2 0x487c16e3228c9d6be29e4bf400cd21be2e993bbd --private-key $PRIVATE_KEY_LILIUM_AGENT_HARDHAT


make lilium CONFIG="--network sepolia"

make certifier lilium="0x8d4669e24825cb7420d684859c6435a2c8bb6f6e" cid="QmRSAi9LVTuzN3zLu3kKeiESDug27gE3F6CFYvuMLFrt2C" name="Verra" token_name="VERRA" token_symbol="VRR" token_decimals="18" CONFIG=--"network sepolia"

make company certifier="0xf0d7de80a1c242fa3c738b083c422d65c6c7abf1" cid="QmQp9iagQS9uEQPV7hg5YGwWmCXxAs2ApyBCkpcu9ZAK6k" name="Gerdau" country="Brazil" industry="Steelworks" allowance="1000000000000" compensation_per_hour="10000" CONFIG=--"network sepolia"


make auxiliary company="0x3466aa7a1afbd39c61a3c4e58df51c40a8d49730" verifier="0xb6Ba902697e83332B3C47c7463b8AbD539337F6F" auction="0x142105FC8dA71191b3a13C738Ba0cF4BC33325e2"

make device company="0x3466aa7a1afbd39c61a3c4e58df51c40a8d49730" CONFIG="--network sepolia"