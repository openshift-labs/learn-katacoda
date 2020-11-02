Let's begin by inspecting the newly generated `api/v1alpha1/podset_types.go` file for our PodSet API:

```
cat api/v1alpha1/podset_types.go
```{{execute}}

In Kubernetes, every functional object (with some exceptions, i.e. ConfigMap) includes `spec` and `status`. Kubernetes functions by reconciling desired state (Spec) with the actual cluster state. We then record what is observed (Status). 

Also observe the `+kubebuilder` comment markers found throughout the file. `operator-sdk` makes use of a tool called [controler-gen](https://github.com/kubernetes-sigs/controller-tools) (from the [controller-tools](https://github.com/kubernetes-sigs/controller-tools) project) for generating utility code and Kubernetes YAML. More information on markers for config/code generation can be found [here](https://book.kubebuilder.io/reference/markers.html).

Let's now modify the `PodSetSpec` and `PodSetStatus` of the `PodSet` Custom Resource (CR) at `api/v1alpha1/podset_types.go`

<br>
It should look like the file below:

<pre class="file">
package v1alpha1

import (
        metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// EDIT THIS FILE!  THIS IS SCAFFOLDING FOR YOU TO OWN!
// NOTE: json tags are required.  Any new fields you add must have json tags for the fields to be serialized.

// PodSetSpec defines the desired state of PodSet
type PodSetSpec struct {
        // Replicas is the desired number of pods for the PodSet
        // +kubebuilder:validation:Minimum=1
        // +kubebuilder:validation:Maximum=10
        Replicas int32 `json:"replicas,omitempty"`
}

// PodSetStatus defines the current status of PodSet
type PodSetStatus struct {
        PodNames        []string        `json:"podNames"`
	AvailableReplicas	int32	`json:"availableReplicas"`
}

// +kubebuilder:object:root=true
// +kubebuilder:subresource:status

// PodSet is the Schema for the podsets API
// +kubebuilder:printcolumn:JSONPath=".spec.replicas",name=Desired,type=string
// +kubebuilder:printcolumn:JSONPath=".status.availableReplicas",name=Available,type=string
type PodSet struct {
        metav1.TypeMeta   `json:",inline"`
        metav1.ObjectMeta `json:"metadata,omitempty"`

        Spec   PodSetSpec   `json:"spec,omitempty"`
        Status PodSetStatus `json:"status,omitempty"`
}

// +kubebuilder:object:root=true

// PodSetList contains a list of PodSet
type PodSetList struct {
        metav1.TypeMeta `json:",inline"`
        metav1.ListMeta `json:"metadata,omitempty"`
        Items           []PodSet `json:"items"`
}

func init() {
        SchemeBuilder.Register(&PodSet{}, &PodSetList{})
}
</pre>

You can easily update this file by running the following command:

```
\cp /tmp/podset_types.go api/v1alpha1/podset_types.go
```{{execute}}
<br>
After modifying the `*_types.go` file, always run the following command to update the `zz_generated.deepcopy.go` file:

```
make generate
```{{execute}}
<br>
Now we can run the `make manifests` command to generate our customized CRD and additional object YAMLs.

```
make manifests
```{{execute}}
<br>
Thanks to our comment markers, observe that we now have a newly generated CRD yaml that reflects the `spec.replicas` and `status.podNames` OpenAPI v3 schema validation and customized print columns.

```
cat config/crd/bases/app.example.com_podsets.yaml
```{{execute}}
<br>
Deploy your PodSet Custom Resource Definition to the live OpenShift Cluster:

```
oc apply -f config/crd/bases/app.example.com_podsets.yaml
```{{execute}}
<br>
Confirm the CRD was successfully created:

```
oc get crd podsets.app.example.com -o yaml
```{{execute}}
