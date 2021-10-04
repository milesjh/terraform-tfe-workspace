resource "tfe_team_access" "main-dev" {
  access       = "admin"
  team_id      = var.tfe_team_developers_id
  workspace_id = tfe_workspace.main.id
}

resource "tfe_team_access" "main-ops" {
  access       = "admin"
  team_id      = var.tfe_team_ops_id
  workspace_id = tfe_workspace.main.id
}

resource "tfe_workspace" "main" {
  name              = "${var.use_case_name}-${var.environment}"
  organization      = var.org
  auto_apply        = true
  queue_all_runs    = false
  terraform_version = "1.0.8"

  vcs_repo {
    branch         = "main"
    identifier     = "milesjh/${github_repository.main.name}"
    oauth_token_id = var.oauth_token
  }
}

resource "github_branch" "main" {
  repository = github_repository.main.name
  branch     = "main"
}

resource "github_branch_default" "default" {
  repository = github_repository.main.name
  branch     = github_branch.main.branch
}

resource "github_repository" "main" {
  name        = "${var.use_case_name}-${var.environment}"
  description = "Terraform Consumer Repo for ${var.use_case_name}-${var.environment}"

  visibility = "public"
}

resource "tfe_variable" "aws_access_key" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = var.aws_access_key
  category     = "env"
  workspace_id = tfe_workspace.main.id
}

resource "tfe_variable" "aws_secret_key" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = var.aws_secret_key
  category     = "env"
  sensitive    = "true"
  workspace_id = tfe_workspace.main.id
}

resource "tfe_variable" "arm_tenant_id" {
  key          = "ARM_TENANT_ID"
  value        = var.arm_tenant_id
  category     = "env"
  workspace_id = tfe_workspace.main.id
}

resource "tfe_variable" "arm_subscription_id" {
  key          = "ARM_SUBSCRIPTION_ID"
  value        = var.arm_subscription_id
  category     = "env"
  workspace_id = tfe_workspace.main.id
}

resource "tfe_variable" "arm_client_id" {
  key          = "ARM_CLIENT_ID"
  value        = var.arm_client_id
  category     = "env"
  workspace_id = tfe_workspace.main.id
}

resource "tfe_variable" "arm_client_secret" {
  key          = "ARM_CLIENT_SECRET"
  value        = var.arm_client_secret
  category     = "env"
  sensitive    = "true"
  workspace_id = tfe_workspace.main.id
}

resource "tfe_variable" "workspace" {
  key      = "workspace_name"
  value    = var.creator_workspace
  category = "terraform"

  workspace_id = tfe_workspace.main.id
}

resource "tfe_variable" "confirm_destroy" {
  key          = "CONFIRM_DESTROY"
  value        = "1"
  category     = "env"
  workspace_id = tfe_workspace.main.id
}

resource "tfe_variable" "set_ttl" {
  key          = "WORKSPACE_TTL"
  value        = "30"
  category     = "env"
  workspace_id = tfe_workspace.main.id
}

resource "tfe_variable" "org" {
  key          = "org"
  value        = var.org
  category     = "terraform"
  workspace_id = tfe_workspace.main.id
}

resource "tfe_variable" "environment_name" {
  key      = "environment"
  value    = var.environment
  category = "terraform"

  workspace_id = tfe_workspace.main.id
}

resource "tfe_variable" "name" {
  key          = "name"
  value        = var.use_case_name
  category     = "terraform"
  workspace_id = tfe_workspace.main.id
}