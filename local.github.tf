locals {
  github_user = {
    sshkeys = var.user.sshkeys
    gpgkeys = var.user.gpgkeys
  }
}

locals {
  github_user_repos = {
    for repo_path, repo_val in var.user.repos != null ? var.user.repos : {} : repo_path => {
      for key, val in repo_val : key => merge(
        val,
        key == "config" ? { name = repo_path } : null,
        can(var.github_provider.repos[key]) ? var.github_provider.repos[key] : null,
      )
    }
  }
}

locals {
  github_groups_repos = merge([
    for group_path, group_val in var.groups : {
      for repo_path, repo_val in group_val.repos != null ? group_val.repos : {} : repo_path => {
        for key, val in repo_val : key => merge(
          val,
          key == "config" ?
          {
            name        = repo_path,
            description = can(repo_val[key].description) ? "Mirror of the same project on https://${var.main_provider}/${group_path}/${repo_path}.${repo_val[key].description}" : null
          } : null,
          # Kept here as example but cannot be used with gitlab.org
          # key == "access_tokens" ? {
          #   mirror_api = {
          #     expires_at   = var.mirror_token_expiration
          #     scopes       = ["write_repository"]
          #     access_level = "maintainer"
          #   }
          # } : null,
          can(var.github_provider.repos[key]) ? var.github_provider.repos[key] : null,
        )
      }
    }
  ]...)
}

locals {
  github_subgroups_repos = merge([
    for group_path, group_val in var.groups : merge([
      for subgroup_path, subgroup_val in group_val.subgroups :
      {
        for repo_path, repo_val in subgroup_val.repos != null ? subgroup_val.repos : {} : repo_path => {
          for key, val in repo_val : key => merge(
            val,
            key == "config" ? {
              name        = "${subgroup_path}.${repo_path}",
              description = can(val.description) ? "Mirror of the same project on https://${var.main_provider}/${group_path}/${repo_path}.${val.description}" : null
            } : null,
            # Kept here as example but cannot be used with gitlab.org
            # key == "access_tokens" ? {
            #   mirror_api = {
            #     expires_at   = var.mirror_token_expiration
            #     scopes       = ["write_repository"]
            #     access_level = "maintainer"
            #   }
            # } : null,
            can(var.github_provider.repos[key]) ? var.github_provider.repos[key] : null,
          )
        }
      }
    ]...)
  ]...)
}

locals {
  github_organization_repos = merge([
    local.github_groups_repos,
    local.github_subgroups_repos
  ]...)
}
