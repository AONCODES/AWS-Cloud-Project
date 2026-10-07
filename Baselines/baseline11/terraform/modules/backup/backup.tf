resource "aws_backup_vault" "vm_backup" {
  name = "vm-backup-vault"

  tags = {
    Name = "vm-backup-vault"
    Task = "Backup and Restore"
  }
}

resource "aws_backup_plan" "vm_backup" {
  name = "vm-backup-plan"

  rule {
    rule_name         = "daily-vm-backup"
    target_vault_name = aws_backup_vault.vm_backup.name
    schedule          = "cron(0 3 * * ? *)"

    lifecycle {
      delete_after = 7
    }
  }

  tags = {
    Name = "vm-backup-plan"
    Task = "Backup and Restore"
  }
}
resource "aws_backup_selection" "vm_backup" {
  name         = "vm-backup-selection"
  plan_id      = aws_backup_plan.vm_backup.id
  iam_role_arn = var.backup_role_arn

  resources = [
    var.vm_arn
  ]
}