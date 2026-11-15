# Cyberpunk 2077 VR Modpack

A hosted, one-click installable modpack for Cyberpunk 2077 (patch 2.5) with the
Cyberpunk VR Port, NightCoop co-op, and a set of QoL/tweak mods.

## How to install (for players)

1. Download **`install.bat`** (ask the modpack owner for the link, or grab it
   from this repo).
2. Double-click it. You can also drag your `Cyberpunk 2077` folder onto it.
3. It will ask for your Cyberpunk 2077 folder, then download and install
   everything automatically.

Run the same `install.bat` again any time to update — it pulls the latest
modpack and applies it.

## How it works

- `files/` — the actual mod files (RED4ext + plugins, CET, redscript mods,
  archive mods, ASI loader, and shared DLLs). These are always installed.
- `configs/` — the owner's tuned configs (RED4ext, CET, NovaOptics settings,
  VR/launcher config). These are only applied on the **first** install.
- On first install it writes a marker file `.cp2077_vr_modpack_installed`
  into the game folder. On later runs that marker exists, so it **skips the
  configs** and only updates the mod files — your own settings are preserved.

## How the owner updates it

1. Edit the mod files / configs in this repo (or regenerate `files/` and
   `configs/` from your game folder).
2. Commit and push to `main`.
3. Everyone just re-runs `install.bat`.

## Hosting

The `install.bat` downloads the repo as a ZIP, so it works with GitHub (or any
host that serves a ZIP). To host on GitHub:

1. Create a repo (e.g. `cp2077-vr-modpack`) and push this folder to `main`.
2. Set the `REPO_URL` at the top of `install.bat` to:
   `https://github.com/YOUR_USERNAME/cp2077-vr-modpack/archive/refs/heads/main.zip`
3. Share the raw `install.bat` link with your friends.

> Note: the large VR archive is stored gzipped (`cyberpunkvrport.archive.gz`)
> to stay under GitHub's 100 MB per-file limit; the installer decompresses it.
