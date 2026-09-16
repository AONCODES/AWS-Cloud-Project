# Task Documentation: Setup Version Control (GIT)

This task establishes the version control (GIT) foundations for the whole project/course. 

## Task Artifacts

- `baseline01/setup-version-control.md` — this documentation
- `README.md` — repository root readme, information about the project
- `.gitignore` — ignore rules for Terraform, Python, secrets and macOS files
- `LICENSE` — MIT license
- `DISCLAIMER.md` — course project disclaimer
- `baseline01/` … `baseline16/`, `target/` — folder per task

## Task Description

### Mission 

Create a GitHub account with MFA, create a private repository, invite the
trainer, create a folder for each Baseline Level Task and for the Target
Level Task, and verify that Git commands can be run locally and pushed to
the remote repository.

### File Structure

```
AWS-Cloud-Project/
  README.md
  LICENSE
  DISCLAIMER.md
  .gitignore
  TASK_TEMPLATE.md
  baseline01/
    setup-version-control.md
  baseline02/
    setup-kanban-and-slack.md
  ...
  baseline16/
    estimate-costs.md
  target/
    iac-deployment.md
```

### Deployment process

1. Create GitHub account and enable MFA (Settings → Password and
   authentication → Two-factor authentication).
2. Create a new **private** repository.
3. Invite the trainer as a collaborator
   (Settings → Collaborators → add `cuXXXXXio`).
4. Authenticate the local terminal with GitHub (I use MacOS Terminal / VSCode Terminal) (`gh auth login`).
5. Clone the repository locally.
6. Open the cloned repository folder in VS Code.
7. Manually create a folder for each Baseline Level Task
   (`baseline01` … `baseline16`) and one for the Target Level Task
   (`target`) using right click → New Folder.
8. Manually create `.gitignore`, `LICENSE` and `DISCLAIMER.md` in VS
   Code same style as previous folders and fill in their
   content (I generated DISCLAILMER + .gitignore with Claude AI).
9. Commit and push using VS Code's terminal.

### Deployment instructions / CLI commands

Install and authenticate GitHub CLI (macOS), do it in macOS terminal.

```bash
brew install gh         # Download github
gh auth status          # check auth status
gh auth login           # GitHub.com → HTTPS → login with web browser
```
My auth status:
```bash
Baselines $ gh auth status
github.com
  ✓ Logged in to github.com account AONCODES (keyring)
  - Active account: true
  - Git operations protocol: https
  - Token: gho_************************************
  - Token scopes: 'gist', 'read:org', 'read:project', 'repo', 'workflow'
  ```

Clone the repository (Terminal):

```bash
cd ~/Desktop/Cloud_Project
gh repo clone AONCODES/AWS-Cloud-Project
```

You can also clone repository by copying repository URL and then `git clone https://github.com/AONCODES/AWS-Cloud-Project`. 

`git remote -v` command shows you fetch address and pushing address

```bash
Baselines $ git remote -v
origin  https://github.com/AONCODES/AWS-Cloud-Project.git (fetch)
origin  https://github.com/AONCODES/AWS-Cloud-Project.git (push)
```

Now we are set to start creating folders and files manually in VSCode (to do this, install VSCode and open your AWS-Coud-Project):

- Right click on the repo root → **New Folder** →
  typed the folder name (`baseline01`, `baseline02`, … `baseline16`,
  `target`).
- Right click → **New File** → created `.gitignore`,
  `LICENSE`, `DISCLAIMER.md` and typed their contents directly in the
  editor.
- Next we are "saving" changes to our remote repository (done in VSCode terminal).
```bash
- Git status                        # check status to see changes
- Git add .                         # add changes for the next commit
- Git commit -m "what did you do?"  # I used "feat(#1) add baseline folders and documentation manually"
- Git push                          # Sends commit to Github
```
`feat` is a conventional commit. You may use feat, fix, chore or others depending what changes are being made.

`(#1)` is used for issue linkage, more informaton in next baseline.

You can also use VScode's graphic UI for GIT (add, commit, push) = **Source Control panel** (SCP) (left sidebar) → staged changes → wrote commit
  message → **Commit** → **Sync Changes** (push). Also AI generation is possible with SCP.

