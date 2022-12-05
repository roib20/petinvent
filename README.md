# PetInvent

[![License](https://img.shields.io/badge/license-MIT-blue)](https://opensource.org/licenses/MIT)
[![CI Status](https://github.com/roib20/petinvent/actions/workflows/ci-pipeline.yml/badge.svg)](https://github.com/roib20/petinvent/actions/workflows/ci-pipeline.yml)
<br />
[![Image](https://img.shields.io/badge/image-ghcr.io%2Froib20%2Fpetinvent-orange)](https://github.com/roib20/petinvent/pkgs/container/petinvent)

An inventory for your pets! PetInvent allows you to track your pets. Many animal species and breeds are available to choose from.

This project is a full stack web application that uses DevOps best practices - including containerization, micro-services, Infrastructure as Code (IaC), CI/CD pipelines, GitOps, Kubernetes and more.

Live Demo: [petbuddy.party](https://www.petbuddy.party/)

<br />

## Installation

A local clean install using Docker and docker compose can be easily achieved using the `clean-install.sh` shell script.

Advanced users can deploy manually using Docker and docker compose, or using Kubernetes and Helm with the charts and shell scripts under the `Kubernetes` folder.

<br />

## Contribution
Is your favorite animal missing? Found any bugs? You are welcome to open issues, pull requests or forks.

<br />

## Technology Stack

### Full Stack Web Application
- **Back-end Language:**  [Python](https://www.python.org/)  
- **Back-end Framework:** [Flask](https://flask.palletsprojects.com/)  
- **Front-end Languages:** [HTML](https://developer.mozilla.org/en/docs/Web/HTML), [CSS](https://developer.mozilla.org/en/docs/Web/CSS) & [JavaScript](https://developer.mozilla.org/en/docs/Web/JavaScript)  
- **Front-end Framework:** [Bootstrap v5](https://getbootstrap.com/)
- **Database:** SQL - [PostgreSQL](https://www.postgresql.org/), [MySQL](https://www.mysql.com/), [MariaDB](https://mariadb.org/) or [SQLite](https://www.sqlite.org/)  
- **Scripting Languages**: [Bash](https://www.gnu.org/software/bash/) & [POSIX Shell Command Language](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html)  

### Containerization (Docker)
- **Container Engine:** [Docker](https://www.docker.com) & [containerd](https://containerd.io/) 
- **Container Image Format:** [OCI Image Format](https://github.com/opencontainers/image-spec), built using [Dockerfile](https://docs.docker.com/engine/reference/builder/)
- **Container Image Registry:** [GitHub Packages](https://ghcr.io) - GitHub Container Registry [^1]  
- **Deployment:** [Docker Compose](https://docs.docker.com/compose/) [^2]  

### Container Orchestration (Kubernetes)
- **Kubernetes Engine:** [Google Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine) [^3]  
- **Kubernetes Packaging:** [Helm](https://helm.sh/)  

### Pipeline
- **Infrastructure as Code (IaC):** [Terraform](https://www.terraform.io/) [^4]
- **CI/CD:** [Github Actions](https://github.com/features/actions)
  
- **GitOps:** [Argo CD](https://argoproj.github.io/cd/) [^5]  
- **Cloud Provider:** [Google Cloud Platform (GCP)](https://cloud.google.com/)  

### Kubernetes Stack [^6]
- **Application:** [PetInvent](https://ghcr.io/roib20/petinvent)  
- **Database:** [PostgreSQL HA packaged by Bitnami](https://bitnami.com/stack/postgresql-ha)  
- **Secret Management:** [Sealed Secrets](https://sealed-secrets.netlify.app/)  
- **Ingress Controller:** [Ingress NGINX Controller](https://kubernetes.github.io/ingress-nginx/)  
- **TLS Certificate:** [cert-manager](https://cert-manager.io/) & [Let's Encrypt](https://letsencrypt.org/)  
- **Authoritative DNS:** [ExternalDNS](https://github.com/kubernetes-sigs/external-dns) & [Cloudflare DNS](https://www.cloudflare.com/dns/)  
- **Domain Registrar**: [Cloudflare Registrar](https://www.cloudflare.com/products/registrar/)  

<br /><br />

[^1]: See container image here: [ghcr.io/roib20/petinvent](https://ghcr.io/roib20/petinvent) 
[^2]: Used for testing and local deployments (see `Installation` instructions above).  
[^3]: Used for cloud deployments  
[^4]: See repo: [Terraform - Provision a GKE Cluster with Cloudflare Ingress and ArgoCD](https://github.com/roib20/terraform-provision-gke-cloudflare)  
[^5]: See repo: [petinvent-gitops](https://github.com/roib20/petinvent-gitops)  
[^6]: Deployed using the Pipeline above.  
