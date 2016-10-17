
#Generates the docker image for k2 jenkins.  This image is used in the [k2 jenkins helm chart](https://github.com/samsung-cnct/k2-charts/tree/master/k2-jenkins).

The image currently lives in the docker repo: quay.io/samsung_cnct/samsung_cnct/k2-ci-jenkins

## Ansible scripts are use to generate the image.  To regenerate:

      ansible-playbook -vvvv -c local ansible/rebuild_jenkins_image.yaml
