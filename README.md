# Project Documentation

This repository contains essential documentation to guide you through the setup and usage of the project. Follow the steps below to get started:

## 1. Setting Up Environment

- Before you begin, make sure you have the required environment variables properly configured. Create an environment by executing the following command:

    ```bash
    $ make env
    ```

- Ensure you provide the necessary parameters (you can change the base64 image to other tree foto) in the generated environment file.

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

### 2.1 Deploy Lilium on localhost

- To deploy the DeployLilium.s.sol script on localhost, use the following command, replacing placeholders with appropriate values:

    ```bash
    $ make lilium
    ```

### 3.1 Interacting with locally deployed application

- After the deploy on localhost (hardhat), we can create a certifier calling the function "newCertifier" from Lilium contract address:

    ```bash
    $ make certifier lilium="0x09635F643e140090A9A8Dcd712eD6285858ceBef" cid="QmRSAi9LVTuzN3zLu3kKeiESDug27gE3F6CFYvuMLFrt2C" name="Verra" token_name="VERRA" token_symbol="VRR" token_decimals="18"
    ```

- Now, as Certifier Agent, we can create a company with the cast command below:

    ```bash
    $ make company certifier="0xe73bc5bd4763a3307ab5f8f126634b7e12e3da9b" cid="QmQp9iagQS9uEQPV7hg5YGwWmCXxAs2ApyBCkpcu9ZAK6k" name="Gerdau" country="Brazil" industry="Steelworks" allowance="1000000000000" compensation_per_hour="10000"
    ```

- Before all of this, we, as company agent, have the interface with Cartesi Rollups ready to be called by Auction ans Verifier flows, but before of this we need deploy the cartesi machines verifier and auction, and then after this call the function ```setAuxiliarContracts``` to inform to the deployed DApp what addresses should he call.

    ```bash
    $ make auxiliary company="0x487c16e3228c9d6be29e4bf400cd21be2e993bbd" verifier="0x142105FC8dA71191b3a13C738Ba0cF4BC33325e2" auction="0x142105FC8dA71191b3a13C738Ba0cF4BC33325e2"
    ```

- Now, as the company's agent, we need to add a hardware address to the company by providing the HARDWARE_ROLE to your address. This hardware will check the real world state:

    ```bash
    $ make device company="0x487c16e3228c9d6be29e4bf400cd21be2e993bbd"
    ```

- Now, as hardware you can verify the real world state and with this generate an MerkleTree Proof:

    ```base
    $ make verify company="0x487c16e3228c9d6be29e4bf400cd21be2e993bbd"
    ```

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