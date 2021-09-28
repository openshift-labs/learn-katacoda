oc login -u developer -p developer
oc new-project myproject
curl https://raw.githubusercontent.com/openshift-katacoda/ai-machine-learning-jupyter-notebooks/2.4.0/image-streams/s2i-minimal-notebook.json | oc apply -f - -n myproject
curl https://raw.githubusercontent.com/openshift-katacoda/ai-machine-learning-jupyterhub-quickstart/3.3.1/image-streams/jupyterhub.json | oc apply -f - -n myproject
curl https://raw.githubusercontent.com/openshift-katacoda/ai-machine-learning-jupyter-notebooks/2.4.0/templates/notebook-builder.json | sed -e 's/"Redirect"/"Allow"/' | oc apply -f - -n myproject
curl https://raw.githubusercontent.com/openshift-katacoda/ai-machine-learning-jupyterhub-quickstart/3.3.1/templates/jupyterhub-builder.json | sed -e 's/"Redirect"/"Allow"/' | oc apply -f - -n myproject
curl https://raw.githubusercontent.com/openshift-katacoda/ai-machine-learning-jupyterhub-quickstart/3.3.1/templates/jupyterhub-deployer.json | sed -e 's/"Redirect"/"Allow"/' | oc apply -f - -n myproject
curl https://raw.githubusercontent.com/openshift-katacoda/ai-machine-learning-jupyterhub-quickstart/3.3.1/templates/jupyterhub-quickstart.json | sed -e 's/"Redirect"/"Allow"/' | oc apply -f - -n myproject
