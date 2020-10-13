Let's now observe the default `controllers/podset_controller.go` file:

```
cat controllers/podset_controller.go
```{{execute}}

This default controller requires additional logic so that we can react (or reconcile) to the add, update, and delete of `kind: PodSet` objects. We also need to modify the controller's `SetupWithManager` method. 

Modify the PodSet controller logic at `controllers/podset_controller.go`:

<pre class="file">
package controllers

import (
        "context"
        "reflect"

        "github.com/go-logr/logr"
        "k8s.io/apimachinery/pkg/runtime"
        ctrl "sigs.k8s.io/controller-runtime"
        "sigs.k8s.io/controller-runtime/pkg/client"

        appv1alpha1 "github.com/redhat/podset-operator/api/v1alpha1"

        "k8s.io/apimachinery/pkg/labels"
        "sigs.k8s.io/controller-runtime/pkg/controller/controllerutil"
        "sigs.k8s.io/controller-runtime/pkg/reconcile"

        "k8s.io/apimachinery/pkg/api/errors"
        metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

        corev1 "k8s.io/api/core/v1"
)

// PodSetReconciler reconciles a PodSet object
type PodSetReconciler struct {
        client.Client
        Log    logr.Logger
        Scheme *runtime.Scheme
}

// +kubebuilder:rbac:groups=app.example.com,resources=podsets,verbs=get;list;watch;create;update;patch;delete
// +kubebuilder:rbac:groups=app.example.com,resources=podsets/status,verbs=get;update;patch

func (r *PodSetReconciler) Reconcile(req ctrl.Request) (ctrl.Result, error) {
        _ = context.Background()
        _ = r.Log.WithValues("podset", req.NamespacedName)

        // Fetch the PodSet instance
        instance := &appv1alpha1.PodSet{}
        err := r.Get(context.TODO(), req.NamespacedName, instance)
        if err != nil {
                if errors.IsNotFound(err) {
                        // Request object not found, could have been deleted after reconcile request.
                        // Owned objects are automatically garbage collected. For additional cleanup logic use finalizers.
                        // Return and don't requeue
                        return reconcile.Result{}, nil
                }
                // Error reading the object - requeue the request.
                return reconcile.Result{}, err
        }
        // List all pods owned by this PodSet instance
        podSet := instance
        podList := &corev1.PodList{}
        lbs := map[string]string{
                "app":     podSet.Name,
                "version": "v0.1",
        }
        labelSelector := labels.SelectorFromSet(lbs)
        listOps := &client.ListOptions{Namespace: podSet.Namespace, LabelSelector: labelSelector}
        if err = r.List(context.TODO(), podList, listOps); err != nil {
                return reconcile.Result{}, err
        }

        // Count the pods that are pending or running as available
        var available []corev1.Pod
        for _, pod := range podList.Items {
                if pod.ObjectMeta.DeletionTimestamp != nil {
                        continue
                }
                if pod.Status.Phase == corev1.PodRunning || pod.Status.Phase == corev1.PodPending {
                        available = append(available, pod)
                }
        }
        numAvailable := int32(len(available))
        availableNames := []string{}
        for _, pod := range available {
                availableNames = append(availableNames, pod.ObjectMeta.Name)
        }

        // Update the status if necessary
        status := appv1alpha1.PodSetStatus{
                PodNames: availableNames,
                AvailableReplicas: numAvailable
        }
        if !reflect.DeepEqual(podSet.Status, status) {
                podSet.Status = status
                err = r.Status().Update(context.TODO(), podSet)
                if err != nil {
                        r.Log.Error(err, "Failed to update PodSet status")
                        return reconcile.Result{}, err
                }
        }

        if numAvailable > podSet.Spec.Replicas {
                r.Log.Info("Scaling down pods", "Currently available", numAvailable, "Required replicas", podSet.Spec.Replicas)
                diff := numAvailable - podSet.Spec.Replicas
                dpods := available[:diff]
                for _, dpod := range dpods {
                        err = r.Delete(context.TODO(), &dpod)
                        if err != nil {
                                r.Log.Error(err, "Failed to delete pod", "pod.name", dpod.Name)
                                return reconcile.Result{}, err
                        }
                }
                return reconcile.Result{Requeue: true}, nil
        }

        if numAvailable < podSet.Spec.Replicas {
                r.Log.Info("Scaling up pods", "Currently available", numAvailable, "Required replicas", podSet.Spec.Replicas)
                // Define a new Pod object
                pod := newPodForCR(podSet)
                // Set PodSet instance as the owner and controller
                if err := controllerutil.SetControllerReference(podSet, pod, r.Scheme); err != nil {
                        return reconcile.Result{}, err
                }
                err = r.Create(context.TODO(), pod)
                if err != nil {
                        r.Log.Error(err, "Failed to create pod", "pod.name", pod.Name)
                        return reconcile.Result{}, err
                }
                return reconcile.Result{Requeue: true}, nil
        }

        return reconcile.Result{}, nil
}

// newPodForCR returns a busybox pod with the same name/namespace as the cr
func newPodForCR(cr *appv1alpha1.PodSet) *corev1.Pod {
        labels := map[string]string{
                "app":     cr.Name,
                "version": "v0.1",
        }
        return &corev1.Pod{
                ObjectMeta: metav1.ObjectMeta{
                        GenerateName: cr.Name + "-pod",
                        Namespace:    cr.Namespace,
                        Labels:       labels,
                },
                Spec: corev1.PodSpec{
                        Containers: []corev1.Container{
                                {
                                        Name:    "busybox",
                                        Image:   "busybox",
                                        Command: []string{"sleep", "3600"},
                                },
                        },
                },
        }
}

//SetupWithManager defines how the controller will watch for resources
func (r *PodSetReconciler) SetupWithManager(mgr ctrl.Manager) error {
        return ctrl.NewControllerManagedBy(mgr).
                For(&appv1alpha1.PodSet{}).
                Owns(&corev1.Pod{}).
                Complete(r)
}
</pre>

You can easily update this file by running the following command:

```
\cp /tmp/podset_controller.go controllers/podset_controller.go
```{{execute}}

