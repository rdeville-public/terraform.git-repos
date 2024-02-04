locals {
  github_provider_keys = [
    "enabled",
    "provider_info",
    "repos",
    "organization",
  ]

  gitlab_provider_keys = [
    "enabled",
    "provider_info",
    "repos",
    "groups",
  ]

  groups_keys = [
    "config",
    "labels",
    "variables",
    "access_tokens",
    "repos",
    "subgroups",
  ]

  repos_keys = [
    "config",
    "labels",
    "variables",
    "branch_protections",
    "tag_protections",
    "mirrors",
  ]

  user_keys = [
    "sshkeys",
    "gpgkeys",
    "access_tokens",
    "repos",
  ]
}
