<h1> Return Options </h1>

The following are a few possible return options for a Reconciler:

With the error:
return ctrl.Result{}, err
Without an error:
return ctrl.Result{Requeue: true}, nil
Therefore, to stop the Reconcile, use:
return ctrl.Result{}, nil
Reconcile again after X time:
 return ctrl.Result{RequeueAfter: nextRun.Sub(r.Now())}, nil
For more details, check the Reconcile and its Reconcile godoc.

