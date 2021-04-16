#!/bin/bash
# Copyright (c) 2020 Red Hat, Inc.

git config --global url."https://$GITHUB_TOKEN@github.com/open-cluster-management".insteadOf  "https://github.com/open-cluster-management"

WORKDIR=`pwd`
cd ${WORKDIR}/..
git clone https://github.com/open-cluster-management/observability-kind-cluster.git
cd observability-kind-cluster
./setup.sh $1
if [ $? -ne 0 ]; then
    echo "Cannot setup environment successfully."
    exit 1
fi

cd ${WORKDIR}/..
git clone https://github.com/open-cluster-management/observability-e2e-test.git
cd observability-e2e-test
git checkout release-2.2

# run test cases
./cicd-scripts/tests.sh
if [ $? -ne 0 ]; then
    echo "Cannot pass all test cases."
    cat ./pkg/tests/results.xml
    exit 1
fi
