# glance-config

Configuration and deploy script for my homelab [Glance](https://github.com/glanceapp/glance) dashboard ("fluxt // control").

## Contents

- `glance.yml` - dashboard config: theme, branding, and a Home page with clock, weather,
  AdGuard DNS stats, search, Devon news RSS feeds, bookmarks and a service monitor.
- `remote_update.bat` - Windows helper that copies `glance.yml` to the server with `scp`.

## How it runs

Glance runs in Docker on an Ubuntu Server host, with the config directory bind-mounted
into the container:

```yaml
services:
  glance:
    container_name: glance
    image: glanceapp/glance
    restart: unless-stopped
    env_file: .env
    volumes:
      - ./config:/app/config
      - /etc/localtime:/etc/localtime:ro
    ports:
      - 8082:8080
```

Secrets are not stored in this repo. The AdGuard password is read from an `ADGUARD_PASSWORD`
variable in a `.env` file next to `docker-compose.yml` on the server (not committed).

## Usage

### Edit locally

1. Edit `glance.yml`.
2. Save.

### Deploy

Run `remote_update.bat` from PowerShell or Command Prompt. It uploads `glance.yml` to
`/home/james/stacks/glance/config/` on the server using `scp`. Glance reloads the config
automatically, so no restart is needed. If an update contains an error, Glance keeps running
the old config and logs the problem (`docker compose logs glance`).

Set `REMOTE_USER`, `REMOTE_HOST` and `REMOTE_PATH` at the top of the script if they change.
SSH key authentication is used so the script doesn't prompt for a password.
