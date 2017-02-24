# Pivotal Status Check

This app is intended to let you have your acceptance state in Pivotal Tracker be reflected as a status check within your pull requests.

## Workflow That This Supports

Our pull requests get merged into Master (and deployed to Production) once they **fulfilled** the criteria below.. You are not allowed to merge to master unless these criteria are met:

* **2** peer reviews
* CI Tests pass
* Pivotal Story accepted

### What does it do

This app hooks into a Github webhook which communicates with it when a pull request has been created or updated. This app then checks the status of the pivotal story related to it. If it's accepted it'll return as a **success** to Github.
