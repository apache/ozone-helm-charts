<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->

# Helm charts for Apache Ozone

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

This repository provides Helm charts for installing Apache Ozone on Kubernetes.

## Helm charts repository
Use the following command to add the repository to Helm client configuration:
```shell
helm repo add ozone https://apache.github.io/ozone-helm-charts/
```
List the latest stable versions of available Helm charts with the commands:
```shell
helm repo update ozone
helm search repo ozone
```

## Contributing

All contributions are welcome.
Please open a [Jira](https://issues.apache.org/jira/projects/HDDS/issues) issue and create a pull request.

For more information, please check the [Contribution guideline](https://github.com/apache/ozone/blob/master/CONTRIBUTING.md).

## License

The Apache Ozone project is licensed under the Apache 2.0 License.

See the [LICENSE](./LICENSE) file for details.
