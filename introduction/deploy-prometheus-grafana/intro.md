
In this tutorial you will learn how to use [Prometheus](https://github.com/prometheus/prometheus) to scrape and store metrics from a sample application, and then use [Grafana](https://github.com/grafana/grafana)
to visualize the collected metrics.

## Let's get started

If you are not familiar with the OpenShift Container Platform, it's worth taking a few minutes to understand the basics of the platform as well as the environment that you will be using for this self paced tutorial. There is a [scenario](https://www.openshift.com/learn/courses/getting-started/) set up just for OpenShift introduction.

### Command Line Interface
In this scenario, you should have all the commands that you need available with the instructions on how to execute them.

The command line tool that we will be using as part of this tutorial is called the [*oc*](https://github.com/openshift/origin/) tool. This tool is written in the Go programming language and is a single executable that is provided for Windows, MacOS, and the Linux Operating Systems. If you are familiar with [Kubernetes](https://kubernetes.io/docs/tutorials/kubernetes-basics/), this tool encapsulates a lot of [*kubectl*](https://github.com/kubernetes/kubectl) commands.

### Web Console

OpenShift also provides a feature rich Web Console that provides a friendly graphical interface for interacting with the platform. The Web Console has both an Administrator Perspective and a Developer Perspective.

### The Environment

During this tutorial you will be using a hosted OpenShift 4.2 environment that is created just for you. This environment is not shared with other users of the system. <br>
Your environment will only be active for a one hour period. Keep this in mind before embarking on getting through the content. <br>
Each time you start this tutorial, a new environment will be created on the fly.

Let's get started!
