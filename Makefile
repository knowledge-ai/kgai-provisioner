help: ## Lists available commands and their explanation
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build-push-fluentd: ## builds a fluentd with specific configs and pushes to hub
	cd efk/fluentd && source build-push.sh && cd -

create-network: ## creates the kgai-network used as common network in all stacks
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

kgai-dev-up: ## brings up all KGAI apps in DEV -- use after all dependancies have been created
	docker-compose -f kgai/kgai-compose.yml up -d

kgai-dev-down: ## brings down all KGAI apps in DEV -- use after all dependancies have been created
	docker-compose -f kgai/kgai-compose.yml down

kgai-prd-up: ## brings up all KGAI apps in PRD -- use after all dependancies have been created
	. ./.env && docker-compose -f kgai/kgai-compose.yml -f kgai/kgai-prd-compose.yml up -d

kgai-prd-down: ## brings down all KGAI apps in PRD -- use after all dependancies have been created
	. ./.env && docker-compose -f kgai/kgai-compose.yml -f kgai/kgai-prd-compose.yml down

build-push-metricbeat: ## builds a metricbeat with specific configs and pushes to hub
	cd metricbeat/custom-metric && source build-push.sh && cd -

metricbeat-dev-up: ## brings up a metricbeat dev cluster
	docker-compose -f orientdb/orientdb-compose.yml up -d

metricbeat-dev-down: ## brings down a metricbeat dev cluster
	docker-compose -f metricbeat/metricbeat-compose.yml down

metricbeat-prd-up: ## brings up a metricbeat prd cluster
	. ./.env && docker-compose -f metricbeat/metricbeat-compose.yml -f metricbeat/metricbeat-compose-prd.yml up -d

metricbeat-prd-down: ## brings up a metricbeat prd cluster
	. ./.env && docker-compose -f metricbeat/metricbeat-compose.yml -f metricbeat/metricbeat-compose-prd.yml down

druid-dev-up: ## brings up a metricbeat dev cluster, its RAM beast make sure to run on clusters
	docker-compose -f druid/druid-compose.yml up -d

druid-dev-down: ## brings down a metricbeat dev cluster, its RAM beast make sure to run on clusters
	docker-compose -f druid/druid-compose.yml down

build-coder: ## builds a coder server with pytorch for cuda 10.2 support
	cd coder-nvidia/coder && source build.sh && cd -

coder-up: ## brings up a coder server with pytorch for cuda 10.2 support
	. ./.env && cd coder-nvidia && source run-coder.sh && cd -

coder-down: ## brings down a coder server with pytorch for cuda 10.2 support
	docker kill kgai-coder

ksql-cli: ## run an interractive ksql-cli based stack configurations
	docker exec -it ksqldb-cli ksql http://ksqldb-server:8088

build-kafka-broker: ## builds the custom broker with server.properties for single broker
	cd kafka/broker && source build-push.sh && cd -

chrome-up: ## runs a selenium chrome container exposing port 4444 and attached to the stack network
	cd chrome && source run-chrome.sh && cd -

chrome-up: ## runs a selenium chrome container exposing port 4444 and attached to the stack network
	docker run --network="kgai-network" --name kgai-chrome -d -p 4444:4444 selenium/standalone-chrome

chrome-down: ## kills the selenium chrome container
	docker kill kgai-chrome
