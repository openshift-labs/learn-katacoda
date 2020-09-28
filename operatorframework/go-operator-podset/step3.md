Let's begin by inspecting the newly generated `api/v1alpha1/podset_types.go` file for our PodSet API:

```
cat api/v1alpha1/podset_types.go
```{{execute}}

In Kubernetes, every functional object (with some exceptions, i.e. ConfigMap) includes `spec` and `status`. Kubernetes functions by reconciling desired state (Spec) with the actual cluster state. We then record what is observed (Status). 

Also observe the `+kubebuilder` comment markers found throughout the file. `operator-sdk` makes use of a tool called [controler-gen](https://github.com/kubernetes-sigs/controller-tools) (from the [controller-tools](https://github.com/kubernetes-sigs/controller-tools)) project for generating utility code and Kubernetes YAML. More information on markers for config/code generation can be found [here](https://book.kubebuilder.io/reference/markers.html).

Modify the `PodSetSpec` and `PodSetStatus` of the `PodSet` Custom Resource(CR) at `go/src/github.com/redhat/podset-operator/api/v1alpha1/podset_types.go`
<br>
It should look like the file below:

<pre class="file">
/*


Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package v1alpha1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// PodSetSpec defines the desired state of PodSet
type PodSetSpec struct {
	// Replicas is the desired number of pods for the PodSet 
        // +kubebuilder:validation:Minimum=1
        // +kubebuilder:validation:Maximum=10
	Replicas int32 `json:"replicas,omitempty"`
}

// PodSetStatus defines the current pods owned by the PodSet
type PodSetStatus struct {
        // +kubebuilder:printcolumn:JSONPath=".status.podNames",name=PodNames,type=string
	PodNames []string `json:"podNames"`
}

// +kubebuilder:object:root=true
// +kubebuilder:subresource:status

// PodSet is the Schema for the podsets API
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
