terraform {
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "~>16.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  token = var.github_provider.provider_info.user_token

  alias = "user"
}

provider "github" {
  token = var.github_provider.provider_info.user_token
  owner = "rdeville-public"

  alias = "org"
}

provider "gitlab" {
  base_url = var.gitlab_provider["gitlab"].provider_info.base_url
  token    = var.gitlab_provider["gitlab"].provider_info.token

  alias = "gitlab"
}

provider "gitlab" {
  base_url = var.gitlab_provider["framagit"].provider_info.base_url
  token    = var.gitlab_provider["framagit"].provider_info.token

  alias = "framagit"
}
