Modify the `PodSetSpec` and `PodSetStatus` of the `PodSet` Custom Resource(CR) at `go/src/github.com/redhat/podset-operator/pkg/apis/app/v1alpha1/podset_types.go`
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
        // INSERT ADDITIONAL SPEC FIELDS - desired state of cluster
        // Important: Run "operator-sdk generate k8s" to regenerate code after modifying this file
        // Add custom validation using kubebuilder tags: https://book-v1.book.kubebuilder.io/beyond_basics/generating_crd.html
        
	Replicas int32 `json:"replicas"`
}

// PodSetStatus defines the observed state of PodSet
type PodSetStatus struct {
        // INSERT ADDITIONAL STATUS FIELD - define observed state of cluster
        // Important: Run "operator-sdk generate k8s" to regenerate code after modifying this file
        // Add custom validation using kubebuilder tags: https://book-v1.book.kubebuilder.io/beyond_basics/generating_crd.html
        
	PodNames []string `json:"podNames"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// PodSet is the Schema for the podsets API
// +kubebuilder:subresource:status
// +kubebuilder:resource:path=podsets,scope=Namespaced
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

You can easily update this file by running the following command:

```
wget -q https://raw.githubusercontent.com/openshift-labs/learn-katacoda/master/operatorframework/go-operator-podset/assets/podset_types.go -O pkg/apis/app/v1alpha1/podset_types.go
```{{execute}}
<br>
After modifying the `*_types.go` file, always run the following command to update the generated code for that resource type:

```
operator-sdk generate k8s
```{{execute}}
<br>
We can also automatically update the CRD with [OpenAPI v3 schema](https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/#validation) details based off the newly updated `*_types.go` file:

```
operator-sdk generate crds
```{{execute}}
<br>
Observe the CRD now reflects the `spec.replicas` and `status.podNames` OpenAPI v3 schema validation in the spec:

```
cat deploy/crds/app.example.com_podsets_crd.yaml
```{{execute}}
<br>
Deploy your PodSet Custom Resource Definition to the live OpenShift Cluster:

```
oc create -f deploy/crds/app.example.com_podsets_crd.yaml
```{{execute}}
<br>
Confirm the CRD was successfully created:

```
oc get crd podsets.app.example.com -o yaml
```{{execute}}
