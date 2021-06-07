The following are a few possible return options for a Reconciler:

* With the error:
<pre class="file">
return ctrl.Result{}, err
</pre>
* Without an error:
<pre class="file">
return ctrl.Result{Requeue: true}, nil
</pre>
* Therefore, to stop the Reconcile, use:
<pre class="file">
return ctrl.Result{}, nil
</pre>
* Reconcile again after X time:
<pre class="file">
 return ctrl.Result{RequeueAfter: nextRun.Sub(r.Now())}, nil
 </pre>
For more details, check the Reconcile and its [Reconcile godoc](https://pkg.go.dev/sigs.k8s.io/controller-runtime/pkg/reconcile).

