# Task Documentation: <Task Name>

<Lyhyt yleiskuvaus tästä baseline-tehtävästä, 2-3 lausetta.>

## Task Artifacts

- `<tiedosto>.md` — tämä dokumentaatio
- `main.tf`, `variables.tf`, `outputs.tf` — Terraform-konfiguraatio
- `screenshots/` — kuvakaappaukset verifioinnista
- `terraform.tfvars.example` — esimerkki parametreista

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
