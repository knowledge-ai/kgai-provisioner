help: ## Lists available commands and their explanation
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build-push-fluentd: ## builds a fluentd with specific configs and pushes to hub
	cd efk/fluentd && source build-push.sh && cd -

create-network: # creates the kgai-network used as common network in all stacks
	docker network create kgai-network

efk-dev-up: ## brings up a efk dev cluster
	docker-compose -f efk/efk-compose.yml up -d

efk-dev-down: ## brings up a efk dev cluster
	docker-compose -f efk/efk-compose.yml down

efk-prd-up: ## brings up a efk dev cluster
	docker-compose -f efk/efk-compose.yml -f efk/efk-compose-prd.yml up -d

efk-prd-down: ## brings up a efk dev cluster
	docker-compose -f efk/efk-compose.yml -f efk/efk-compose-prd.yml down

kafka-dev-up: ## brings up a kafka dev cluster
	docker-compose -f kafka/kafka-compose.yml up -d

kafka-dev-down: ## brings up a kafka dev cluster
	docker-compose -f kafka/kafka-compose.yml down

kafka-prd-up: ## brings up a kafka dev cluster
	docker-compose -f kafka/kafka-compose.yml -f kafka/kafka-compose-prd.yml up -d

kafka-prd-down: ## brings up a kafka dev cluster
	docker-compose -f kafka/kafka-compose.yml -f kafka/kafka-compose-prd.yml down

orientdb-create-db-dev: ## provisions databases in a dev orientdb cluster
	orientdb/create-db.sh

orientdb-create-db-prd: ## provisions databases in a prd orientdb cluster
	export SETUP_PRD=1 && orientdb/create-db.sh && unset SETUP_PRD

orientdb-dev-up: ## brings up a orientdb dev cluster
	docker-compose -f orientdb/orientdb-compose.yml up -d

orientdb-dev-down: ## brings up a orientdb dev cluster
	docker-compose -f orientdb/orientdb-compose.yml down

orientdb-prd-up: ## brings up a orientdb prd cluster
	. ./.env && docker-compose -f orientdb/orientdb-compose.yml -f orientdb/orientdb-compose-prd.yml up -d

orientdb-prd-down: ## brings up a orientdb prd cluster
	. ./.env && docker-compose -f orientdb/orientdb-compose.yml -f orientdb/orientdb-compose-prd.yml down

kgai-up: ## brings up all KGAI apps -- use after all dependancies have been created
	docker-compose -f kgai/kgai-compose.yml up -d

kgai-down: ## brings down all KGAI apps -- use after all dependancies have been created
	docker-compose -f kgai/kgai-compose.yml down
