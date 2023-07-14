##


## Install Kind ##

Install kind in your system and once ready create your cluster:

        make create-cluster:

## install kubeclt ##

Install kubectl to control your k8s cluster via its api. Once done, test:
        
        kind get clusters
        kubeclt get all -A

## Install argo cli

        make install-argocd-cli

## deploy argo in your cluster

Deploy argocd to your cluster using its manifests.

        make deploy-argocd

After it verify if all your argocd pods are ready with:

        make argocd-get-all

## Adds cluster to argocd monitoring

Once all available, adds your cluster to argo:
        make expose-argocd
then in anoth
        make argocd-add-cluster

