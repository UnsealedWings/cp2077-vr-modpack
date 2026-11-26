# BUGS AND FIXES ΓÇö NEVER REMOVE OR REVERT THESE
This file is the source of truth for every bug fixed on this project. Do not remove it.
Before re-adding any old commit/file, check this list so you do not reintroduce a fixed bug.
## 1. VR lobby "still texture" (both eyes + desktop frozen on one image)
- CAUSE: DLL built from build\ (Visual Studio 17 2022). Wrong compiler.
- FIX: build ONLY from build-vs18 (Visual Studio 18 2026).
- Command: cmake --build build-vs18 --config Release --target cyberpunkvrport_stereo
- NEVER build from build\.
## 2. "Project screen" bug (VR view stays on a flat screen, does not hook to VR)
- CAUSE: vrport_pose.reds switched to VRHandRawWorld / VRHandRawWorldRot (coop pose) with 
ative func declarations.
- FIX: vrport_pose.reds must use VRPalmModelPos / VRPalmModelRot (the b8fb4e2 version). Do NOT change it back to VRHandRawWorld.
- File: files/red4ext/plugins/cyberpunkvrport/scripts/CyberpunkVRPose/vrport_pose.reds
## 3. redscript launch failure ("corrupted scripts" / game won't start)
- CAUSE: vrport_pose.reds referencing natives that the DLL did not declare.
- FIX: keep the 
ative func declarations in sync with the DLL's registered natives (Registration.cpp).
## 4. RED4ext error 1114 / launch failure (non-VR installs)
- CAUSE: version.dll ASI loader present.
- FIX: version.dll must stay removed (b8fb4e2, v21).
