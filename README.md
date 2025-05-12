# aap25 on openshift using configuation as code

This uses ansible to:

- create and destroy a clean namespace in openshift
- install the ansible automation platform operator
- deploy a complete aap 2.5 cluster in the namespace in 15 mins
- apply "config as code" to configure the aap cluster

1. [Download the openshift cli client binary 'oc'](https://access.redhat.com/downloads/content/290/ver=4.18/rhel---9/4.18.11/x86_64/product-software)
2. log into your cluster with oc: oc login
3. get your redhat automation hub token:  https://console.redhat.com/ansible/automation-hub/token
4. !!! COPY ansible.cfg.example to ansible.cfg and update with your token
5. install the requirements: ansible-galaxy install -r requirements.yml
6. !!! COPY group_vars/all.yml.example to group_vars/all.yml and edit with all of you customization, but there are some examples to get you started
7. run "ansible-playbook osp-install-aap.yml" to deploy a ansible automation platform 2.5 cluster named 'aap25' into the 'aap' namespace on your openshift cluster
8. or change the namespace and cluster name by editing the playbook or passing in extra vars: ansible-playbook -e 'project=dev-ops-ansible deployment_name=development-automation' osp-install-aap.yml. This will deploy an aap 2.5 cluster named 'development-automation' in the openshift namespace 'dev-ops-ansible'.
9. It takes 15 mins to deploy the cluster and enther the 'CONFIG AS CODE' mode and configure the cluster for 30 more minutes. At this point the playbook will output an Openshift link to the controller pod so you can watch the logs.
10. It will also output links to the controller so you can use/watch the cluster as it is configured.
11. It will output 'FINISHED' in approx 45 mins and output the credentials again
12. Get links and the admin password anytime you want with: ansible-playbook osp-aap-get-admin-pass.yml

# notes
look at deploy-entitle-import.yml, you can override any of those variables used in there to deploy different clusters:
ie to deploy two different in namespaces 'aap-east' and 'aap-west'

`ansible-playbook -e 'tower_osp_project=aap-west tower_osp_deployment_name=aap25-eu' deploy-entitle-import.yml`

`ansible-playbook -e 'tower_osp_project=aap-east tower_osp_deployment_name=aap25-jpn' deploy-entitle-import.yml`
