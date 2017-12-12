
A rules session (the session in which facts are inserted and against which rules are evaluated) can be both stateful and stateless.

A *Stateful Session* is a session which is kept open until it is explicitly disposed. This allows the client to keep inserting facts into the session and fire rules against for a longer period of time. This can for example be used in *Complex Event Processing* scenario's in which a session accepts a constant stream of events against which rules are evaluated.

A *Stateless Session* is a session which is immediately disposed after the facts have been inserted and the rules have been fired. It's a one-shot approach. The client does a single request into the session in the form of a set of commands, the session executes these commands (.e.g. insert fact, fire rules), returns the result and disposes the session. This is a common architecture in stateless environments, for example when the rules engine is used to implement a decision (micro) service.

In this example we want to use a *Stateless Session*. We can configure such a session in the *Project Editor* of our rules project:

1. Click on *Open Project Editor*
2. Click on *Project Settings: Project General Settings* and select *Knowledge bases and sessions*
3. Click on *Add* (in the upper-left of the editor) and enter the name `default-kiebase`{{copy}} to add a new *KIE-Base* configuration (a *KIE-Base* is the entity that defines the rule-assets and configurations used by a session)
4. Select the just created `default-kiebase` and click on *Make Default*
4. Set *Equals Behaviour* to `Equality`
5. Set *Event Processing Mode* to `Cloud`
6. In the *Knowledge Session* section click on *Add*
7. Enter the name `stateless`
8. Enable the `Default`checkbox
8. Make sure that the *State* dropdown-list is set to `stateless`
9. Click on the *Save* button to save the configuration

We've now configured a *Stateless Session* named `stateless` in a *KIE-Base* called `default-kiebase`.

We can now reference this session at runtime when sending requests to the rules engine.
