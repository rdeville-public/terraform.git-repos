locals {
  github_user = {
    sshkeys = var.user.sshkeys
    gpgkeys = var.user.gpgkeys
  }

  github_user_repos = {
    for repo_path, repo_val in var.user.repos != null ? var.user.repos : {} : repo_path => {
      for key, val in repo_val : key => merge(
        val,
        key == "config" ? {
          name        = repo_path,
          description = replace(repo_val.description, "\n\n", " ")
        } : null,
        can(var.github_provider.repos[key]) ? var.github_provider.repos[key] : null,
      )
    }
  }

  github_groups_repos = merge([
    for group_path, group_val in var.groups : {
      for repo_path, repo_val in group_val.repos != null ? group_val.repos : {} : repo_path => {
        for key, val in repo_val : key => merge(
          can(var.github_provider.repos[key]) ? var.github_provider.repos[key] : {},
          val,
          key == "config" ?
          {
            name = repo_path,
            description = replace(
              "Mirror of the same project on https://${var.main_provider}/${group_path}/${repo_path}.\n\n${try(val.description, null)}",
              "\n\n", " "
            )
            visibility = try(val.visibility_level, var.gitlab_provider[var.main_provider].repos[key].visibility_level, null)
          } : null,
          # Kept here as example but cannot be used with gitlab.org
          # key == "access_tokens" ? {
          #   mirror_api = {
          #     expires_at   = var.mirror_token_expiration
          #     scopes       = ["write_repository"]
          #     access_level = "maintainer"
          #   }
          # } : null,
        )
      }
    }
  ]...)

  github_subgroups_repos = merge([
    for group_path, group_val in var.groups : merge([
      for subgroup_path, subgroup_val in group_val.subgroups :
      {
        for repo_path, repo_val in subgroup_val.repos != null ? subgroup_val.repos : {} : repo_path => {
          for key, val in repo_val : key => merge(
            can(var.github_provider.repos[key]) ? var.github_provider.repos[key] : {},
            val,
            key == "config" ? {
              name = "${subgroup_path}.${repo_path}",
              description = replace(
                "Mirror of the same project on https://${var.main_provider}/${group_path}/${subgroup_path}/${repo_path}.\n\n${try(val.description, null)}",
                "\n\n", " "
              )
              visibility = try(val.visibility_level, var.gitlab_provider[var.main_provider].repos[key].visibility_level, null)
            } : null,
            # Kept here as example but cannot be used with gitlab.org
            # key == "access_tokens" ? {
            #   mirror_api = {
            #     expires_at   = var.mirror_token_expiration
            #     scopes       = ["write_repository"]
            #     access_level = "maintainer"
            #   }
            # } : null,
          )
        }
      }
    ]...)
  ]...)

  github_organization_repos = merge([
    local.github_groups_repos,
    local.github_subgroups_repos
  ]...)

}
