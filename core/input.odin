package game

import rl "vendor:raylib"

InputBinding :: struct {
	forward:     rl.KeyboardKey,
	backward:    rl.KeyboardKey,
	left:        rl.KeyboardKey,
	right:       rl.KeyboardKey,
	up:          rl.KeyboardKey,
	down:        rl.KeyboardKey,
	speed_up:    rl.KeyboardKey,
	interact:    rl.MouseButton,
	look_button: rl.MouseButton,
	pan_button:  rl.MouseButton,
	zoom_axis:   f32,
	look_axis:   rl.Vector2,
	pan_axis:    rl.Vector2,
}

default_input_binding: InputBinding = InputBinding {
	forward     = rl.KeyboardKey.W,
	backward    = rl.KeyboardKey.S,
	left        = rl.KeyboardKey.A,
	right       = rl.KeyboardKey.D,
	up          = rl.KeyboardKey.E,
	down        = rl.KeyboardKey.Q,
	speed_up    = rl.KeyboardKey.LEFT_SHIFT,
	interact    = rl.MouseButton.LEFT,
	look_button = rl.MouseButton.RIGHT,
	pan_button  = rl.MouseButton.MIDDLE,
	zoom_axis   = 0.0,
	look_axis   = rl.GetMouseDelta(),
	pan_axis    = rl.GetMouseDelta(),
}

get_updated_bindings :: proc(base: ^InputBinding) -> InputBinding {
	return InputBinding {
		forward = base.forward,
		backward = base.backward,
		left = base.left,
		right = base.right,
		up = base.up,
		down = base.down,
		speed_up = base.speed_up,
		interact = base.interact,
		look_button = base.look_button,
		pan_button = base.pan_button,
		zoom_axis = rl.GetMouseWheelMove(),
		look_axis = rl.GetMouseDelta(),
		pan_axis = rl.GetMouseDelta(),
	}
}

InputState :: struct {
	mouse_position:      rl.Vector2,
	mouse_clicked:       bool,
	mouse_released:      bool,
	mouse_held:          bool,
	click_world_pos:     rl.Vector3,
	click_world_pos_set: bool,
	hover_world_ray:     rl.Ray,
	hover_world_pos:     rl.Vector3,
	hover_world_pos_set: bool,
}


update_input_state :: proc(bindings: ^InputBinding, input: ^InputState, camera: rl.Camera3D) {
	input.mouse_position = rl.GetMousePosition()
	input.mouse_clicked = rl.IsMouseButtonPressed(bindings.interact)
	input.mouse_held = rl.IsMouseButtonDown(bindings.interact)
	input.mouse_released = rl.IsMouseButtonReleased(bindings.interact)

	input.hover_world_ray = rl.GetScreenToWorldRay(input.mouse_position, camera)
	input.hover_world_pos_set = false
	input.click_world_pos_set = false

	hover_hit := rl.GetRayCollisionQuad(
		input.hover_world_ray,
		rl.Vector3{-100, 0, -100},
		rl.Vector3{100, 0, -100},
		rl.Vector3{100, 0, 100},
		rl.Vector3{-100, 0, 100},
	)
	if hover_hit.hit {
		input.hover_world_pos = hover_hit.point
		input.hover_world_pos.y = 0.5
		input.hover_world_pos_set = true
	}

	if input.mouse_clicked {
		input.click_world_pos = input.hover_world_pos
		input.click_world_pos_set = input.hover_world_pos_set
	}

}
