#!/bin/bash

docker run --rm -d \
  --gpus all \
  --network="kgai-network" \
  --log-driver=fluentd --log-opt fluentd-address=localhost:24224 --log-opt tag="coder" \
  --name kgai-coder \
  --mount source=coder-data,target=/home \
  --env PASSWORD=${CODER_PASS} \
  -p 8090:8090 \
  knowledgeai/kgai-coder:0.0.1