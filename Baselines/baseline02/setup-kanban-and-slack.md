# Task Documentation: Setup Kanban and Slack

This task establishes project development tracking and communication for the project. GitHub Project Kanban board is used to track the
progress of the Baseline and Target Tasks, and the course Slack workspace is used for communication.

## Task Artifacts

- `baseline02/setup-kanban-and-slack.md` — this documentation
- GitHub Project Kanban board - project progress tracking
- Baseline GitHub Issues
- Slack webhook documentation
- `screenshots/`- screenshot folders to each baseline folder.

## Task Description
### Mission

Create a GitHub Project Kanban board (+ invite trainer) for tracking the Cloud Project, create an Issues for each Baseline Task, and join the course Slack workspace. Configurate VSCode to add `/screenshot` folders to each Baseline folder.

### Deployment process
1. Configure VS Code Markdown Copy Files: Destination
2. Create a GitHub Project for the Cloud Project.
3. Configure the Project statuses: Todo, In Progress, Blocked, and Done.
4. Invite the trainer to the GitHub Project.
5. Create GitHub Issues for the Baseline and Target Level Tasks.
6. Add the Issues to the GitHub Project.
7. Move the current Baseline Task to Doing.
8. Test Issue linkage by referencing the current Issue ID in a Git commit.
9. Join the course Slack workspace.
10. Document the required Slack webhook configuration.
11. Add verification screenshots to the documentation.


### Screenshots/
In VSCode press `cmd + ,` then search `Markdown Copy Files: Destination` then add file and type:

![alt text](<screenshots/kuva1.png>)


This will automatically create `screenshots` folder to your working folder when screenshots are added.


![alt text](<screenshots/kuva2.png>)

### Kanban

The Kanban board is used to visualize the progress of all Baseline and Target Tasks. Start by creating a new GitHub Project. 
```bash
AWS-Cloud-Project repository
-> Projects 
-> New Project  
-> Kanban 
-> Create project.
```
The project contains the following lanes (named according to trainer instructions):
```bash
Todo
In Progress  
Blocked  
Done
```

Then go to project settings -> manage access and invite trainer as a collaborator.


### Issues

![alt text](screenshots/image.png)

### Slack

### Deployment Process

### What is needed later
