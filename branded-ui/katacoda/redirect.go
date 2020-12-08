package main

func getRedirectUrl(course string, scenario string) string {
 oldScenarios := map[string]string{
    "introduction/playground-openshift37": "/playgrounds/openshift37",
    "introduction/playground-openshift36": "/playgrounds/openshift36",
    "introduction/fis-deploy-app": "/middleware/fis-deploy-app",
    "introduction/brms-loan-application": "/middleware/brms-loan-application",
    "introduction/rhoar-getting-started-nodejs": "/middleware/rhoar-getting-started-nodejs",
    "introduction/rhoar-getting-started-wfswarm": "/middleware/rhoar-getting-started-wfswarm",
    "introduction/rhoar-getting-started-spring": "/middleware/rhoar-getting-started-spring",
    "introduction/rhoar-getting-started-vertx": "/middleware/rhoar-getting-started-vertx",
    "operators/": "/operatorframework",
  }

  return oldScenarios[course + "/" + scenario]
}
