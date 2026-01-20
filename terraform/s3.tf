#Create S3 Bucket
resource "aws_s3_bucket" "final_project_bucket" {
  bucket = "devops-bootcamp-terraform-aimanelyas"
  force_destroy = true
    
    tags = {
        Name = "devops-bootcamp-terraform-aimanelyas"
    }
}

#Bucket Versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.final_project_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}