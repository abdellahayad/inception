# Developer Documentation

## Project Setup

This repository expects a Linux environment with the following tools installed:

* Docker
* Docker Compose
* Make

The stack uses a custom domain. Add it to `/etc/hosts` so the browser resolves it locally:

```bash
127.0.0.1 aayad.42.fr
```

## Configuration Files And Secrets

The project depends on two kinds of local configuration under `srcs/`:

* `srcs/.env` provides non-sensitive environment values such as the domain name, database name, and WordPress users.
* `srcs/secrets/` stores the password files consumed by Docker secrets.

The required secret files are:

* `srcs/secrets/db_root_password.txt`
* `srcs/secrets/db_password.txt`
* `srcs/secrets/wordpress_admin_password.txt`
* `srcs/secrets/wordpress_password.txt`

The containers read these files at runtime. The WordPress container uses the database password secret to create `wp-config.php` and install the site on first launch.

## Build And Launch

The Makefile is the main entry point for building and running the stack.

```bash
make up
```

This command creates the persistent host directories, builds the custom images, and starts the services with Docker Compose.

Equivalent low-level command:

```bash
docker compose -f srcs/docker-compose.yml up --build -d
```

## Container And Volume Management

The provided Makefile targets are:

* `make up` to build and start the stack.
* `make down` to stop and remove the containers while keeping the persistent data.
* `make clean` to stop the stack, remove volumes, remove images, and delete the local data directory.
* `make fclean` to run `clean` and then prune unused Docker objects.
* `make re` to fully reset the stack and start it again.

Useful Docker Compose commands for day-to-day work:

```bash
docker compose -f srcs/docker-compose.yml ps
docker compose -f srcs/docker-compose.yml logs
docker compose -f srcs/docker-compose.yml down
docker compose -f srcs/docker-compose.yml down --volumes
```

## Data Storage And Persistence

Persistent data is stored on the host machine through Docker volumes:

* MariaDB data is stored in `/home/aayad/data/mariadb`
* WordPress files are stored in `/home/aayad/data/wordpress`

These paths are created automatically by the Makefile before the stack starts.

The corresponding Docker volume definitions are named `mariadb_data` and `wordpress_data` in `srcs/docker-compose.yml`.

## How The Services Are Wired

* Nginx listens on port 443 and serves the site over HTTPS.
* WordPress runs PHP-FPM and connects to MariaDB on the private Docker network.
* MariaDB initializes the database, user, and passwords on first startup, then reuses the persisted data directory afterward.

When debugging, check the container logs first, then verify the `.env` file, secret files, and the host data directories.

