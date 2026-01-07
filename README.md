# Pacman in Godot 🎮  

A Pacman-inspired game built in **Godot**, designed as both a learning project and a technical exploration of pathfinding, AI, and modular game architecture.  
This is my first fully documented, version-controlled game project.  

👉 [Play on itch.io](https://clovis-games.itch.io/maze-chompster)  

---

## Features ✨  
- Classic Pacman gameplay with win/loss conditions  
- Player movement with queued directional input  
- Four ghost types, each with distinct AI behaviors  
- Ghost states: **Chase**, **Scatter**, **Frightened**  
- Hybrid pathfinding (Pacman-inspired + BFS)  
- Scoring system (pellets + ghost eating)  
- Modular manager-based architecture  
- **Playable directly in-browser (HTML5 export)**  

---

## Pathfinding & AI ⚙️  

Pathfinding was the most challenging part of the project and where my design thinking evolved the most:  

1. **Dijkstra’s Algorithm (university studies)**  
   - Initially considered because it guarantees shortest paths.  
   - Ultimately overkill for a uniform-cost grid.  

2. **Pacman’s Original Algorithm (research)**  
   - Ghosts simply move toward the neighboring walkable tile closest to the player.  
   - Efficient, simple, and faithful to the arcade game.  

3. **Hybrid Approach (final choice)**  
   - Pacman’s method worked in most cases, but failed in tight enclosures (e.g., ghost house), where ghosts can’t move backward and risk interpolating into walls (causing `nil` references).  
   - Solution: use **Pacman’s neighbor-check** method by default, but fall back on **BFS** when ghosts need to escape the enclosure.  
   - This combination kept gameplay authentic while solving edge cases.  

---

## Architecture 🏗️  

The game is organized around a **GameManager autoload** that delegates responsibilities to specialized managers:  

- **Transition Manager** – handles state changes (GameRunning, GameOver, NextLevel, Main Menu)  
- **Music Manager** – controls background music and sound effects  
- **UI Manager** – updates score, lives, and HUD elements  
- **Object Manager** – spawns, resets, and cleans up objects  
- **Map Manager** – builds a graph of walkable tiles for pathfinding  

This modular design prevented bugs from piling up in a single script and made it easier to extend, debug, and manage state transitions.  

---

## Tech Stack 🛠️  
- Engine: [Godot 4.x](https://godotengine.org/)  
- Language: GDScript  
- Version Control: Git  
- Publishing: Itch.io (HTML5 export)  

---

## Acknowledgements 🙌  
- Inspired by the original **Pacman** arcade game  
- Thanks to the **Godot community** for tutorials and resources  

