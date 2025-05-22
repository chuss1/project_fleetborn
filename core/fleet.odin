package game

import rl "vendor:raylib"

Fleet :: struct {
	default_pos:   rl.Vector3,
	default_size:  rl.Vector3,
	default_model: rl.Model,
	current_pos:   rl.Vector3,
	current_size:  rl.Vector3,
	current_model: rl.Model,
	current_dest:  rl.Vector3,
	color:         rl.Color,
	speed:         f32,
}

draw_fleet :: proc(f: Fleet) {
	rl.DrawModelEx(
		f.current_model,
		f.current_pos,
		rl.Vector3{0.0, 1.0, 0.0},
		0.0,
		f.current_size,
		f.color,
	)
}

reset_fleet :: proc(f: ^Fleet) {
	f.current_pos = f.default_pos
	f.current_size = f.default_size
	f.current_model = f.default_model
	f.current_dest = f.current_pos
}

update_fleet_position :: proc(fleet: ^Fleet, dt: f32) {
	dir := fleet.current_dest - fleet.current_pos
	dist := rl.Vector3Length(dir)

	if dist > 0.01 {
		dir = rl.Vector3Normalize(dir)
		fleet.current_pos += dir * fleet.speed * dt
	}
}
