module "github_user" {
  source = "git::https://framagit.org/rdeville-public/terraform/github-module.git"
  providers = {
    github = github.user
  }

  count = can(var.github_provider) ? [1] : []

  user  = local.github_user
  repos = local.github_user_repos
}

module "github_org" {
  source = "git::https://framagit.org/rdeville-public/terraform/github-module.git"
  providers = {
    github = github.org
  }

  count = can(var.github_provider.organization) ? [1] : []

  organization = try(var.github_provider.organization, {})
  repos        = local.github_organization_repos
}

module "gitlab" {
  source = "git::https://framagit.org/rdeville-public/terraform/gitlab-module.git"
  providers = {
    gitlab = gitlab.gitlab
  }
  count = can(var.gitlab_provider["gitlab"]) ? [1] : []

  groups          = local.gitlab_groups
  groups_repos    = local.gitlab_groups_repos
  subgroups       = local.gitlab_subgroups
  subgroups_repos = local.gitlab_subgroups_repos
  user            = local.gitlab_user
  user_repos      = local.gitlab_user_repos
}

module "framagit" {
  source = "git::https://framagit.org/rdeville-public/terraform/gitlab-module.git"
  providers = {
    gitlab = gitlab.framagit
  }
  count = can(var.gitlab_provider["framagit"]) ? [1] : []

  groups          = local.framagit_groups
  groups_repos    = local.framagit_groups_repos
  subgroups       = local.framagit_subgroups
  subgroups_repos = local.framagit_subgroups_repos
  user            = local.framagit_user
  user_repos      = local.framagit_user_repos
}
