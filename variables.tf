variable "main_provider" {
  type = string

  default = "framagit.org"
}

variable "mirror_token_expiration" {
  type = string

  default = "2100-12-31T00:00:00Z"
}

variable "github_provider" {
  type = object({
    enabled = optional(bool, false)
    provider_info = optional(object({
      username     = optional(string)
      user_token   = optional(string)
      mirror_token = optional(string)
      base_url     = optional(string, "https://github.com")
      hostname     = optional(string, "github.com")
    }), null)
    repos = optional(object({
      config             = optional(map(any))
      labels             = optional(map(any))
      variables          = optional(map(any))
      branch_protections = optional(map(any))
      tag_protections    = optional(map(any))
      mirrors            = optional(map(any))
      access_tokens      = optional(map(any))
    }), null)
    organization = optional(map(any))
  })

  default = {}
}

variable "gitlab_provider" {
  type = map(object({
    enabled = optional(bool, false)
    provider_info = object({
      username = string
      token    = string
      base_url = string
      hostname = string
    })
    repos = optional(object({
      config             = optional(map(any))
      labels             = optional(map(any))
      variables          = optional(map(any))
      branch_protections = optional(map(any))
      tag_protections    = optional(map(any))
      mirrors            = optional(map(any))
      access_tokens      = optional(map(any))
    }), null)
    groups = optional(object({
      config        = optional(map(any))
      labels        = optional(map(map(any)))
      variables     = optional(map(any))
      access_tokens = optional(map(any))
    }), null)
  }))

  default = {}
}

variable "groups" {
  type = map(object({
    // Key are group path
    config        = optional(map(any))
    labels        = optional(map(any))
    variables     = optional(map(any))
    access_tokens = optional(map(any))
    repos = optional(map(object({
      config             = optional(map(any))
      labels             = optional(map(any))
      variables          = optional(map(any))
      branch_protections = optional(map(any))
      tag_protections    = optional(map(any))
      mirrors            = optional(map(any))
      access_tokens      = optional(map(any))
    })))
    subgroups = optional(map(object({
      // Key are subgroup path
      config        = optional(map(any))
      labels        = optional(map(any))
      variables     = optional(map(any))
      access_tokens = optional(map(any))
      repos = optional(map(object({
        config             = optional(map(any))
        labels             = optional(map(any))
        variables          = optional(map(any))
        branch_protections = optional(map(any))
        tag_protections    = optional(map(any))
        mirrors            = optional(map(any))
        access_tokens      = optional(map(any))
      })))
    })))
  }))

  default = {}
}

variable "user" {
  type = object({
    sshkeys       = optional(map(any))
    gpgkeys       = optional(map(any))
    access_tokens = optional(map(any))
    repos = optional(map(object({
      config             = optional(map(any))
      labels             = optional(map(any))
      variables          = optional(map(any))
      branch_protections = optional(map(any))
      tag_protections    = optional(map(any))
      mirrors            = optional(map(any))
      access_tokens      = optional(map(any))
    })))
  })

  default = {}
}

variable "gitlab_instances" {
  type = list(string)

  default = [
    "framagit.org",
    "gitlab.com"
  ]
}
