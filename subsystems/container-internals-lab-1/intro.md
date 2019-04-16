## Background
In this self paced tutorial you will gain a basic understanding of the moving parts that make up the typical container architecture.  This will cover container hosts, daemons, runtimes, images, orchestration, etc.

By the end of this lab you should be able to:
- Draw a diagram showing how the Linux kernel, services and daemons work together to create and deploy containers
- Internalize how the architecture of the kernel and supporting services affect security and performance
- Explain the API interactions of daemons and the host kernel to create isolated processes
- Command the nomenclature necessary to technically discuss container repositories, image layers, tags, registry server and other components


## Presentation
This presentation will give you a background to all of the concepts in this lab.
<iframe src="//www.slideshare.net/slideshow/embed_code/key/IP8llTLJKCRo3Z" width="595" height="485" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong> <a href="//www.slideshare.net/fatherliux/linux-container-internals-20-container-images" title="Linux container internals 2.0 container images" target="_blank">Linux container internals 2.0 container images</a> </strong> from <strong><a href="https://www.slideshare.net/fatherliux" target="_blank">fatherliux</a></strong> </div>


## Outline
- Containers Are Linux: Userspace libraries interact with the kernel to isolate processes
- Single Host Toolchain: Includes Docker runtime, Systemd, runc, and Libcontainer
- Multi-Host Toolchain: Includes Kubernetes/OpenShift
- Typical Architecture: Explains what a production cluster looks like
- Community Landscape: Explains the basics of the upstream projects and how they are contributing

## Start Scenario
Once you have watched the background video, continue to the exercises.
