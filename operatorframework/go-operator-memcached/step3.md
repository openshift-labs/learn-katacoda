Let's begin by inspecting the newly generated `api/v1alpha1/memcached_types.go` file for our Memcached API:

```
cat api/v1alpha1/memcached_types.go
```{{execute}}

In Kubernetes, every functional object (with some exceptions, i.e. ConfigMap) includes `spec` and `status`. Kubernetes functions by reconciling desired state (Spec) with the actual cluster state. We then record what is observed (Status). 

Also observe the `+kubebuilder` comment markers found throughout the file. `operator-sdk` makes use of a tool called [controler-gen](https://github.com/kubernetes-sigs/controller-tools) (from the [controller-tools](https://github.com/kubernetes-sigs/controller-tools) project) for generating utility code and Kubernetes YAML. More information on markers for config/code generation can be found [here](https://book.kubebuilder.io/reference/markers.html).

Let's now modify the `MemcachedSpec` and `MemcachedStatus` of the `Memcached` Custom Resource (CR) at `api/v1alpha1/memcached_types.go`

<br>
It should look like the file below:

<pre class="file">
package v1alpha1

import (
        metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// EDIT THIS FILE!  THIS IS SCAFFOLDING FOR YOU TO OWN!
// NOTE: json tags are required.  Any new fields you add must have json tags for the fields to be serialized.

// MemcachedSpec defines the desired state of Memcached
type MemcachedSpec struct {
	// +kubebuilder:validation:Minimum=0
	// Size is the size of the memcached deployment
	Size int32 `json:"size"`
}

// MemcachedStatus defines the observed state of Memcached
type MemcachedStatus struct {
	// Nodes are the names of the memcached pods
	Nodes []string `json:"nodes"`
}
</pre>

Add the `+kubebuilder:subresource:status` [marker](https://book.kubebuilder.io/reference/generating-crd.html#status) to add a [status subresource](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/#status-subresource) to the CRD manifest so that the controller can update the CR status without changing the rest of the CR object:

<pre class="file">
// Memcached is the Schema for the memcacheds API
// +kubebuilder:printcolumn:JSONPath=".spec.size",name=Desired,type=string
// +kubebuilder:printcolumn:JSONPath=".status.nodes",name=Nodes,type=string
// +kubebuilder:subresource:status
type Memcached struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   MemcachedSpec   `json:"spec,omitempty"`
	Status MemcachedStatus `json:"status,omitempty"`
}

func init() {
	SchemeBuilder.Register(&Memcached{}, &MemcachedList{})
}

</pre>

You can easily update this file by running the following command:

```
\cp /tmp/memcached_types.go api/v1alpha1/memcached_types.go
```{{execute}}
<br>
After modifying the `*_types.go` file, always run the following command to update the `zz_generated.deepcopy.go` file:

```
make generate
```{{execute}}
<br>

The above makefile target will invoke the controller-gen utility to update the api/v1alpha1/zz_generated.deepcopy.go file to ensure our API’s Go type definitons implement the runtime.Object interface that all Kind types must implement.


Now we can run the `make manifests` command to generate our customized CRD and additional object YAMLs.

```
make manifests
```{{execute}}
<br>

This makefile target will invoke controller-gen to generate the CRD manifests at config/crd/bases/cache.example.com_memcacheds.yaml.



Thanks to our comment markers, observe that we now have a newly generated CRD yaml that reflects the `spec.size` and `status.nodes` OpenAPI v3 schema validation and customized print columns.

```
cat config/crd/bases/cache.example.com_memcacheds.yaml
```{{execute}}
<br>
Deploy your Memcached Custom Resource Definition to the live OpenShift Cluster:

```
oc apply -f config/crd/bases/cache.example.com_memcacheds.yaml
```{{execute}}
<br>
Confirm the CRD was successfully created:

```
oc get crd memcacheds.cache.example.com -o yaml
```{{execute}}
