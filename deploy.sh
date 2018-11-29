#! /bin/bash

docker build -t falkobenthin/multi-client:latest -t falkobenthin/multi-client:$GIT_SHA -f ./client/Dockerfile ./client
docker build -t falkobenthin/multi-server:latest -t falkobenthin/multi-server:$GIT_SHA -f ./server/Dockerfile ./server
docker build -t falkobenthin/multi-worker:latest -t falkobenthin/multi-worker:$GIT_SHA -f ./server/Dockerfile ./worker

docker push falkobenthin/multi-client:latest
docker push falkobenthin/multi-server:latest
docker push falkobenthin/multi-worker:latest

docker push falkobenthin/multi-client:$GIT_SHA
docker push falkobenthin/multi-server:$GIT_SHA
docker push falkobenthin/multi-worker:$GIT_SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=falkobenthin/multi-server:$GIT_SHA
kubectl set image deployments/client-deployment client=falkobenthin/multi-client:$GIT_SHA
kubectl set image deployments/worker-deployment worker=falkobenthin/multi-worker:$GIT_SHA

exit 0
