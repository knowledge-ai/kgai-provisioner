help: ## Lists available commands and their explanation
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

kafka-up: ## brings up a kafka dev cluster
	docker-compose -f kafka/kafka-compose.yml up -d

kafka-down: ## brings up a kafka dev cluster
	docker-compose -f kafka/kafka-compose.yml down

orientdb-up: ## brings up a kafka dev cluster
	docker-compose -f orientdb/orientdb-compose.yml up -d

orientdb-down: ## brings up a kafka dev cluster
	docker-compose -f orientdb/orientdb-compose.yml down

release-test: ## release test for java
	mvn deploy -Dregistry=https://maven.pkg.github.com/knowledge-io/kgio-java-commons -Dtoken=c53b53107bd9f0eae44492e33ad6aa5b3028f09b -DskipTests