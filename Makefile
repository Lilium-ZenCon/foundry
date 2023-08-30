# Inclua o arquivo .env
include .env
export

# Comandos
env: .env.tmpl
	cp .env.tmpl .env

deploy-lilium-hardhat:
	@echo "Deploying Lilium..."
	@forge script script/DeployLilium.s.sol --rpc-url $(HARDHAT_RPC_URL)


new-auction-hardhat:
	@echo "Creating an auction..."
	@cast send $(COMPANY_CONTRACT_ADDRESS) "newAuction(uint256, uint256, uint256)" 100000 1 1 --rpc-url $(HARDHAT_RPC_URL) --private-key $(PRIVATE_KEY_AGENT_HARDHAT)

new-bid-hardhat:
	@echo "Creating a bid..."
	@cast send $(COMPANY_CONTRACT_ADDRESS) "newBid(uint256)" 9000 --value 0.9ether --rpc-url $(HARDHAT_RPC_URL) --private-key $(PRIVATE_KEY_USER_HARDHAT)
create-certifier-hardhat:
	@echo "Creating a certifier..."
	@cast send $(LILIUM_ADDRESS_HARDHAT) "newCertifier(string, string, address, string, string, uint8)" "QmRSAi9LVTuzN3zLu3kKeiESDug27gE3F6CFYvuMLFrt2C" "Verra" $(CERTIFIER_ADDRESS_HARDHAT) "VERRA" "VRR" 18 --rpc-url $(HARDHAT_RPC_URL) --private-key $(PRIVATE_KEY_LILIUM_HARDHAT)

create-company-hardhat:
	@echo "Creating a company..."
	@cast send $(CERTIFIER_CONTRACT_ADDRESS) "newCompany(string, string, string, string, uint256, uint256, address)" "QmQp9iagQS9uEQPV7hg5YGwWmCXxAs2ApyBCkpcu9ZAK6k" "Gerdau" "Brazil" "Steelworks" 1000000000000 10000 $(COMPANY_ADDRESS_HARDHAT) --rpc-url $(HARDHAT_RPC_URL) --private-key $(PRIVATE_KEY_CERTIFIER_HARDHAT)

deploy-mock-auxiliary-hardhat:
	@echo "Deploying mocked auxiliary contracts..."
	@forge script script/DeployMockAuxiliary.s.sol --rpc-url $(HARDHAT_RPC_URL)

set-auxiliar-contracts-hardhat:
	@echo "Setting auxiliar contracts..."
	@cast send $(COMPANY_CONTRACT_ADDRESS) "setAuxiliarContracts(address, address)" $(AUCTION_CARTESI_MACHINE_CONTRACT_ADDRESS) $(VERIFIER_CARTESI_MACHINE_CONTRACT_ADDRESS) --rpc-url $(HARDHAT_RPC_URL) --private-key $(PRIVATE_KEY_COMPANY_HARDHAT)

add-hardware-device-hardhat:
	@echo "Adding a hardware device..."
	@cast send $(COMPANY_CONTRACT_ADDRESS) "addHardwareDevice(address)" $(HARDWARE_ADDRESS_HARDHAT) --rpc-url $(HARDHAT_RPC_URL) --private-key $(PRIVATE_KEY_COMPANY_HARDHAT)

mint-hardhat:
	@echo "Minting tokens..."
	@cast send $(COMPANY_CONTRACT_ADDRESS) "mint(address, uint256)" $(AGENT_ADDRESS_HARDHAT) 1000000000000 --rpc-url $(HARDHAT_RPC_URL) --private-key $(PRIVATE_KEY_AGENT_HARDHAT)

transfer-hardhat:
	@echo "Transfering tokens..."
	@cast send $(COMPANY_CONTRACT_ADDRESS) "transfer(address, uint256)" $(AGENT_ADDRESS_HARDHAT) 1000000 --rpc-url $(HARDHAT_RPC_URL) --private-key $(PRIVATE_KEY_AGENT_HARDHAT)

verify-real-world-state-hardhat:
	@echo "Verifying real world state..."
	@cast send $(COMPANY_CONTRACT_ADDRESS) "verifyRealWorldState(string)" $(REAL_WORLD_DATA) --rpc-url $(HARDHAT_RPC_URL) --private-key $(PRIVATE_KEY_VERIFER_HARDHAT)

increase-allowance-hardhat:
	@echo "Increasing allowance..."
	@cast send $(COMPANY_CONTRACT_ADDRESS) "increaseAllowance()" --rpc-url $(HARDHAT_RPC_URL) --private-key $(PRIVATE_KEY_AUCTION_HARDHAT)

finish-auction-hardhat:
	@echo "Finishing auction..."
	@cast send $(COMPANY_CONTRACT_ADDRESS) "finishAuction()" --rpc-url $(HARDHAT_RPC_URL) --private-key $(PRIVATE_KEY_AUCTION_HARDHAT)