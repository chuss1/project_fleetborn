package game

import "core:fmt"
import rl "vendor:raylib"

Fleet :: struct {
	ship_group:    [dynamic]Base_Ship,
	default_pos:   rl.Vector3,
	default_size:  rl.Vector3,
	default_model: rl.Model,
	current_pos:   rl.Vector3,
	current_size:  rl.Vector3,
	current_model: rl.Model,
	current_dest:  rl.Vector3,
	color:         rl.Color,
	speed:         f32,
	bounding_box:  rl.BoundingBox,
	highlighted:   bool,
	selected:      bool,
}

init_fleet :: proc(model: rl.Model) -> Fleet {
	return Fleet {
		default_pos = rl.Vector3{0.0, 0.5, 0.0},
		default_size = rl.Vector3{1.0, 1.0, 1.0},
		default_model = model,
		current_pos = rl.Vector3{0.0, 0.5, 0.0},
		current_size = rl.Vector3{1.0, 1.0, 1.0},
		current_model = model,
		current_dest = rl.Vector3{0.0, 0.5, 0.0},
		color = rl.BLUE,
		speed = 5.0,
		bounding_box = rl.BoundingBox{},
		highlighted = false,
		selected = false,
	}
}

add_ship_to_fleet :: proc(ship: Base_Ship, f: ^Fleet) {
	for i in f.ship_group {
		if i.id == ship.id {
			fmt.println("Ship already added to fleet")
			return
		}
	}
	fmt.println("Adding Ship to fleet")
	append(&f.ship_group, ship)
}

draw_fleet :: proc(f: Fleet) {
	color := f.color

	if f.highlighted {
		color = rl.YELLOW
	}

	if f.selected {
		color = rl.GREEN
	}


	rl.DrawModelEx(
		f.current_model,
		f.current_pos,
		rl.Vector3{0.0, 1.0, 0.0},
		0.0,
		f.current_size,
		color,
	)
}

reset_fleet :: proc(f: ^Fleet) {
	f.current_pos = f.default_pos
	f.current_size = f.default_size
	f.current_model = f.default_model
	f.current_dest = f.current_pos
}

update_fleet_position :: proc(fleet: ^Fleet, dt: f32) {
	if !fleet.selected {return}
	dir := fleet.current_dest - fleet.current_pos
	dist := rl.Vector3Length(dir)

	if dist > 0.05 {
		dir = rl.Vector3Normalize(dir)
		fleet.current_pos += dir * fleet.speed * dt
	}
}

update_fleet_bounding_box :: proc(fleet: ^Fleet) {
	model_bb := rl.GetModelBoundingBox(fleet.current_model)
	fleet.bounding_box = rl.BoundingBox {
		min = model_bb.min + fleet.current_pos,
		max = model_bb.max + fleet.current_pos,
	}
}

update_fleet_highlight :: proc(fleet: ^Fleet, input: ^InputState, cam: rl.Camera3D) {
	if input.hover_world_pos_set {
		ray := rl.GetScreenToWorldRay(rl.GetMousePosition(), cam)
		result := rl.GetRayCollisionBox(ray, fleet.bounding_box)
		fleet.highlighted = result.hit
	} else {
		fleet.highlighted = false
	}
}

handle_fleet_selection :: proc(fleet: ^Fleet, input: ^InputState) {
	if input.mouse_clicked {
		if fleet.highlighted {
			fmt.println("Selected Fleet")
			fleet.selected = true
		} else if fleet.selected {
			fmt.println("Moving Selected Fleet")
			fleet.current_dest = input.click_world_pos
		} else {
			fleet.selected = false
		}
	}
}
