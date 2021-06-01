<h1>Controller Configurations</h1>


There are a number of other useful configurations that can be made when initialzing a controller. For more details on these configurations consult the upstream builder and controller godocs.

Set the max number of concurrent Reconciles for the controller via the MaxConcurrentReconciles option. Defaults to 1.

func (r *MemcachedReconciler) SetupWithManager(mgr ctrl.Manager) error {
  return ctrl.NewControllerManagedBy(mgr).
    For(&cachev1alpha1.Memcached{}).
    Owns(&appsv1.Deployment{}).
    WithOptions(controller.Options{MaxConcurrentReconciles: 2}).
    Complete(r)
}

Filter watch events using predicates

Choose the type of EventHandler to change how a watch event will translate to reconcile requests for the reconcile loop. For operator relationships that are more complex than primary and secondary resources, the EnqueueRequestsFromMapFunc handler can be used to transform a watch event into an arbitrary set of reconcile requests.
