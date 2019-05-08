**NOTE**: The current lab environment in Katacoda is **not** setup with OVS netowrking, so this lab cannot be completed. We hope to add this lab back in once we have a new environment set up in Katacoda. Until then, read through the below to get an understanding of how networking works in a production OpenShift environment.

The goal of this exercise is to gain a basic understanding of the overlay network that enables multi-container networking. On any node, inspect the openvswtich container. Notice that the container is started with the following three options: --privileged --net=host --pid=host. These three options make this container super privileged similar to running a normal process as root. They also place the containerized process in the host's network namespace and process id namespace. Essentially, this privileged container only uses mount namespace to utilize a container image for delivery of software - hence, it has very limited containment.


``ps -ef | grep "name openvswitch" | grep -v grep``


Output:

``/usr/bin/docker-current run --name openvswitch --rm --privileged --net=host --pid=host -v /lib/modules:/lib/modules -v /run:/run -v /sys:/sys:ro -v /etc/origin/openvswitch:/etc/openvswitch openshift3/openvswitch:v3.4.1.10``
 

Exec into the container and look at the network. We have to run this command from inside of the openvswitch contianer because OVS is NOT installed on the Atomic Host. This really demonstrates the elegance of Linux Contianers. Even software such as Open vSwitch can be placed in a container. Notice that the tun0 interface has a different IP address on each node in the OpenShift cluster. Run the "ip addr" command on several masters or nodes in the cluster.

``docker exec -t openvswitch ovs-vsctl show``{{execute}}

``docker exec -t openvswitch ip addr``{{execute}}


Inspect the flow rules. There are specific flow rules for each of the other nodes in the cluster. OpenShift manages all of this for the administrator as nodes are added/removed.

``docker exec -t openvswitch ovs-ofctl dump-flows br0 --protocols=OpenFlow13 | grep nw_dst=10.1``


Output:

``REG0[],goto_table:1
 cookie=0x0, duration=89147.397s, table=5, n_packets=0, n_bytes=0, priority=300,ip,nw_dst=10.1.0.1 actions=output:2
 cookie=0x0, duration=89147.374s, table=5, n_packets=0, n_bytes=0, priority=200,ip,nw_dst=10.1.0.0/24 actions=goto_table:7
 cookie=0x0, duration=89147.357s, table=5, n_packets=0, n_bytes=0, priority=100,ip,nw_dst=10.1.0.0/16 actions=goto_table:8
 cookie=0x0, duration=89147.233s, table=8, n_packets=0, n_bytes=0, priority=100,ip,nw_dst=10.1.4.0/24 actions=move:NXM_NX_REG0[]->NXM_NX_TUN_ID[0..31],set_field:192.168.122.205->tun_dst,output:1
 cookie=0x0, duration=89147.204s, table=8, n_packets=0, n_bytes=0, priority=100,ip,nw_dst=10.1.1.0/24 actions=move:NXM_NX_REG0[]->NXM_NX_TUN_ID[0..31],set_field:192.168.122.201->tun_dst,output:1
 cookie=0x0, duration=89147.180s, table=8, n_packets=0, n_bytes=0, priority=100,ip,nw_dst=10.1.2.0/24 actions=move:NXM_NX_REG0[]->NXM_NX_TUN_ID[0..31],set_field:192.168.122.202->tun_dst,output:1
 cookie=0x0, duration=89147.145s, table=8, n_packets=0, n_bytes=0, priority=100,ip,nw_dst=10.1.5.0/24 actions=move:NXM_NX_REG0[]->NXM_NX_TUN_ID[0..31],set_field:192.168.122.203->tun_dst,output:1
 cookie=0x0, duration=89147.040s, table=8, n_packets=0, n_bytes=0, priority=100,ip,nw_dst=10.1.3.0/24 actions=move:NXM_NX_REG0[]->NXM_NX_TUN_ID[0..31],set_field:192.168.122.204->tun_dst,output:1``


