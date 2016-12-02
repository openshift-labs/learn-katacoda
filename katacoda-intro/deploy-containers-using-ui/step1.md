OpenShift UI is accessed on port 8443. The Katacoda URL to access the dashboard is https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com. From here, you can administrate the entire OpenShift cluster and deploy new applications.

The UI exposes the underlying technology of Kubernetes with the enhancements made by OpenShift. The UI allows users to:

1) Manage existing and new deployments, including the service catalogue.

2) View build state.

3) View builds.

4) View and manage storage.

## Task

The aim of this task is to deploy the Docker Image _katacoda/docker-http-server:openshift-v1_ using the OpenShift dashboard.

1) Visit the dashboard at https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com

2) Login with the username **developer** and password **developer**. An account is created automatically for you.

3) OpenShift organises deployments into projects. A project can maintain multiple applications and deployments. Click the **New Project** button to start creating a new project. Create a new project called _webapp_ and click **Create**.

4) The first thing you will notice is a catalogue of pre-configured versions and images that can be deployed. In this scenario, we want to deploy our own Docker Image. Select **Deploy Image** tab, and as the **Image Name** use _katacoda/docker-http-server:openshift-v1_ and press the search icon.

5) After searching for the image, you will be shown an overview of the details and have the opportunity to set runtime configuration such as Environment Variables or Labels. In this case, it is not required. Click **Create** to create the project and launch the Docker Image.

5) OpenShift will confirm that the application/project has been created and provide the user with commands on how to configure the CLI. Click the link **Continue to overview.** to view the deployment status.
