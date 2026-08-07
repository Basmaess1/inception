*This project has been created as part of the 42 curriculum by bessabri.*

## Description
Inception is a system administration project focused on containerization and microservices architecture using Docker. The goal is to build a secure, isolated, and fully automated web infrastructure composed of three distinct services running in separate containers based on `debian:bookworm`:

*   **NGINX:** Serves as the single secure entry point (Reverse Proxy), strictly enforcing encrypted HTTPS connections over port 443.
*   **WordPress + PHP-FPM:** Processes dynamic web requests and interacts with the database.
*   **MariaDB:** Acts as the relational database storing all WordPress site data and user accounts.

### Main Design Choices
*   **Foreground Process Control:** All main processes (`nginx -g "daemon off;"`, `php-fpm8.2 -F`, and `mariadbd`) are pinned to the foreground to prevent PID 1 from exiting and container termination.
*   **Strict Security & Network Isolation:** Only port 443 is exposed to the host machine. Internal communication (WordPress to MariaDB, NGINX to WordPress) occurs strictly within a custom Docker network.
*   **Automated Provisioning:** Entrypoint scripts utilize WP-CLI and automated database initialization to set up users, configurations, and permissions on first launch without manual intervention.

---

### Architectural Comparisons

#### Virtual Machines vs. Docker
*   **Virtual Machines** run on a hypervisor, emulating virtual hardware and requiring a full "Guest Operating System" for every instance. This causes heavy system overhead, large storage footprints, and slow boot times.
*   **Docker Containers** run directly on the host machine's Linux kernel, isolating processes at the OS level using namespaces and cgroups. They do not require a separate kernel or guest OS, making them extremely lightweight, fast to start, and resource-efficient.

#### Secrets vs. Environment Variables
*   **Environment Variables** are standard key-value pairs passed to containers at runtime. While convenient, sensitive data inside environment variables can be exposed through process listings (`docker inspect`) or application logs.
*   **Secrets** (like Docker Secrets) provide a secure mechanism to deliver sensitive data (e.g., database passwords) by mounting them as temporary, encrypted files in memory (`/run/secrets/`), ensuring credentials never leak into image histories or environment logs.

#### Docker Network vs. Host Network
*   **Host Network** attaches the container directly to the host machine's network stack, completely bypassing network isolation and exposing all container ports directly to the host interface.
*   **Custom Docker Network** creates a software-defined bridge that isolates container traffic. It includes an embedded DNS resolver that maps container names (e.g., `wordpress:9000`) directly to dynamic internal IP addresses, preventing outside access to backend services.

#### Docker Volumes vs. Bind Mounts
*   **Bind Mounts** link an exact path on the host filesystem directly into the container. This can lead to severe Linux user permission conflicts when services (like MariaDB) expect specific file ownership.
*   **Docker Volumes** are managed directly by Docker within a dedicated storage location. They automatically handle internal file permission structures, ensure data persistence across container deletion, and prevent race condition crashes.

---

## Instructions

To build, configure, and launch the infrastructure from scratch, execute the provided Makefile at the root of the repository:

```bash
# Build images and start all containers in detached mode
make

# Stop and remove containers and networks
make down

# Clean up containers, networks, and persistent data volumes
make clean
```

## Resources

#### [Docker Documentation](https://docs.docker.com/get-started/get-docker/)

#### [Inception Tutorial](https://tuto.grademe.fr/inception/)

#### [Hands-on Free Labs](https://kodekloud.com/studio/labs/docker?itm_source=kodekloud.com%2Fstudio&itm_medium=referral&itm_campaign=studio_menu_ba)

#### [Inception Diagrams](https://github.com/Ismail-Taha/DockNexus/tree/main/diagrams)
