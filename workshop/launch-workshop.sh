#!/bin/bash

WORKSHOP_NAME="workshop"
echo "Building and deploying workshop"

oc new-project lab-${WORKSHOP_NAME}-$(oc whoami) > /dev/null 2>&1
oc project lab-${WORKSHOP_NAME}-$(oc whoami)  > /dev/null 2>&1

.workshop/scripts/deploy-personal.sh

oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:workshop:lab-compliance-operator-user

WORKSHOP_URL=$(oc get routes.route.openshift.io | grep ${WORKSHOP_NAME} | awk '{print $2}')


echo ""
echo ""
echo "**********************************************************************************************"
echo "   Now you can open https://$WORKSHOP_URL"
echo ""
echo "   Use your OpenShift credentials to log in"
echo "**********************************************************************************************"
echo ""
