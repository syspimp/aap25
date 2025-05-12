# aap25 on openshift using configuation as code

This uses ansible to:

- destroy and create a clean project/namespace in openshift
- install the ansible automation platform operator in that namespace
- deploy a complete aap 2.5 cluster in the namespace in 15 mins
- apply "config as code" to configure the new aap cluster

1. [Download the openshift cli client binary 'oc'](https://access.redhat.com/downloads/content/290/ver=4.18/rhel---9/4.18.11/x86_64/product-software)
2. log into your cluster with oc: oc login
3. [get your redhat automation hub token](https://console.redhat.com/ansible/automation-hub/token)
4. !!! COPY ansible.cfg.example to ansible.cfg and update with your token

`cp ansible.cfg.example ansible.cfg`

5. [Create and download/export manifest that contains your subscription entitlements](https://access.redhat.com/management/subscription_allocations)
6. copy the manifest to files/manifest.zip
7. install the required ansible collections: ansible-galaxy install -r requirements.yml

`ansible-galaxy install -r requirements.yml`


8. !!! COPY group_vars/all.yml.example to group_vars/all.yml and edit with all of your customization like passwords and deployment config, but there are some examples to get you started. Consider this your secrets file and treat it accordingly. Do not commit it to any code repository with out encrypting it first.

`cp group_vars/all.yml.example group_vars/all.yml`


9. [OPTIONAL BUT RECOMMENDED] encrypt your secrets file: ansible-vault encrypt group_vars/all.yml . Type in a password twice. This is your vault password for this repo. It doesn't have to match the vault_pass variable in group_vars/all.yml. That is used for a credential to unlock another repo.

`ansible-vault encrypt group_vars/all.yml`

10. run "ansible-playbook deploy-entitle-import.yml" to deploy a ansible automation platform 2.5 cluster named 'aap25' into the 'aap' namespace (defaults) on your openshift cluster
11. \[OPTIONAL BUT RECOMMENDED\] run "ansible-playbook --ask-vault-pass deploy-entitle-import.yml" to unencrypt the secrets for the run. type in your vault password.

`ansible-playbook --ask-vault-pass deploy-entitle-import.yml`

12. \[OPTIONAL\] or change the namespace and cluster name by editing the playbook or passing in extra vars: ansible-playbook -e 'project=dev-ops-ansible deployment_name=development-automation' deploy-entitle-import.yml. This will deploy an aap 2.5 cluster named 'development-automation' in the openshift namespace 'dev-ops-ansible'.

`ansible-playbook -e 'project=dev-ops-ansible deployment_name=development-automation' deploy-entitle-import.yml`

![Starting the aap on openshift deployment](https://raw.githubusercontent.com/syspimp/aap25/master/pics/deploy-start.png)

13. It takes 15 mins to deploy the cluster and enter the 'CONFIG AS CODE' mode and configure the cluster for 30 more minutes. At this point the playbook will output an Openshift link to the controller pod so you can watch the logs. The aap cluster is available, but still being configured so look but don't edit or delete.

![Config as code mode activated](https://raw.githubusercontent.com/syspimp/aap25/master/pics/aap-configascode.png)

14. It will output links to the controller so you can use/watch the cluster as it is configured.
15. It will output 'FINISHED' in approx 45 mins and output the credentials again
16. Get links and the admin password anytime you want with: ansible-playbook osp-aap-get-admin-pass.yml

`ansible-playbook osp-aap-get-admin-pass.yml`

# notes
- deploy-entitle-import.yml is the entry for this example, and wraps over other playbooks. Some of those can be run by themselves, some are utility playbooks for one off runs and some playbooks are just examples

- aap25-import-workloads.yml is the playbook that performs the config as code/imports the configuration. You can use it directory against vm/bare-metal deployments, just set the tower_onosp=no tower_host=myaapcluster.example.com tower_password=keepsecret flags. It doesn't matter if it runs on openshift or not at this point, the variables are used to construct the URL for the api call. The password is pulled from the openshift secret just for fun, which should be the same password you set for users.admin.pass variable in group_vars/all.yml:

`ansible-playbook -e 'tower_osp_project=aap-west tower_osp_deployment_name=aap25-jpn' aap25-import-workloads.yml`

or for vm/bare-metal deployments, set the url and password directly to override whats in group_vars/all.yml:

`ansible-playbook -e 'tower_onosp=no tower_host=myaap25.example.com tower_pass=supersecret' aap25-import-workloads.yml`


- the configuration for this aap example was exported from another, working aap cluster, and some were modified to be used as a jinja template in the templates/ directory. The unmodified exported configuration are saved/loaded from files/ directory. There is a script named 'backup-tower-config-into-objects.sh' as well as a playbook named 'aap25-export-workloads.yml' provided to export/backup an ansible tower/aap deployment and create these files. This example sets tower_host variable. It doesn't matter if it is running on openshift or not.

`ansible-playbook -e 'tower_host=aap25-vm.example.com tower_pass=supersecret' aap25-export-workloads.yml`

- look at deploy-entitle-import.yml, you can override any of those variables used in there to deploy different clusters to serve asia and europe:
  ie to deploy two different aap clusters in namespaces 'aap-east' and 'aap-west'. If you have a Multi-node Openshift Cluster operating in multiple regions or environments, you can assign a cluster to run exclusively on a particuler openshift node to serve that enviroment. You can accomplish this adding tags to deployments/pods, but that is beyond the scope of this demo.

`ansible-playbook -e 'tower_osp_project=aap-west tower_osp_deployment_name=aap25-eu' deploy-entitle-import.yml`

`ansible-playbook -e 'tower_osp_project=aap-east tower_osp_deployment_name=aap25-jpn' deploy-entitle-import.yml`

- scale down (kill pods) your aap cluster using the 'deployment_name-component' pod name format with oc:

`oc scale deploy aap25-eu-controller --replicas=0`

- scale up the same way (deploy more pods to handle the workload)

`oc scale deploy aap25-eu-gateway --replicas=2`

- TODO add the other playbooks to install vm/bare-metal aap deployments. Some of these playbooks work against vm/bare-metal deployments, you need to set the varibles tower_onsop=no and tower_host=myworkingtower.example.com and tower_password=whatever, as shown and stated above.
