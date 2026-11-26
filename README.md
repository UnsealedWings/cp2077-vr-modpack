# Cyberpunk 2077 VR Modpack

A hosted, one-click installable modpack for Cyberpunk 2077 (patch 2.5) with the
Cyberpunk VR Port, NightCoop co-op, and a set of QoL/tweak mods.

## How to install (for players)

1. Download **`install.bat`** and place it inside your `Cyberpunk 2077` folder.
2. Double-click it **from inside the game folder**.
3. Choose `1` (full modpack with VR) or `2` (everything except VR).
4. It downloads and installs everything automatically.

Run `install.bat` again any time to update — if you're already on the latest
version (and have all the latest files) it just says "You're up to date!".

## How it works

- `files/` — the actual mod files (RED4ext + plugins, CET, redscript mods,
  archive mods, ASI loader, and shared DLLs). These are always installed.
- `configs/` — the owner's tuned configs (RED4ext, CET, NovaOptics settings,
  VR/launcher config, and the shared graphical `UserSettings.json`). These are
  only applied on the **first** install.
- On first install it writes a marker file `.cp2077_vr_modpack_installed`
  into the game folder. On later runs that marker exists, so it **skips the
  configs** and only updates the mod files — your own settings are preserved.
- The installer checks the latest version first; if it matches what's
  installed it just says "You're up to date!" and exits.
- The VR prompt (`1` = full modpack with VR, `2` = everything except VR):
  - `1` installs the VR port (which bundles redscript) and removes any
    standalone redscript.
  - `2` skips the VR port and installs a standalone redscript instead, so the
    other mods still work.

## Hosting

The `install.bat` downloads the repo as a ZIP, so it works with GitHub (or any
host that serves a ZIP). To host on GitHub:

1. Create a repo (e.g. `cp2077-vr-modpack`) and push this folder to `main`.
2. Set the `REPO_URL` at the top of `install.bat` to:
   `https://github.com/YOUR_USERNAME/cp2077-vr-modpack/archive/refs/heads/main.zip`
3. Share the raw `install.bat` link with your friends.

> Note: the large VR archive is stored gzipped (`cyberpunkvrport.archive.gz`)
> to stay under GitHub's 100 MB per-file limit; the installer decompresses it.
