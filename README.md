# A Dojo for using Terraform and Helm together

This is a dojo to help familiarise yourself with using helm and terraform together. It is focused on running it locally on minikube. This is a dojo that aims to decrease the overwhelming details of these tools, and rather focus on the value you can get from them.

## Sections

Setup a local helm chart

Setup terraform with helm locally

Run them locally on minikube

## Steps

### Preperation

Make sure you have thse installed locally:

- helm cli
- terraform cli
- minikube

Make sure you have minikube running 

    $ minikube status

Make sure you are able to run kubectl in the context of your minikube

### Setup a local helm chart

First, create a folder called "charts".

    $ mkdir charts

You can create a helm chart from a template by running:

    $ helm create ./charts/example

Take a look at the chart content 

Some useful documentation:

https://helm.sh/docs/topics/charts/

https://helm.sh/docs/chart_template_guide/getting_started/

A high level overview of what you should see

```
./charts/example/

  Chart.yaml          # A YAML file containing information about the chart
  values.yaml         # The default configuration values for this chart
  charts/             # A directory containing any charts upon which this chart depends.
  templates/          # A directory of templates that, when combined with values,
                      # will generate valid Kubernetes manifest files.
  templates/NOTES.txt # OPTIONAL: A plain text file containing short usage notes
  ```

Inside templates remove all the files and folders except for the _helpers.tpl file

    ./charts/example/templates should now be an empty folder with just one file, _helpers.tpl

The _helpers.tpl file has your reusable values

    _helpers.tpl: A place to put template helpers that you can re-use throughout the chart

Copy your kubernetes *.yaml files over to the templates folder (not the values.yaml file - but all the others)

```
./charts/example/templates
  
  _helpers.tpl
  deployment.yaml
  namespace.yaml
  service.yaml
```

Replace the values.yaml with the value.yaml in the chart root folder, ./charts/example/values.yaml

    cat ./charts/example/values.yaml <-- shoulld now have your values inside

Test your chart with these commands:

First check for any syntax issues:

    $ helm lint ./charts/example

You can test in --dry-run mode:

    $ helm install example-chart --dry-run --debug ./charts/example 

Then you can actially install your chart on your kubernetes environment by running:

    $ helm install example-chart ./charts/example

To remove your chart again you can run:

    $ helm delete example-chart

To list your charts run: 

    $ helm list -aq

Check your new resources on minikube:

    $ kubectl get all -n example

Test your service and application:

    $ kubectl port-forward service/example 8001:80 -n example

Open up on your browser: http://localhost:8001/

Before continuing please delete the chart:

    $ helm delete example-chart

### Setup with terraform

Why use terraform with help? Terraform helps manage resources for day 2 problems. When you have tons of applications running on a cluster across many namespaces, it's easy to get architectural drift. What your configuration files define and what is actually on the system start to drift, and there ends up being resources that run on kubernetes that you "loose". Terraform helps with this part.

Some useful docs

https://registry.terraform.io/providers/hashicorp/helm/latest/docs

https://learn.hashicorp.com/tutorials/terraform/helm-provider

Copy the main.tf file from the ./use-files/terraform folder to the root of this dojo exercise

    ./main.tf

Initialise your terraform:

    $ terraform init

Test terraform

    $ terraform plan

    $ terraform apply
    yes

Check your kubernetes resources on your minikube environment:

Check your new resources on minikube:

    $ kubectl get all -n example

Test your service and application:

    $ kubectl port-forward service/example-chart 8001:80 -n example

Open up on your browser: http://localhost:8001/

Then when you are done you can destroy all the resources you created:

      $ terraform destroy
    yes