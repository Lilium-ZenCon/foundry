# LOADING ENV FILE
-include .env

.PHONY: lilium certifier auxiliary company auction bid device mint transfer verify finish-auction env help

# DEFAULT VARIABLES	
START_LOG = @echo "==================== START OF LOG ===================="
END_LOG = @echo "==================== END OF LOG ======================"

RPC_URL := $(HARDHAT_RPC_URL)
HARDWARE_ADDRESS := $(HARDWARE_ADDRESS_HARDHAT)
PRIVATE_KEY_USER := $(PRIVATE_KEY_USER_HARDHAT)
COMPANY_AGENT_ADDRESS := $(COMPANY_AGENT_ADDRESS_HARDHAT)
CERTIFER_AGENT_ADDRESS := $(CERTIFIER_AGENT_ADDRESS_HARDHAT)
PRIVATE_KEY_VERIFER_AGENT := $(PRIVATE_KEY_VERIFER_HARDHAT)
PRIVATE_KEY_LILIUM_AGENT := $(PRIVATE_KEY_LILIUM_AGENT_HARDHAT)
PRIVATE_KEY_COMPANY_AGENT := $(PRIVATE_KEY_COMPANY_AGENT_HARDHAT)
PRIVATE_KEY_HARDWARE_AGENT := $(PRIVATE_KEY_HARDWARE_AGENT_HARDHAT)
PRIVATE_KEY_CERTIFIER_AGENT := $(PRIVATE_KEY_CERTIFIER_AGENT_HARDHAT)
DEPLOY_NETWORK_ARGS := --rpc-url $(HARDHAT_RPC_URL) --broadcast -vvvvv

ifeq ($(findstring --network sepolia,$(CONFIG)),--network sepolia)
	RPC_URL := $(SEPOLIA_RPC_URL)
	DEPLOY_NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvvv
	HARDWARE_ADDRESS := $(HARDWARE_ADDRESS)
	PRIVATE_KEY_USER := $(PRIVATE_KEY_USER)
	PRIVATE_KEY_VERIFER := $(PRIVATE_KEY_VERIFER)
	COMPANY_AGENT_ADDRESS := $(COMPANY_AGENT_ADDRESS)
	CERTIFER_AGENT_ADDRESS := $(CERTIFER_AGENT_ADDRESS)
	PRIVATE_KEY_LILIUM_AGENT := $(PRIVATE_KEY_LILIUM_AGENT)
	PRIVATE_KEY_COMPANY_AGENT := $(PRIVATE_KEY_COMPANY_AGENT)
	PRIVATE_KEY_HARDWARE_AGENT := $(PRIVATE_KEY_HARDWARE_AGENT)
	PRIVATE_KEY_CERTIFIER_AGENT := $(PRIVATE_KEY_CERTIFIER_AGENT)
else ifeq ($(findstring --network mumbai,$(CONFIG)),--network mumbai)
	RPC_URL := $(MUMBAI_RPC_URL)
	DEPLOY_NETWORK_ARGS := --rpc-url $(MUMBAI_RPC_URL) --broadcast --verify --etherscan-api-key $(POLYGONSCAN_API_KEY) -vvvvv
	HARDWARE_ADDRESS := $(HARDWARE_ADDRESS)
	PRIVATE_KEY_USER := $(PRIVATE_KEY_USER)
	PRIVATE_KEY_VERIFER := $(PRIVATE_KEY_VERIFER)
	COMPANY_AGENT_ADDRESS := $(COMPANY_AGENT_ADDRESS)
	CERTIFER_AGENT_ADDRESS := $(CERTIFER_AGENT_ADDRESS)
	PRIVATE_KEY_LILIUM_AGENT := $(PRIVATE_KEY_LILIUM_AGENT)
	PRIVATE_KEY_COMPANY_AGENT := $(PRIVATE_KEY_COMPANY_AGENT)
	PRIVATE_KEY_HARDWARE_AGENT := $(PRIVATE_KEY_HARDWARE_AGENT)
	PRIVATE_KEY_CERTIFIER_AGENT := $(PRIVATE_KEY_CERTIFIER_AGENT)
