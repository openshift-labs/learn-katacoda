When you use ``oc get -o json`` to query a resource object, it contains additional status information which can bind it to the current project and cluster. If you need to export a definition which can be used to create a new resource object in a different project or cluster, you should use ``oc export`` rather than ``oc get``.

Run the command:

``oc export route/parksmap -o json``{{execute}}

and compare it to the output you previously got when running:

``oc get route/parksmap -o json``{{execute}}

Notice how when using ``oc export`` that the meta data no longer contains any mentions of the current project via attributes such as ``namespace``.
