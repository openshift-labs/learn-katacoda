The default SELinux rules do a really good job in RHEL with Podman. Most containers "just work" but sometimes as the different types of workloads that we run in containers expands, we bump into places where SELinux blocks us. Udica allows us to customize Linux policies for specific workloads without being an SELinux expert.

For example, run the following container:

``podman run -v /home:/home:ro -v /var/spool:/var/spool:rw -p 21:21 -it ubi8  bash``{{execute}}

The default SELinux policy This container does three things which are not permitted by default: 

Mounts /home as read only
Mounts /var/spool as read/write
Exposes port tcp/21

You can see this by looking at the SELinux log. There's no rule to allow a containerized process (container_t):

sesearch -A -s container_t -t home_root_t -c dir -p read

TODO: finish from here: https://fedoramagazine.org/use-udica-to-build-selinux-policy-for-containers/

I'm thinking a simplified version with only one rule might work to shorten the lab.

