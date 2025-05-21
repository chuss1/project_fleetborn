> This document describes the technical foundation of the custom engine built for this game. It outlines major systems, how they interact, and what responsibilities each module owns.

---
## Goals

- Lightweight and focused on simulating autonomous fleet battles
- Modular system separation (not ECS)
- Easily debug visuals (raylib + rayGUI)
- Extensible for campaign layer later

---
## Core Systems

| System / Module       | Description                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| **Fleet System**       | Manages groups of ships. Handles formation setup and fleet metadata.        |
| **Ship System**        | Updates individual ships: movement, status, damage, AI state, etc.          |
| **Weapon System**      | Manages weapon cooldowns, firing logic, and projectile creation.            |
| **Projectile System**  | Updates active projectiles: movement, collision detection, and resolution.  |
| **AI System**          | Determines ship behavior (e.g. targeting, movement decisions, fleeing).     |
| **Simulation Loop**    | The main game loop for battles: updates ships, weapons, projectiles, etc.   |
| **Renderer**           | Draws 3D visuals using Raylib, including ships, projectiles, effects, etc.  |
| **UI Layer (Optional)**| Uses ImGui or Raylib's 2D functions for controls, debug panels, HUD, etc.   |
| **Input / Setup**      | Handles pre-battle setup, fleet creation, and input (if applicable).        |
