The goal of this lab is to get a basic understanding of the three Open Containers Initiative (OCI) specificaitons that govern finding, running, building and sharing container - image, runtime, and distribution. At the highest level, containers are two things - files and processes - at rest and running. First, we will take a look at what makes up a [Container Repository](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.20722ydfjdj8) on disk, then we will look at what directives are defined to create a running [Container](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.j2uq93kgxe0e).

If you are interested in a slightly deeper understanding, take a few minutes to look at the OCI  work, it's all publicly available in GitHub repositories:

- [The Image Specification Overview](//github.com/opencontainers/image-spec/blob/master/spec.md#overview)
- [The Runtime Specification Abstract](//github.com/opencontainers/runtime-spec/blob/master/spec.md)
- [The Distributions Specification Use Cases](https://github.com/opencontainers/distribution-spec/blob/master/spec.md#use-cases)

Now, lets run some experiments to better understand these specifications.
