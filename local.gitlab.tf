locals {
  gitlab_provider = "gitlab"
}

locals {
  gitlab_groups = {
    for group_key, group_val in var.groups : group_key => merge([
      {
        for key, val in group_val : key =>
        key != "groups" && key != "repos"
        ? merge(
          val,
          key == "config" ? { path = group_key } : null,
          try(var.gitlab_provider[local.framagit_provider].groups[group_key][key], null) # != null ? var.gitlab_provider[local.framagit_provider].groups[key] : {},
        )
        : null
      }
    ]...)
  }
}

locals {
  gitlab_groups_repos = merge([
    for group_path, group_val in var.groups : {
      for repo_path, repo_val in group_val.repos != null ? group_val.repos : {} : repo_path => {
        for key, val in repo_val : key => merge(
          val,
          key == "config" ?
          {
            namespace_name = group_path,
            path           = repo_path,
            description    = can(repo_val[key].description) ? "Mirror of the same project on https://${var.main_provider}/${group_path}/${repo_path}.\n\n${repo_val[key].description}" : null
          } : null,
          # Kept here as example but cannot be used with gitlab.org
          # key == "access_tokens" ? {
          #   mirror_api = {
          #     expires_at   = var.mirror_token_expiration
          #     scopes       = ["write_repository"]
          #     access_level = "maintainer"
          #   }
          # } : null,
          can(var.gitlab_provider[local.gitlab_provider].repos[key]) ? var.gitlab_provider[local.gitlab_provider].repos[key] : null,
        )
      }
    }
  ]...)
}

locals {
  gitlab_subgroups = merge([
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
  gitlab_subgroups_repos = merge([
    for group_path, group_val in var.groups : merge([
      for subgroup_path, subgroup_val in group_val.subgroups :
      {
        for repo_path, repo_val in subgroup_val.repos != null ? subgroup_val.repos : {} : repo_path => {
          for key, val in repo_val : key => merge(
            val,
            key == "config" ? {
              namespace_name = subgroup_path,
              path           = repo_path
              description    = can(val.description) ? "Mirror of the same project on https://${var.main_provider}/${group_path}/${repo_path}.\n\n${val.description}" : null
            } : null,
            # Kept here as example but cannot be used with gitlab.org
            # key == "access_tokens" ? {
            #   mirror_api = {
            #     expires_at   = var.mirror_token_expiration
            #     scopes       = ["write_repository"]
            #     access_level = "maintainer"
            #   }
            # } : null,
            can(var.gitlab_provider[local.gitlab_provider].repos[key]) ? var.gitlab_provider[local.gitlab_provider].repos[key] : null,
          )
        }
      }
    ]...)
  ]...)
}

locals {
  gitlab_user = {
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
  gitlab_user_repos = {
    for repo_path, repo_val in var.user.repos != null ? var.user.repos : {} : repo_path => {
      for key, val in repo_val : key => merge(
        val,
        key == "config" ?
        {
          path = repo_path,
        } : null,
        # Kept here as example but cannot be used with gitlab.org
        # key == "access_tokens" ? {
        #   mirror_api = {
        #     expires_at   = var.mirror_token_expiration
        #     scopes       = ["write_repository"]
        #     access_level = "maintainer"
        #   }
        # } : null,
        can(var.gitlab_provider[local.gitlab_provider].repos[key]) ? var.gitlab_provider[local.gitlab_provider].repos[key] : null,
      )
    }
  }
}
