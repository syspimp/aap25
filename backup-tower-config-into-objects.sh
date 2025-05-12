#!/bin/bash -e
set -x
if [[ "${TOWER_PASSWORD}X" == "X" ]]
then
  echo "please set the TOWER_PASSWORD environment variable with:"
  echo "export TOWER_PASSWORD='yourpasswordhere'"
  echo "then rerun this"
  exit 1
fi
backupdir="./files"
format=yaml
file_ext=yml
server=aap25-controller.tfound.org
#format=json
$(TOWER_USERNAME=admin TOWER_PASSWORD=${TOWER_PASSWORD}" awx login --conf.host https://${server} -k -f human)
mkdir -p ${backupdir}
# older versions of tower had fewer objects to export
#for r in users organizations teams credential_types credentials notification_templates projects inventory inventory_sources job_templates workflow_job_templates;
for r in applications credentials credential_types execution_environments \
inventory inventory_sources job_templates notification_templates \
organizations projects schedules teams users workflow_job_templates;
do
  awx --conf.host https://${server} -k export -f $format --${r} > ${backupdir}/${server}-${r}.${file_ext};
done
