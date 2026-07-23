# homelab

Docker stack for the home server: Caddy (TLS via Tailscale) fronting
OwnTracks Recorder and a WebDAV server for Zotero.

## Setup (on the box)

```sh
sudo mkdir -p /srv/homelab && sudo chown $USER: /srv/homelab
cd ~/src/bf_dotfiles/homelab
cp .env.example .env
docker run --rm caddy:2 caddy hash-password --plaintext 'your-password' | sed 's/\$/$$/g'
# edit .env: set TS_HOSTNAME, BASIC_USER, BASIC_HASH (the $$-escaped hash), DATA_DIR
docker compose up -d
```

Sanity check: `curl -u user:pass https://<TS_HOSTNAME>/` → `ok`.

## Clients

- **OwnTracks app** (phone, must be on the tailnet): Preferences → Connection
  - Mode: HTTP
  - URL: `https://<TS_HOSTNAME>/owntracks/pub`
  - Identification: the basic auth user/pass, plus a device ID (e.g. `phone`)
  - Live map: `https://<TS_HOSTNAME>/owntracks/web/`
- **Zotero**: Settings → Sync → File Syncing → WebDAV
  - URL: `https://<TS_HOSTNAME>/dav` (Zotero appends `/zotero` itself)
  - Same basic auth credentials.

## Ollama (native, not in compose)

Installed via `curl -fsSL https://ollama.com/install.sh | sh`. To reach it
from other tailnet machines, make it listen beyond localhost:

```sh
sudo systemctl edit ollama
# add:
#   [Service]
#   Environment="OLLAMA_HOST=0.0.0.0"
sudo systemctl restart ollama
```

Then point clients (shell-gpt etc.) at `http://<box>:11434`.

## Notes

- Data lives in `$DATA_DIR` (default `/srv/homelab`), outside the repo. Back this up.
- MQTT is disabled (`OTR_PORT=0`); the phone posts over HTTP.
- Caddy fetches the `*.ts.net` cert through the mounted tailscaled socket —
  requires `tailscale up` on the host and HTTPS certificates enabled in the
  Tailscale admin console.
- Public websites later: add a `cloudflared` service pointing at caddy.
