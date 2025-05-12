# aap25 on openshift

1. [Download the openshift cli client binary 'oc'](https://access.redhat.com/downloads/content/290/ver=4.18/rhel---9/4.18.11/x86_64/product-software)
2. log into your cluster with oc: oc login
3. get your redhat automation hub token:  https://console.redhat.com/ansible/automation-hub/token
4. update the ansible.cfg with your token
5. install the requirements: ansible-galaxy install -r requirements.yml
6. !!! EDIT group_vars/all.yml with all of you customization, but there are some defaults to get you going
7. run "ansible-playbook osp-install-aap.yml" to deploy a ansible automation platform 2.5 cluster named 'aap25' into the 'aap' namespace on your openshift cluster
8. or change the namespace and cluster name by editing the playbook or passing in extra vars: ansible-playbook -e 'project=dev-ops-ansible deployment_name=development-automation' osp-install-aap.yml. This will deploy an aap 2.5 cluster named 'development-automation' in the openshift namespace 'dev-ops-ansible'.
9. It takes 15 mins to deploy the cluster and enther the 'CONFIG AS CODE' mode and configure the cluster for 30 more minutes. At this point the playbook will output an Openshift link to the controller pod so you can watch the logs.
10. It will also output links to the controller so you can use/watch the cluster as it is configured.
11. It will output 'FINISHED' in approx 45 mins and output the credentials again
12. Get links and the admin password anytime you want with: ansible-playbook osp-aap-get-admin-pass.yml
