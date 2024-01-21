# Senior DevOps Engineer Technical Challenge


## Challenge Overview

## Task 1: Hello World Application
- I have used python with version 3.8, which is kind of newer and tackles security issues with libraries.
- Requirements file is already present in repo which can be used to install libraries
- You need a token, which is right now hardcoded in the APP (Not very viable but just for the sake of some authentication)
- Health endpoint just usees a simple healthcheck library, since the flask itself is only running application it will not give you any useful results

`Header: "X-Auth-Token": "T1&eWbYXNWG1w1^YGKDPxAWJ@^et^&kX"`
- Unit test are present to check the code functionality
- Makefile has been created to simulate test/build/push on local machine


## Task 2: Continuous Integration
For CI i have used github actions, but we can use alot of other option based on requirements.
- Github performs almost all the basic checks. This includes automated test, linting, code checks, whithout this step things wont move forward
- After checks have been passed, it will build and push image to docker repo, it is being configured using github secrets
- `main` branch is considered as the production branch, anything merged in that will automatically creates release and change the image tag in helm value file and create a PR for approval, merging can be automated as well but i dont like fully automation in production
- All other branches (except main) pushed will not generate release but will run all test/build steps, while images can be used for testing in staging. (Basically for all other repos we can change the image for DEV cluster), this step is same as prod but not implemented
- Tagging is based on the release. So it will be automated and next minor release wil be decided based on the last release
- I have not included automated checks for Container inspect, it was a lengthy task and required me to write some custom checks /code.
- Codecheck is done using bandit, i have skip its failure as it would always complain on hardcoded token. Normally, here we use tooling like Sonarqube/Codacy to have a coverage report as well
- CD will be done using ArgoCD, once we merge branch with new image, it will auto sync and start canary deployments using Argo Rollouts. I havent included that part in helmtemplate as i didnt had running argo instance on local.

GITHUB SECRETS:

```
CI_GITHUB_TOKEN
DOCKER_PASS
DOCKER_REGISTRY	
DOCKER_USER
```


## Task 3: Deploy application to kubernetes
In the repo there is fully developed helmchart for this application.
- You can deploy either via helm or for CD part we use ArgoCD
- It assumes that you already have ingress nginx controller running also for HPA to work you need metrics core.
- HPA scales on CPU, we can add other external metrics as well
- service listed on 80
- TLS part has not been added, i didnt have fully FQDN to generate certificates.
- `example.com` is the host you need to use before hitting the endpoints

## CLI
To test the local env, use the token from the last step in the Authorization header of your request. For example:
```bash
curl --request GET \
    --url http://minikubeip/app \
    --header  'X-Auth-Token: T1&eWbYXNWG1w1^YGKDPxAWJ@^et^&kX'
    --header  'Host: example.com'
```


## Note
There are alot of things which can be improved / done, happy to discuss in Next steps.