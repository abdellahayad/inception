*This project has been created as part of the 42 curriculum by aayad.*

# Description

Inception is a small infrastructure project focused on building and running a complete web stack with Docker. The goal is to deploy a functional  WordPress website backed by MariaDB and served through Nginx, while keeping each service isolated in its own container.

This repository contains the Dockerfiles, configuration files, startup scripts, secrets, and Compose configuration needed to build the stack from scratch. The included services are:

## NGINX:
A fast web server that delivers websites to users and can also act as a reverse proxy and load balancer to improve performance and reliability.
## WordPress:
A free, open-source platform that lets you create and manage websites and blogs without needing programming skills.
## MariaDB:
An open-source relational database that stores and organizes website data, making it easy to save, retrieve, and manage information efficiently.

# Instructions

## Prerequisites

Before running the project, make sure you have:

- Docker installed
- Docker Compose installed
- Make installed
- A Linux machine or VM

Add the domain name to your `/etc/hosts` file (requires root/sudo privileges):

```bash
127.0.0.1 aayad.42.fr
```

---

## Setup

### 1. Clone the repository

```bash
git clone <repo_URL> inception
cd inception
```

### 2. Configure secrets

Create the secret files inside the `secrets/` directory:

```bash
echo "your_db_password" > secrets/db_password.txt
echo "your_db_root_password" > secrets/db_root_password.txt
echo "your_wp_admin_password" > secrets/wordpress_admin_password.txt
echo "your_wp_user_password" > secrets/wordpress_password.txt
```

### 3. Create the environment file

Create a `.env` file inside the `srcs/` directory like this example :

```env
DOMAIN_NAME=user.42.fr
WORDPRESS_TITLE=inception
MYSQL_DATABASE=wordpress
MYSQL_USER=user_user
WP_ADMIN_USER=user
WP_ADMIN_EMAIL=user.abdo@student.42.fr
WP_USER=abdellah
WP_EMAIL=example@student.42.fr
```

---

# Build and Run

### Start the project

```bash
make up
```

### Stop the project

```bash
make down
```

### Remove containers and volumes

```bash
make clean
```

### Remove all containers, volumes, and images

```bash
make fclean
```

### Rebuild the project

```bash
make re
```

---

# Access

| Service | URL |
|---------|-----|
| WordPress | https://aayad.42.fr |

---
> **Note**
> - Before starting, make sure you have completed the prerequisites described in **`DEV_DOC.md`**.
> - These commands use the **default configuration**. To customize the environment, see **`USER_DOC.md`** or **`DEV_DOC.md`**.
> - For more information, refer to **`USER_DOC.md`** and **`DEV_DOC.md`**. 


## Resources
- https://docs.docker.com/
- https://nginx.org/en/docs/index.html
- https://wordpress.org/documentation/
- https://mariadb.com/docs
- https://youtu.be/PrusdhS2lmo?si=QUtridYNv5Zmwx89
- https://dexter-13.gitbook.io/oussama-elhadraoui/docker-doc

### AI Usage Description
*AI was used to:*
- **Learning & Conceptual Understanding:** Used to ask questions and learn low-level concepts regarding container isolation, network bridging, and volume persistence.
- **Debugging & Troubleshooting:** Assisted in debugging configuration anomalies within the custom NGINX setups, MariaDB installation scripts, and system behavior.
- **Documentation Support:** Used AI to improve the clarity, grammar, and structure of the project documentation, including this README.

# Project Description


This project uses **Docker** to run each service in its own container. Each container is built from a **Debian Bullseye** image and contains only the software it needs. This makes the project portable, reproducible, and easy to maintain.

The project includes:

- Dockerfiles for each service
- Docker Compose configuration
- Startup scripts
- Configuration files for Nginx, MariaDB, and PHP-FPM
- Docker secrets for sensitive data
- Docker volumes to store persistent data

## Main Design Choices

| Design Choice | Description |
|---------------|-------------|
| One container per service | Each service runs independently, making it easier to manage and debug. |
| Custom Docker images | Every service is built from a Debian Bullseye base image instead of using prebuilt images. |
| Bridge network | Services communicate through a private network isolated from the host. |
| Docker secrets | Passwords and sensitive data are stored securely instead of hardcoding them. |
| Docker volumes | Database and WordPress files are kept even if containers are removed. |
| Nginx as entry point | Only Nginx is exposed to the outside on port **443 (HTTPS)**. |

## Virtual Machines vs Docker

| Virtual Machines | Docker |
|------------------|--------|
| Runs a complete operating system. | Shares the host operating system kernel. |
| Requires more CPU, RAM, and storage. | Lightweight and uses fewer resources. |
| Slower to boot. | Starts in a few seconds. |
| Larger images. | Smaller images. |
| Better for running different operating systems. | Better for packaging and deploying applications. |

## Secrets vs Environment Variables

| Docker Secrets | Environment Variables |
|----------------|-----------------------|
| Designed for passwords and sensitive data. | Designed for application configuration. |
| Stored securely by Docker. | Can be viewed inside the container. |
| Mounted as files inside the container. | Available as environment variables. |
| Recommended for production. | Better for non-sensitive settings. |

## Docker Network vs Host Network

| Docker Bridge Network | Host Network |
|-----------------------|--------------|
| Provides a private network for containers. | Uses the host's network directly. |
| Containers communicate using service names. | Containers share the host IP address. |
| Better isolation and security. | Less isolation. |
| Requires port mapping. | Does not require port mapping. |
| Recommended for multi-container applications. | Mainly used for special networking needs. |

## Docker Volumes vs Bind Mounts

| Docker Volumes | Bind Mounts |
|----------------|-------------|
| Managed by Docker. | Uses a directory from the host machine. |
| Easy to back up and migrate. | Depends on a specific host path. |
| Best for databases and persistent data. | Best for editing project files during development. |
| More portable between systems. | Less portable because host paths may change. |
| Isolated from the host filesystem. | Gives direct access to host files. |

## Project Structure

```
.gitignore
├── Makefile
├── README.md
├── srcs
│   ├── docker-compose.yml
│   ├── .env
│   ├── requirements
│   │   ├── mariadb
│   │   │   ├── conf
│   │   │   │   └── mariadb.conf
│   │   │   ├── Dockerfile
│   │   │   └── tools
│   │   │       └── mariadb.sh
│   │   ├── nginx
│   │   │   ├── conf
│   │   │   │   └── nginx.conf
│   │   │   ├── Dockerfile
│   │   │   └── tools
│   │   │       └── nginx.sh
│   │   └── wordpress
│   │       ├── conf
│   │       │   └── www.conf
│   │       ├── Dockerfile
│   │       └── tools
│   │           └── wordpress.sh
│   └── secrets
│       ├── db_password.txt
│       ├── db_root_password.txt
│       ├── wordpress_admin_password.txt
│       └── wordpress_password.txt
└── USER_DOC.md
└── DEV_DOC.md

133 directories, 188 files
```


