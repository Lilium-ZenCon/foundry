# Project Documentation

This repository contains essential documentation to guide you through the setup and usage of the project. Follow the steps below to get started:

## 1. Setting Up Environment

Before you begin, make sure you have the required environment variables properly configured. Create an environment by executing the following command:

```bash
$ make env
```
Ensure you provide the necessary parameters in the generated environment file.

To load the environment variables, use:

```bash
$ source env
```
## 2. Deployment

To deploy the DeployLilium.s.sol script, use the following command, replacing placeholders with appropriate values:

```bash
$ forge script script/DeployLilium.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY --verify --broadcast
```

## 3. Generating Documentation

Generate project documentation using:

```bash
$ forge doc
```

This command generates documentation based on the project's code and structure.

## 4. Viewing Documentation Locally

View the generated documentation locally by serving it on a local server at port 4000. Use:

```bash
$ forge doc --serve --port 4000
```

Access the documentation through your web browser by navigating to http://localhost:4000.

Explore and understand the project using the provided documentation. If you encounter any issues or need assistance, please reach out for support.

## 5. Deployed contracts

- The contract below is responsible for creating the registration entities and tokens for each entity:
https://sepolia.etherscan.io/address/0x0c2f52a0d357881fbad687fc420ed3fe9fc793b3
