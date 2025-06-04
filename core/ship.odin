package game

import "core:fmt"
import rl "vendor:raylib"

next_ship_id: u32 = 0


Base_Ship :: struct {
	id:               u32, // Unique Identifier
	name:             string, // Display name
	ship_class:       Ship_Class,
	current_position: rl.Vector3,
	current_size:     rl.Vector3,
	current_model:    rl.Model,
	current_color:    rl.Color,
	bounding_box:     rl.BoundingBox,
	is_highlighted:   bool,
}


Ship_Class :: enum {
	Undefined,
	Brawler,
	Flanker,
	Sniper,
	Support,
}


create_ship :: proc(class: Ship_Class) -> Base_Ship {

	new_ship := Base_Ship {
		id               = get_ship_id(),
		name             = "Unnamed Ship",
		ship_class       = class,
		current_position = rl.Vector3{0, 0, 0},
		current_size     = rl.Vector3{1, 1, 1},
		current_model    = rl.LoadModelFromMesh(rl.GenMeshCube(1.0, 1.0, 1.0)),
		current_color    = rl.WHITE,
		bounding_box     = rl.BoundingBox{},
		is_highlighted   = false,
	}
	fmt.println("ship created with id:", new_ship.id, "Class:", new_ship.ship_class)
	return new_ship
}


get_ship_id :: proc() -> u32 {
	id := next_ship_id
	next_ship_id += 1
	return id
}

reset_ship_id_counter :: proc() {
	next_ship_id = 0
}
