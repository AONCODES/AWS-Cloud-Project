# Task Documentation: Setup Kanban and Slack

This task establishes project development tracking and communication for the project. GitHub Project Kanban board is used to track the
progress of the Baseline and Target Level Tasks, and the course Slack workspace is used for communication.

## Task Artifacts

- `<tiedosto>.md` — tämä dokumentaatio
- `main.tf`, `variables.tf`, `outputs.tf` — Terraform-konfiguraatio
- `screenshots/` — kuvakaappaukset verifioinnista
- `terraform.tfvars.example` — esimerkki parametreista
- `screenshots/`- automate screenshot folders to each baseline folder.

In VSCode press `cmd + ,` then search `Markdown Copy Files: Destination` then add file and type:

![alt text](<screenshots/Näyttökuva 2026-09-16 kello 20.17.47.png>)


This will automatically create `screenshots` folder to your working folder when screenshots are added.


## Task Description
### Mission

<Mitä tässä tehtävässä piti saada aikaan.>

### Naming convention

Snake_case, muoto `<project>_<env>_<resource_type>_<descriptor>`:

```
ctfd_dev_vpc_main
ctfd_dev_subnet_public_az1
ctfd_dev_sg_web
```

### Tagging

| Tag | Arvo |
|-----|------|
| implementation | ctfd |
| task | baseline_NN |
| responsible | <nimi> |
| deployment | dev |

Resurssien haku tagien perusteella:

```bash
aws resourcegroupstaggingapi get-resources \
  --tag-filters Key=task,Values=baseline_NN
```

### Handled outside IaC

<Mitä tehtiin käsin konsolissa tai CLI:llä.>

### Handled by IaC

<Mitä Terraform hoitaa.>

### File structure

```
baselineNN/
  <task-name>.md
  main.tf
  variables.tf
  outputs.tf
  terraform.tfvars.example
  screenshots/
```

### Parametering

| Muuttuja | Oletus | Kuvaus |
|----------|--------|--------|
| region | eu-north-1 | AWS-alue |

### Deployment process

```bash
cd baselineNN
terraform init
terraform plan
terraform apply
```

### CLI commands

```bash
<komennot joita käytit tarkistamiseen>
```

### Verification of deployment

![verification](screenshots/verification.png)

### Errors encountered and solutions

| Ongelma | Ratkaisu |
|---------|----------|
| | |

### Architecture picture

<Kuva tai linkki diagrammiin.>

### Prompts and models used

<AI-työkalut ja mihin niitä käytit.>

### Sources

- <linkki>

### What is needed later

<Mitä viedään seuraavaan tehtävään.>
TEMPLATE_EOF

git add TASK_TEMPLATE.md
git commit -m "docs: add task documentation template based on trainer template"
git push