provider "kubernetes" {}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
    config_context = "minikube"
  }
}

resource "helm_release" "example" {
  name       = "example-chart"
  chart      = "./charts/example"
  version    = "0.0.1"
}
