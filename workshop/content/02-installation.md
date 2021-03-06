---
Title: Installing Compliance Operator
PrevPage: 01-compliance-operator
NextPage: 03-creating-your-first-scan
---

Assuming you have the cluster up and running and you are logged as a user who has the
`cluster-admin` role, the first task it to install the operator. Even though
we're going to be installing the latest release packaged by upstream and
not deploying from the source, we're going to be creating several Kubernetes
objects from manifests in the upstream repository.

Start by creating the `openshift-compliance` namespace:
```execute
oc create -f https://raw.githubusercontent.com/openshift/compliance-operator/master/deploy/ns.yaml
```

We'll be using the OpenShift [Operator Lifecycle Manager](https://docs.openshift.com/container-platform/4.5/operators/understanding_olm/olm-understanding-olm.html)
so we'll continue by creating several objects that describe the operator for
the OLM. First, we'll create the `CatalogSource` and verify that it's been
created successfully:

```execute
oc create -f https://raw.githubusercontent.com/openshift/compliance-operator/master/deploy/olm-catalog/catalog-source.yaml
```

```execute
oc get catalogsource -n openshift-marketplace
```

```
NAME                  DISPLAY                        TYPE   PUBLISHER                                  AGE
certified-operators   Certified Operators            grpc   Red Hat                                    24m
community-operators   Community Operators            grpc   Red Hat                                    24m
compliance-operator   Compliance Operator Upstream   grpc   github.com/openshift/compliance-operator   17s
redhat-marketplace    Red Hat Marketplace            grpc   Red Hat                                    24m
redhat-operators      Red Hat Operators              grpc   Red Hat                                    24m
```

The `CatalogSource` represents metadata that OLM can use to discovery and
install Operators. Once that is installed, we can continue by installing
telling OLM that we want to install the Compliance Operator to the `openshift-compliance`
namespace by creating the `OperatorGroup` and the `Subscription` objects:

```execute
oc create -f https://raw.githubusercontent.com/openshift/compliance-operator/master/deploy/olm-catalog/operator-group.yaml
```

```execute
oc create -f https://raw.githubusercontent.com/openshift/compliance-operator/master/deploy/olm-catalog/subscription.yaml
```

The Subscription file can be edited to optionally deploy a custom version,
see the `startingCSV` attribute in the `deploy/olm-catalog/subscription.yaml`
file.

After a minute or two, the operator should be installed. Verify that the
Compliance Operator deployment and pods are running:
```execute
oc get deploy -n openshift-compliance
```

```execute
oc get pods -n openshift-compliance
```

You should see output similar to this one:
```
$ oc get deploy -nopenshift-compliance
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
compliance-operator   1/1     1            1           8m9s
ocp4-pp               1/1     1            1           7m22s
rhcos4-pp             1/1     1            1           7m22s

$ oc get pods -nopenshift-compliance  
NAME                                   READY   STATUS    RESTARTS   AGE
compliance-operator-6fb8c75499-wkmjg   1/1     Running   0          8m11s
ocp4-pp-6d45b4664d-ztflt               1/1     Running   0          7m24s
rhcos4-pp-5cd48cff6-98kl2              1/1     Running   0          7m24s
```

Note: The `ocp4-pp` and the `rhcos4-pp` `Deployment` and `Pods` are created
by the operator and can take up to a minute to appear. The most important
object to see is the `compliance-operator` deployment and the associated pod.

If the deployment does not appear, check the `ClusterServiceVersion` and
`InstallationPlan` objects, 

```execute
oc get csv -n openshift-compliance
```

```execute
oc get ip -n openshift-compliance
```

Normally you should see output similar to the one below:
```
$ oc get csv -n openshift-compliance
NAME                          DISPLAY               VERSION   REPLACES   PHASE
compliance-operator.v0.1.15   Compliance Operator   0.1.15               Succeeded
$ oc get ip -nopenshift-compliance
NAME            CSV                           APPROVAL    APPROVED
install-mlxkz   compliance-operator.v0.1.15   Automatic   true
```

If the deployment is there, but pods don't appear, check the `Deployment` or its `ReplicaSet`:
```execute
oc describe deploy/compliance-operator -n openshift-compliance
```

```execute
oc describe rs -lname=compliance-operator -n openshift-compliance
```
Any errors would usually surface as `Events` attached to the respective
Kubernetes objects.

***

At this point, the Compliance Operator is up and running and we can move on.
