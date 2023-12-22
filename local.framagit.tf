locals {
  framagit_provider = "framagit"
}

locals {
  framagit_groups = {
    for group_key, group_val in var.groups : group_key => merge([
      {
        for key, val in group_val : key =>
        key != "groups" && key != "repos"
        ? merge(
          val,
          key == "config" ? { path = group_key } : null,
          try(var.gitlab_provider[local.framagit_provider].groups[group_key][key], null)
        )
        : null
      }
    ]...)
  }
}

locals {
  framagit_groups_repos = merge([
    for group_path, group_val in var.groups : {
      for repo_path, repo_val in group_val.repos != null ? group_val.repos : {} : repo_path => {
        for key, val in repo_val : key => merge(
          val,
          key == "config" ?
          {
            namespace_name = group_path,
            path           = repo_path,
          } : null,
          key == "mirrors" ? merge([
            for provider_key, provider_val in var.gitlab_provider : provider_key != var.main_provider ? {
              "${provider_key}" = {
                url = (
                  provider_key == "gitlab" ? "https://${var.gitlab_provider[provider_key].provider_info.username}:${var.gitlab_provider[provider_key].provider_info.token}@${var.gitlab_provider[provider_key].provider_info.hostname}/${group_path}/${repo_path}.git"
                  # Below is an example with another gitlab provider. Add as many as gitlab modules used as modules cannot be accessed dynamically
                  # : provider_key == "gitlab_provider_name" ? "https://${var.gitlab_provider[provider_key].provider_info.username}:${module.gitlab_provider_name.groups[group_path].repos[repo_path].access_token["mirror_api"]}@${var.gitlab_provider[provider_key].provider_info.hostname}/${group_path}/${repo_path}.git"
                  : null
                )
              }
            } : null
          ]...)
          : null,
          key == "mirrors" ? {
            github = {
              url = "https://${var.github_provider.provider_info.username}:${var.github_provider.provider_info.mirror_token}@${var.github_provider.provider_info.hostname}/${group_path}/${repo_path}.git"
            }
          }
          : null,
          can(var.gitlab_provider[local.framagit_provider].repos[key]) ? var.gitlab_provider[local.framagit_provider].repos[key] : null,
        )
      }
    }
  ]...)
}

locals {
  framagit_subgroups = merge([
    for group_key, group_val in var.groups : {
      for subgroup_path, subgroup_val in group_val.subgroups : subgroup_path =>
      {
        for key, val in subgroup_val : key =>
        key == "config"
        ? merge(
          val,
          key == "config" ? { path = subgroup_path } : null,
          try(var.gitlab_provider[local.framagit_provider].groups[group_key].subgroups[subgroup_path][key], null)
        )
        : null
      }
    }
  ]...)
}

locals {
  framagit_subgroups_repos = merge([
    for group_path, group_val in var.groups : merge([
      for subgroup_path, subgroup_val in group_val.subgroups :
      {
        for repo_path, repo_val in subgroup_val.repos != null ? subgroup_val.repos : {} : repo_path => {
          for key, val in repo_val : key => merge(
            val,
            key == "config" ? {
              namespace_name = subgroup_path,
              path           = repo_path
            } : null,
            key == "mirrors" ? merge([
              for provider_key, provider_val in var.gitlab_provider : provider_key != var.main_provider ? {
                "${provider_key}" = {
                  url = (
                    provider_key == "gitlab" ? "https://${var.gitlab_provider[provider_key].provider_info.username}:${var.gitlab_provider[provider_key].provider_info.token}@${var.gitlab_provider[provider_key].provider_info.hostname}/${group_path}/${subgroup_path}/${repo_path}.git"
                    # # Below is an example with another gitlab provider. Add as many as gitlab modules used as modules cannot be accessed dynamically
                    # : provider_key == "gitlab_provider_name" ? "https://${var.gitlab_provider[provider_key].provider_info.username}:${module.gitlab_provider_name.groups[group_path].subgroups[subgroup_path].repos[repo_path].access_token["mirror_api"]}@${var.gitlab_provider[provider_key].provider_info.hostname}/${group_path}/${subgroup_path}/${repo_path}.git"
                    : null
                  )
                }
              } : null
            ]...)
            : null,
            key == "mirrors" ? {
              github = {
                url = "https://${var.github_provider.provider_info.username}:${var.github_provider.provider_info.mirror_token}@${var.github_provider.provider_info.hostname}/${group_path}/${subgroup_path}.${repo_path}.git"
              }
            }
            : null,
            can(var.gitlab_provider[local.framagit_provider].repos[key]) ? var.gitlab_provider[local.framagit_provider].repos[key] : null,
          )
        }
      }
    ]...)
  ]...)
}

locals {
  framagit_user = {
    sshkeys       = var.user.sshkeys
    gpgkeys       = var.user.gpgkeys
    access_tokens = {}
    # Kept as documentation purpose as only admin user can create access_token
    # access_tokens = merge(
    #   var.user.access_tokens,
    #   {
    #     mirror_api = {
    #       expires_at   = var.mirror_token_expiration
    #       scopes       = ["write_repository"]
    #       access_level = "maintainer"
    #     }
    #   }
    # )
  }
}

locals {
  framagit_user_repos = {
    for repo_path, repo_val in var.user.repos != null ? var.user.repos : {} : repo_path => {
      for key, val in repo_val : key => merge(
        val,
        key == "config" ?
        {
          path = repo_path,
        } : null,
        key == "mirrors" ? merge([
          for provider_key, provider_val in var.gitlab_provider : provider_key != var.main_provider ? {
            "${provider_key}" = {
              url = (
                provider_key == "gitlab" ? "https://${var.gitlab_provider[provider_key].provider_info.username}:${var.gitlab_provider[provider_key].provider_info.token}@${var.gitlab_provider[provider_key].provider_info.hostname}/${var.gitlab_provider[provider_key].provider_info.username}/${repo_path}.git"
                # Below is an example with another gitlab provider. Add as many as gitlab modules used as modules cannot be accessed dynamically
                # : provider_key == "gitlab_provider_name" ? "https://${var.gitlab_provider[provider_key].provider_info.username}:${module.gitlab_provider_name.user[group_path].repos[repo_path].access_token["mirror_api"]}@${var.gitlab_provider[provider_key].provider_info.hostname}/${var.gitlab_provider[provider_key].provider_info.username}/${repo_path}.git"
                : null
              )
            }
          } : null
        ]...)
        : null,
        can(var.gitlab_provider[local.framagit_provider].repos[key]) ? var.gitlab_provider[local.framagit_provider].repos[key] : null,
      )
    }
  }
}