else ifeq ($(findstring --network zeniq,$(CONFIG)),--network zeniq)
	RPC_URL := $(ZENIQ_RPC_URL)
	DEPLOY_NETWORK_ARGS := --rpc-url $(ZENIQ_RPC_URL) --broadcast -vvvvv
	HARDWARE_ADDRESS := $(HARDWARE_ADDRESS)
	PRIVATE_KEY_USER := $(PRIVATE_KEY_USER)
	PRIVATE_KEY_VERIFER := $(PRIVATE_KEY_VERIFER)
	COMPANY_AGENT_ADDRESS := $(COMPANY_AGENT_ADDRESS)
	CERTIFER_AGENT_ADDRESS := $(CERTIFER_AGENT_ADDRESS)
	PRIVATE_KEY_LILIUM_AGENT := $(PRIVATE_KEY_LILIUM_AGENT)
	PRIVATE_KEY_COMPANY_AGENT := $(PRIVATE_KEY_COMPANY_AGENT)
	PRIVATE_KEY_HARDWARE_AGENT := $(PRIVATE_KEY_HARDWARE_AGENT)
	PRIVATE_KEY_CERTIFIER_AGENT := $(PRIVATE_KEY_CERTIFIER_AGENT)
endif

define deploy_lilium
	$(START_LOG)
	@forge script script/DeployLilium.s.sol $(DEPLOY_NETWORK_ARGS)
	$(END_LOG)
endef

define create_certifier
	$(START_LOG)
	@cast send $(1) "newCertifier(string, string, address, string, string, uint8)" $(2) $(3) $(CERTIFIER_AGENT_ADDRESS) $(4) $(5) $(6) --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY_LILIUM_AGENT)
	$(END_LOG)
endef

define create_company
	$(START_LOG)
	@cast send $(1) "newCompany(string, string, string, string, uint256, uint256, address)" $(2) $(3) $(4) $(5) $(6) $(7) $(COMPANY_AGENT_ADDRESS) --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY_CERTIFIER_AGENT)
	$(END_LOG)
endef

define new_auction
	$(START_LOG)
	@cast send $(1) "newAuction(uint256, uint256, uint256)" $(2) $(3) $(4) --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY_COMPANY_AGENT)
	$(END_LOG)
endef

define finish_auction
	$(START_LOG)
	@cast send $(1) "finishAuction()" --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY_COMPANY_AGENT)
	$(END_LOG)
endef

define new_bid
	$(START_LOG)
	@cast send $(1) "newBid(uint256)" $(2) --value $(3) --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY_USER)
	$(END_LOG)
endef

define add_device
	$(START_LOG)
	@cast send $(1) "addHardwareDevice(address)" $(HARDWARE_ADDRESS) --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY_COMPANY_AGENT)
	$(END_LOG)
endef

define mint
	$(START_LOG)
	@cast send $(1) "mint(uint256 _amount)" $(2) --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY_COMPANY_AGENT)
	$(END_LOG)
endef

define transfer
	$(START_LOG)
	@cast send $(1) "transfer(address, uint256)" $(2) $(3) --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY_COMPANY_AGENT)
	$(END_LOG)
endef

define auxiliary
	$(START_LOG)
	@cast send $(1) "setAuxiliaryContracts(address, address)" $(2) $(3) --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY_COMPANY_AGENT)
	$(END_LOG)
endef

define verify
	$(START_LOG)
	@cast send $(1) "verifyRealWorldState(string)" $(2) --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY_VERIFER_AGENT)
	$(END_LOG)
endef

env: .env.tmpl
	cp .env.tmpl .env

help:
	@echo "Usage:"
	@echo "  make deploy [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""
	@echo ""
	@echo "  make fund [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""

lilium:
	@echo "Deploying Lilium..."
	@$(deploy_lilium)

certifier:
	@echo "You, as a lilium's agent, are creating a certifier..."
	@$(call create_certifier, $(lilium), $(CERTIFER_AGENT_ADDRESS))

auxiliary:
	@echo "You, as the company's agent, are defining the ancillary contracts..."
	@$(call auxiliary, $(company), $(verifier), $(auction))

company:
	@echo "You, as a certifier's agent, are creating a company..."
	@$(call create_company, $(certifier), $(COMPANY_AGENT_ADDRESS))

auction:
	@echo "You, as a company's agent, are creating an auction..."
	@$(call new_auction, $(company))

bid:
	@echo "You, as a user, are bidding..."
	@$(call new_bid, $(company))

device:
	@echo "You, as a company's agent, are adding a device to the verifier system..."
	@$(call add_device, $(company))

mint:
	@echo "You, as a company's agent, are minting tokens..."
	@$(call mint, $(company))

transfer:
	@echo "You, as a company's agent, are transfering tokens..."
	@$(call transfer, $(company), $(to))

verify:
	@echo "You, as a verifier's device, are verifying the real world state..."
	@$(call verify, $(company), $(REAL_WORLD_DATA))

finish-auction:
	@echo "You, as a company's agent, are finishing the auction..."
	@$(call finish_auction, $(company))