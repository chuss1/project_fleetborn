package game

import "core:fmt"
import rl "vendor:raylib"


Base_Ship :: struct {
	id:               u64, // Unique Identifier
	name:             string, // Display name
	ship_class:       Ship_Class,
	current_position: rl.Vector3,
	current_size:     rl.Vector3,
}


Ship_Class :: enum {
	Undefined,
	Brawler,
	Flanker,
	Sniper,
	Support,
}

create_ship :: proc(class: Ship_Class) {
	switch class {
	case .Undefined:
		fmt.println("Spawning Undefined ship")
	case .Brawler:
		fmt.println("Spawning Brawler Ship")
	case .Flanker:
		fmt.println("Spawning Flanker Ship")
	case .Sniper:
		fmt.println("Spawning Sniper Ship")
	case .Support:
		fmt.println("Spawning Support Ship")
	}
}
