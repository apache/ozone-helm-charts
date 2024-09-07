<!--
  Licensed to the Apache Software Foundation (ASF) under one
  or more contributor license agreements.  See the NOTICE file
  distributed with this work for additional information
  regarding copyright ownership.  The ASF licenses this file
  to you under the Apache License, Version 2.0 (the
  "License"); you may not use this file except in compliance
  with the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->

# Helm Chart for Apache Ozone

[Apache Ozone](https://ozone.apache.org) is a highly scalable, distributed storage for Analytics, Big data and Cloud Native applications.


## Introduction

This chart bootstraps an [Apache Ozone](https://ozone.apache.org) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Requirements

- Kubernetes cluster 1.28+
- Helm 3

## Helm charts repository
Use the following command to add the repository to Helm client configuration:
```shell
helm repo add ozone https://apache.github.io/ozone-helm-charts/
```

## Installing the chart
Install the chart with `ozone` release name:
```shell
helm install ozone ozone/ozone
```

## Uninstalling the chart
```shell
helm uninstall ozone
```

## Documentation

Documentation lives on the Apache Ozone [website](https://ozone.apache.org/docs/).

## Contributing

Want to help build Apache Ozone? Check out our [Contribution guidelines](https://github.com/apache/ozone/blob/master/CONTRIBUTING.md).
