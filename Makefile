help: ## Lists available commands and their explanation
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

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

orientdb-up-dev: ## brings up a orientdb dev cluster
	docker-compose -f orientdb/orientdb-compose.yml up -d

orientdb-down-dev: ## brings up a orientdb dev cluster
	docker-compose -f orientdb/orientdb-compose.yml down

orientdb-up-prd: ## brings up a orientdb prd cluster
	. ./.env && docker-compose -f orientdb/orientdb-compose.yml -f orientdb/orientdb-compose-prd.yml up -d

orientdb-down-prd: ## brings up a orientdb prd cluster
	. ./.env && docker-compose -f orientdb/orientdb-compose.yml -f orientdb/orientdb-compose-prd.yml down
