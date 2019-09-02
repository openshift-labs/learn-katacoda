Modify the spec and status of the `PodSet` Custom Resource(CR) at `go/src/github.com/redhat/podset-operator/pkg/apis/app/v1alpha1/podset_types.go`:

<pre class="file"
 data-filename="/root/tutorial/go/src/github.com/podset-operator/pkg/apis/app/v1alpha1/podset_types.go"
  data-target="replace">
package v1alpha1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// EDIT THIS FILE!  THIS IS SCAFFOLDING FOR YOU TO OWN!
// NOTE: json tags are required.  Any new fields you add must have json tags for the fields to be serialized.

// PodSetSpec defines the desired state of PodSet
type PodSetSpec struct {
    Replicas int32 `json:"replicas"`
}

// PodSetStatus defines the observed state of PodSet
type PodSetStatus struct {
    PodNames []string `json:"podNames"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// PodSet is the Schema for the podsets API
// +k8s:openapi-gen=true
type PodSet struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   PodSetSpec   `json:"spec,omitempty"`
	Status PodSetStatus `json:"status,omitempty"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

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

After modifying the `*_types.go` file, always run the following command to update the generated code for that resource type:

```
operator-sdk generate k8s
```{{execute}}
<br>
We can also automatically update the CRD with [OpenAPI v3 schema](https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/#validation) details based off the newly updated `*_types.go` file:

```
operator-sdk generate openapi
```{{execute}}
<br>
Observe the CRD now reflects the `spec.replicas` and `status.podNames` OpenAPI v3 schema validation in the spec:

```
cat deploy/crds/app_v1alpha1_podset_crd.yaml
```{{execute}}
<br>
Deploy your PodSet Custom Resource Definition to the live OpenShift Cluster:

```
oc create -f deploy/crds/app_v1alpha1_podset_crd.yaml
```{{execute}}
<br>
Confirm the CRD was successfully created:

```
oc get crd
```{{execute}}
