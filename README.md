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

1. Pull down docker image:  [Dockerhub](https://hub.docker.com/r/justneph/pivotal-status-check/)
1. Set up your deployment environment (```eb create```, etc)
1. Run the release command related to that application deployment environment
1. Setup your environment with these environment variables
  * Github Token [**GITHUB_ACCESS_TOKEN**]
  * Pivotal API Token [**PIVOTAL_TRACKER_TOKEN**]
  * Pivotal Project ID [**PIVOTAL_PROJECT_ID**]

  * ** For Github Enterprise Support: **
    * Github Enterprise API URL (* yourdomain.com/api/v3*) [**GITHUB_ENTERPRISE_API**]
1. Set up your [webhook](https://developer.github.com/webhooks/) on your Github repository
  * Payload URL:
    * **  YOUR_APPLICATION_URL/accepted_status_check **
    * *** Let me select individual events. ***
    * Choose the following events:
      * Pull request
      * Push
1. Github branch format with Pivotal Story ID at the end (snakecase) (* eg: * ```some_feature_PIVOTAL_STORY_ID``` )

1. Profit

### Note

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

## Gotchas

* If you receive a 404 ensure that the token you're using has access to the repository, the status check is running on
