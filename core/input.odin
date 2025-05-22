package game

import rl "vendor:raylib"

InputBinding :: struct {
	forward:     rl.KeyboardKey,
	backward:    rl.KeyboardKey,
	left:        rl.KeyboardKey,
	right:       rl.KeyboardKey,
	up:          rl.KeyboardKey,
	down:        rl.KeyboardKey,
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
	click_world_pos:     rl.Vector3,
	click_world_pos_set: bool,
}


update_input_state :: proc(bindings: ^InputBinding, input: ^InputState, camera: rl.Camera3D) {
	input.mouse_position = rl.GetMousePosition()
	input.mouse_clicked = rl.IsMouseButtonPressed(bindings.interact)

	input.click_world_pos_set = false
	if input.mouse_clicked {
		ray := rl.GetScreenToWorldRay(input.mouse_position, camera)
		hit := rl.GetRayCollisionQuad(
			ray,
			rl.Vector3{-100, 0, -100},
			rl.Vector3{100, 0, -100},
			rl.Vector3{100, 0, 100},
			rl.Vector3{-100, 0, 100},
		)
		if hit.hit {
			input.click_world_pos = hit.point
			input.click_world_pos.y = 0.5
			input.click_world_pos_set = true
		}
	}
}
