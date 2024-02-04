terraform {
  required_providers {
    gitlab = {
      source                = "gitlabhq/gitlab"
      version               = "~>16.0"
      configuration_aliases = [gitlab.main, gitlab.mirror]
    }
    github = {
      source                = "integrations/github"
      version               = "~> 5.0"
      configuration_aliases = [github.user, github.org]
    }
  }
}

# provider "github" {
#   token = var.github_provider.provider_info.user_token

#   alias = "user"
# }

# provider "github" {
#   token = var.github_provider.provider_info.user_token
#   owner = "rdeville-public"

#   alias = "org"
# }

# provider "gitlab" {
#   base_url = var.gitlab_provider[var.gitlab_instances[1]].provider_info.base_url
#   token    = var.gitlab_provider[var.gitlab_instances[1]].provider_info.token

#   alias = "mirror"
# }

# provider "gitlab" {
#   base_url = var.gitlab_provider[var.gitlab_instances[0]].provider_info.base_url
#   token    = var.gitlab_provider[var.gitlab_instances[0]].provider_info.token

#   alias = "main"
# }
