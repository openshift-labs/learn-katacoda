In this self paced tutorial, you will learn how to use OpenShift Do (`odo`) to build and deploy applications on the OpenShift Container Platform.

## What is `odo`?
`odo` is a CLI tool for developers who are writing, building, and deploying applications on OpenShift. With `odo`, developers get an opinionated CLI tool that supports fast, iterative development. `odo` abstracts away Kubernetes and OpenShift concepts so developers can focus on what's most important to them: code.

`odo` was created to improve the developer experience with OpenShift. Existing tools such as `oc` are more operations-focused and require a deep understanding of Kubernetes and OpenShift concepts. `odo` is designed to be simple and concise so you can focus on coding rather than how to deploy your application. Since `odo` can build and deploy your code to your cluster immediately after you save your changes, you benefit from instant feedback and can validate your changes in real-time. `odo`'s syntax and design is centered around concepts already familiar to developers, such as project, application, and component.

## The Environment

During this scenario, you will be using a hosted OpenShift environment that is created just for you. This environment is not shared with other users of the system. Because each user completing this scenario has their own environment, we had to make some concessions to ensure the overall platform is stable and used only for this training. For that reason, your environment will only be active for a one hour period. Keep this in mind before you get started on the content. Each time you start this training, a new environment will be created on the fly.

The OpenShift environment created for you is running version 3.11 of the open source OKD. This deployment is a self-contained environment that provides everything you need to be successful learning the platform. This includes a command line environment, the OpenShift web console, public URLs, and sample applications.

Let's get started!
