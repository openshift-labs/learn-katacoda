The Mcrouter Operator was built with the [Ansible Operator SDK](https://github.com/operator-framework/operator-sdk/blob/master/doc/ansible/user-guide.md). It is not yet intended for production use.

[Mcrouter](https://github.com/facebook/mcrouter) is a Memcached protocol router for scaling [Memcached](http://memcached.org/) deployments. It's a core component of cache infrastructure at Facebook and Instagram where mcrouter handles almost 5 billion requests per second at peak.

Mcrouter features:

* Memcached ASCII protocol
* Connection pooling
* Multiple hashing schemes
* Prefix routing
* Replicated pools
* Production traffic shadowing
* Online reconfiguration
* Flexible routing

Mcrouter is developed and maintained by Facebook.



At this point in our training, we should have a basic understanding of the *Operator pattern*. 
 - Ansible Operator is an Operator which is _powered by Ansible_. 
 - Custom Resource events trigger Ansible tasks as opposed to the traditional approach of handling these events with Go code.
