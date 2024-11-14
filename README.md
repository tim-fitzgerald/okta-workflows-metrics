# okta-workflow-logs
## Overview
This repo contains a Lambda function and API Gateway service designed to receive and parse logs from Okta Workflows, to be sent to Datadog as metrics. It was created using the AWS SAM CLI tool for ease of deployment and local testing. This README is basically the default one that comes with the SAM CLI, with some additional information about the project.

## ToDo:
* currently the API Gateway deployment does not include creating an API Key and Usage Plan - both are required to use this in production. After the app has been deployed you will need to manually create both of these in the UI and attach them to a deployment stage for the Gateway. This only has to be done once, one first deployment, and not for every subsequent code update.

## Deploy the sample application

The Serverless Application Model Command Line Interface (SAM CLI) is an extension of the AWS CLI that adds functionality for building and testing Lambda applications. It uses Docker to run your functions in an Amazon Linux environment that matches Lambda. It can also emulate your application's build environment and API.

To use the SAM CLI, you need the following tools.

* SAM CLI - [Install the SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html)
* Ruby - `rbenv install 3.3.0`
* Docker - [Install Docker community edition](https://hub.docker.com/search/?type=edition&offering=community)

To build and deploy your application for the first time, run the following in your shell:

```bash
sam build
sam deploy --guided
```

## Use the SAM CLI to build and test locally

Build your application with the `sam build` command.

```bash
okta-workflow-metrics$ sam build
```

The SAM CLI installs dependencies defined in `okta-workflow-logs-function/Gemfile`, creates a deployment package, and saves it in the `.aws-sam/build` folder.

Test a single function by invoking it directly with a test event. An event is a JSON document that represents the input that the function receives from the event source. Test events are included in the `events` folder in this project.

Run functions locally and invoke them with the `sam local invoke` command.

```bash
okta-workflow-metrics$ sam local invoke OktaWorkflowLogsFunction --event events/flow_complete.json
```

```bash
sam delete --stack-name okta-workflow-logs
```

