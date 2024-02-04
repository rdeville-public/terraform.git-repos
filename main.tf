module "github_user" {
  # source = "git::https://framagit.org/rdeville-public/terraform/github-module.git"
  source = "../github/"
  providers = {
    github = github.user
  }

  count = can(var.github_provider) && var.github_provider.enabled ? 1 : 0

  user  = local.github_user
  repos = local.github_user_repos
}

module "github_org" {
  # source = "git::https://framagit.org/rdeville-public/terraform/github-module.git"
  source = "../github/"
  providers = {
    github = github.org
  }

  count = can(var.github_provider.organization) && var.github_provider.enabled ? 1 : 0

  organization = try(var.github_provider.organization, {})
  repos        = local.github_organization_repos
}

module "gitlab_mirror" {
  # source = "git::https://framagit.org/rdeville-public/terraform/gitlab-module.git"
  source = "../gitlab"
  providers = {
    gitlab = gitlab.mirror
  }
  count = can(var.gitlab_provider[var.gitlab_instances[1]]) && try(var.gitlab_provider[var.gitlab_instances[1]].enabled, false) ? 1 : 0

  groups          = local.gitlab_groups[var.gitlab_instances[1]]
  groups_repos    = local.gitlab_groups_repos[var.gitlab_instances[1]]
  subgroups       = local.gitlab_subgroups[var.gitlab_instances[1]]
  subgroups_repos = local.gitlab_subgroups_repos[var.gitlab_instances[1]]
  user            = local.gitlab_user[var.gitlab_instances[1]]
  user_repos      = local.gitlab_user_repos[var.gitlab_instances[1]]
}

module "gitlab_main" {
  # source = "git::https://framagit.org/rdeville-public/terraform/gitlab-module.git"
  source = "../gitlab"
  providers = {
    gitlab = gitlab.main
  }
  count = can(var.gitlab_provider[var.gitlab_instances[0]]) && try(var.gitlab_provider[var.gitlab_instances[0]].enabled, false) ? 1 : 0

  groups          = local.gitlab_groups[var.gitlab_instances[0]]
  groups_repos    = local.gitlab_groups_repos[var.gitlab_instances[0]]
  subgroups       = local.gitlab_subgroups[var.gitlab_instances[0]]
  subgroups_repos = local.gitlab_subgroups_repos[var.gitlab_instances[0]]
  user            = local.gitlab_user[var.gitlab_instances[0]]
  user_repos      = local.gitlab_user_repos[var.gitlab_instances[0]]
}
