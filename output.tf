output "github_user" {
  value = module.github_user
}

output "github_org" {
  value = module.github_org
}

output "gitlab_mirror" {
  value = module.gitlab_mirror
}

output "gitlab_main" {
  value = module.gitlab_main
}

output "local" {
  value = {
    gitlab_groups          = local.gitlab_groups
    gitlab_subgroups       = local.gitlab_subgroups
    gitlab_groups_repos    = local.gitlab_groups_repos
    gitlab_subgroups_repos = local.gitlab_subgroups_repos
  }
}
