## Background
In this self paced tutorial you will gain a basic understanding of the moving parts that make up the typical container architecture.  This will cover container hosts, daemons, runtimes, images, orchestration, etc.

By the end of this lab you should be able to:
- Draw a diagram showing how the Linux kernel, services and daemons work together to create and deploy containers
- Internalize how the architecture of the kernel and supporting services affect security and performance
- Explain the API interactions of daemons and the host kernel to create isolated processes
- Command the nomenclature necessary to technically discuss container repositories, image layers, tags, registry server and other components


## Presentation
This presentation will give you a background to all of the concepts in this lab.
<iframe src="https://www.slideshare.net/fatherliux/slideshelf" width="615px" height="470px" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:none;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe>

## Outline
- Containers Are Linux: Userspace libraries interact with the kernel to isolate processes
- Single Host Toolchain: Includes Docker runtime, Systemd, runc, and Libcontainer
- Multi-Host Toolchain: Includes Kubernetes/OpenShift
- Typical Architecture: Explains what a production cluster looks like
- Community Landscape: Explains the basics of the upstream projects and how they are contributing

## Start Scenario
Once you have watched the background video, continue to the exercises.
