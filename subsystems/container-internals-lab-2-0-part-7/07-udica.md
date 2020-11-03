The default Containers SELinux policy does a really good job Podman in RHEL 8. Most containers "just work" but like any security tool, every now and then we need to make some customizations. Sometimes, especially as we expand the types of workloads that we run in containers, we bump into places where SELinux blocks us. Udica allows an administrator to customize the SELinux policy specifically for a workload for without being an SELinux expert.

For example, run the following container:

``podman run --name home-test -v /home/:/home:ro -it ubi8 ls /home``{{execute}}

The above command will fail because the default SELinux policy does not allow containers to mount /home as read only. We can verify that there are no allow rules which permit this command to be executed:

``sesearch -A -s container_t -t home_root_t -c dir -p read``{{execute}}

With Udica, we can quickly and easily configure SELinxux to allow us to mount /home as root. First, we have to extract the meta-data from our container:

``podman inspect home-test > home-test.json``{{execute}}

Now, Udica will analyze this data and create a custom SELinux policy for us:

``udica -j home-test.json home_test``{{execute}}

Use the SELinux tools to load the new policy:

``semodule -i home_test.cil /usr/share/udica/templates/{base_container.cil,home_container.cil}``{{execute}}

Now, run the same type of container again, but pass it a security option telling it to label the process to use our new custom policy, and it will execute without being blocked. First start the contaier:

``podman run --name home-test-2 --security-opt label=type:home_test.process -v /home/:/home:ro -id ubi8 bash``{{execute}}

Execute the ''ls'' command:

``podman exec -it home-test-2 ls /home``{{execute}} 

You will notice that the process is running with the "home_test.process" SELinux context:

``ps -efZ | grep home_test``{{execute}}

We can also verify that there is a new rule in this policy to allow our container to mount /home read only:

``sesearch -A -s home_test.process -t home_root_t -c dir -p read``{{execute}}

## Conclusions

It's always best to have SELinux enabled, especially with containers. It's so easy to create a custom SELinux policy with Udica, that you should never disable it. If you'd like to understand Udica a bit deeper, check out this great article, [Use udica to build SELinux policy for containers](https://fedoramagazine.org/use-udica-to-build-selinux-policy-for-containers/) by Lukas Vrabec. Now, let's move on to another tool. 
