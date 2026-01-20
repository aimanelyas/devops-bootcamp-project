#ECR Repository
resource "aws_ecr_repository" "final_project" {
  name = "devops-bootcamp/final-project-aimanelyas"

  #Force delete even the repository have images
  force_delete = true
}