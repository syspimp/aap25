#!/bin/bash
# bash script to deploy ansible automation platform 2.5 on an openshift cluster
# TODO just use the playbook instead
# TODO this script needs to variablize the new cluster name
# TODO everything is hardcoded for namespace aap and cluster named aap25
echo "this is just documentation, use osp-install-aap.yml playbook instead"
exit 0
clustername=aap25
oc new-project aap

cat>deploy-aap25-cluster.yml<<EOF
apiVersion: aap.ansible.com/v1alpha1
kind: AnsibleAutomationPlatform
metadata:
  name: aap25
  namespace: aap
spec:
  # Platform
  image_pull_policy: IfNotPresent
  # Components
  controller:
    disabled: false
    extra_settings:
      - setting: ALLOW_LOCAL_RESOURCE_MANAGEMENT
        value: 'True'
  eda:
    disabled: false
    extra_settings:
      - setting: EDA_ALLOW_LOCAL_RESOURCE_MANAGEMENT
        value: '@bool True'
  hub:
    disabled: false
    ## Modify to contain your RWM storage class name
    #storage_type: file
    #file_storage_storage_class: <your-read-write-many-storage-class>
    #file_storage_size: 10Gi

    ## uncomment if using S3 storage for Content pod
    # storage_type: S3
    # object_storage_s3_secret: example-galaxy-object-storage

    ## uncomment if using Azure storage for Content pod
    # storage_type: azure
    # object_storage_azure_secret: azure-secret-name
  lightspeed:
    disabled: true
EOF
cat>subscribe-to-operator.yml<<EOF
---
apiVersion: v1
kind: Namespace
metadata:
  labels:
    openshift.io/cluster-monitoring: "true"
  name: aap
---
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: ansible-automation-platform-operator
  namespace: aap
spec:
  targetNamespaces:
    - aap
---
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ansible-automation-platform
  namespace: aap
spec:
  channel: 'stable-2.5'
  installPlanApproval: Automatic
  name: ansible-automation-platform-operator
  source: redhat-operators
  sourceNamespace: openshift-marketplace
---
EOF

echo "*** subscribing to the aap operator"
oc apply -f subscribe-to-operator.yml
echo "*** waiting for install to finish."
while [[ $? -eq 1 ]]
do
	echo -n " ."
	sleep 10
	oc get csv -n aap |grep aap | grep "Succeeded"
done
echo -n " done!"

echo "*** deploying aap cluster"
oc apply -f ./deploy-aap25-cluster.yml
echo "*** wait 5 mins for cluster to deploy. FIN"
