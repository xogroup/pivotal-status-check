# Pivotal Status Check

[![CircleCI](https://circleci.com/gh/xogroup/pivotal-status-check/tree/master.svg?style=svg)](https://circleci.com/gh/xogroup/pivotal-status-check/tree/master) [![Known Vulnerabilities](https://snyk.io/test/github/xogroup/pivotal-status-check/badge.svg)](https://snyk.io/test/github/xogroup/pivotal-status-check)

This app is intended to let you have your acceptance state in Pivotal Tracker be reflected as a status check within your pull requests.

It hooks into a Github webhook which communicates with it when a pull request has been created or updated. This app then checks the status of the pivotal story related to it. If the story has been accepted, it'll return as a **success** to Github.

## Workflow That This Supports

Our pull requests get merged into Master (and deployed to Production) once they **fulfilled** the criteria below.. You are not allowed to merge to master unless these criteria are met:

* **2** peer reviews
* CI Tests pass
* Pivotal Story accepted

## Usage:

You can simply pull down the image hosted on [Dockerhub](https://hub.docker.com/r/justneph/pivotal-status-check/) and deploy.

Afterwards, you'll need to setup your environment with three environment variables

* Github Token [**GITHUB_ACCESS_TOKEN**]
* Pivotal API Token [**PIVOTAL_TRACKER_TOKEN**]
* Pivotal Project ID [**PIVOTAL_PROJECT_ID**]

You will need to deploy a **NEW** instance for **EACH** Pivotal Project Id.

## Deployment

***Out of Box Supported Deployment Environments:***
* [AWS ElasticBeanstalk](https://aws.amazon.com/elasticbeanstalk/)
  * ```make eb_release```
* [Heroku](http://www.heroku.com)
  * ```make heroku_release```

If you want to deploy your version of the app, simply call the above make command.

## Development

Make changes and run ```make test```
