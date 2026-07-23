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

## MQTT (broker for OwnTracks + Home Assistant)

One-time: create the broker password file (uses MQTT_USER/MQTT_PASS from .env):

```sh
set -a; . ./.env; set +a
docker run --rm -v $DATA_DIR/mosquitto:/d eclipse-mosquitto:2 \
  mosquitto_passwd -c -b /d/passwd "$MQTT_USER" "$MQTT_PASS"
```

## Clients

- **OwnTracks app** (phone, must be on the tailnet): Preferences → Connection
  - Mode: MQTT
  - Host: `<TS_HOSTNAME>`, port `1883`, TLS off (tailnet is already encrypted)
  - Identification: MQTT_USER/MQTT_PASS, plus a device ID (e.g. `phone`)
  - Live map: `https://<TS_HOSTNAME>/owntracks/web/` (recorder UI, basic auth)

## Home Assistant

UI at `http://<box>:8123` (host networking; not behind Caddy — HA can't do
URL subpaths). First-run setup in the browser, then:

1. Settings → Devices & Services → Add: **MQTT** — broker `127.0.0.1:1883`,
   the MQTT_USER/MQTT_PASS creds. HA starts seeing OwnTracks messages.
2. Add: **OwnTracks** integration (uses MQTT transport automatically).
   Your phone appears as a device_tracker entity.
3. Add: **Venstar** — host = thermostat IP (give it a DHCP reservation).
   Requires Local API enabled on the thermostat.
4. Map → define the `Home` zone radius; Settings → Automations: leave Home →
   set thermostat away; arrive → resume comfort.
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
- The recorder subscribes to mosquitto (`owntracks/#`); its HTTP UI/API on
  8083 is unchanged and still proxied by Caddy at `/owntracks/*`.
- Caddy fetches the `*.ts.net` cert through the mounted tailscaled socket —
  requires `tailscale up` on the host and HTTPS certificates enabled in the
  Tailscale admin console.
- Public websites later: add a `cloudflared` service pointing at caddy.
