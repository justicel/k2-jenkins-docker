#!/bin/sh

REPO=quay.io/samsung_cnct/k2-ci

#Use Ansible to rebuild
ansible-playbook -vvvv -c local ansible/rebuild_jenkins_image.yaml



# IMAGE_NAME=data_volume
# echo "creating data-volume docker image"
# docker build -t "${REPO}-${IMAGE_NAME}" ${IMAGE_NAME}/
# echo "uploading ${IMAGE_NAME} to quay.io"
# docker push ${REPO}-${IMAGE_NAME}

# IMAGE_NAME=jenkins
# echo "creating data-volume docker image"
# docker build -t "${REPO}-${IMAGE_NAME}" ${IMAGE_NAME}/
# echo "uploading ${IMAGE_NAME} to quay.io"
# #docker push ${REPO}-${IMAGE_NAME}
# 
# IMAGE_NAME=jenkins-backup
# echo "creating data-volume docker image"
# docker build -t "${REPO}-${IMAGE_NAME}" ${IMAGE_NAME}/
# echo "uploading ${IMAGE_NAME} to quay.io"
# docker push ${REPO}-${IMAGE_NAME}
# 
# IMAGE_NAME=nginx
# echo "creating data-volume docker image"
# docker build -t "${REPO}-${IMAGE_NAME}" ${IMAGE_NAME}/
# echo "uploading ${IMAGE_NAME} to quay.io"
# docker push ${REPO}-${IMAGE_NAME}