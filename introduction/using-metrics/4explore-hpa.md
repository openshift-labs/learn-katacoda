Once the ``hpa`` object has been created, the object can be treated as any
other OpenShift object, including see the object definition:

``oc get hpa guestbook -o yaml -n myproject``{{execute}}

You should see something similar to:

```
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  annotations:
    autoscaling.alpha.kubernetes.io/current-metrics: '[{"type":"Resource","resource":{"name":"cpu","currentAverageUtilization":0,"currentAverageValue":"0"}}]'
  name: guestbook
  ...
spec:
  maxReplicas: 3
  minReplicas: 1
  scaleTargetRef:
    apiVersion: v1
    kind: DeploymentConfig
    name: guestbook
  targetCPUUtilizationPercentage: 20
status:
  currentCPUUtilizationPercentage: 0
  currentReplicas: 1
  desiredReplicas: 1
```

Or edit it using ``oc edit`` or ``oc patch`` to modify some parameters, like
modifying the ``maxReplicas`` setting to 2:

``oc patch hpa/guestbook -p '{"spec":{"maxReplicas": 2}}' -n myproject``{{execute}}
