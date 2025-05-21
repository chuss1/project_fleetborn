# Odin + Raylib Setup
> A reference document for how this project is set up with Odin and Raylib. Includes install steps, file structure, build commands, and development tips.

---
## Prerequisites

- **OS**: Linux for Development, Linux and Windows for builds
- **Language**: [Odin](https://odin-lang.org/)
- **Graphics**: [Raylib](https://www.raylib.com/)
- **Build System**: Odin's built-in package system
- **Optional**: no external dependencies if possible

---

## Project Structure

```
project_fleetborn/
├── game.odin             # Entry point and main loop
├── core/                 # Game logic (fleet, ship, simulation)
├── renderer/             # Drawing code
├── assets/               # Sprites, models, audio
└── README.md
