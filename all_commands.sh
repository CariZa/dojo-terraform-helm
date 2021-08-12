#!/bin/bash

# These are just the commands for the first part of the README with helm

# generate a new chart as a template to work from
mkdir charts   
helm create ./charts/example

# remove files from templates folder
rm -Rf ./charts/example/templates/tests
rm ./charts/example/templates/*.yaml
rm ./charts/example/templates/*.txt

# copy files over from use-files folder
cp ./use-files/k8s/* ./charts/example/templates

# copy over the values.yaml
cp ./use-files/values.yaml ./charts/example/values.yaml

# test the helm chart
helm lint ./charts/example
helm install example-chart --dry-run --debug ./charts/example 

# install the helm chart - it will apply and create the resources on minikube
helm install example-chart ./charts/example

# check the new resources have been created on kubernetes
kubectl get all -n example
