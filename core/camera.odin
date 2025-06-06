package game

import "core:math"
import rl "vendor:raylib"


EditorCamera :: struct {
	camera:       rl.Camera3D,
	move_speed:   f32,
	speed_mult:   f32,
	rot_speed:    f32,
	pan_speed:    f32,
	zoom_speed:   f32,
	mouse_locked: bool,
}

init_editor_camera :: proc() -> EditorCamera {
	return EditorCamera {
		camera = rl.Camera3D {
			position = rl.Vector3{10.0, 10.0, 10.0},
			target = rl.Vector3{0.0, 0.0, 0.0},
			up = rl.Vector3{0.0, 1.0, 0.0},
			fovy = 45.0,
			projection = rl.CameraProjection.PERSPECTIVE,
		},
		move_speed = 20.0,
		speed_mult = 1.0,
		rot_speed = 0.002,
		pan_speed = 0.1,
		zoom_speed = 2.0,
		mouse_locked = false,
	}
}

update_editor_camera :: proc(ec: ^EditorCamera, input: ^InputBinding, dt: f32) {
	cam := &ec.camera

	is_sped_up: bool = false
	speed_mult := ec.speed_mult

	forward := rl.Vector3Normalize(cam.target - cam.position)
	right := rl.Vector3Normalize(rl.Vector3CrossProduct(forward, cam.up))
	up := cam.up

	if rl.IsKeyDown(input.speed_up) {
		speed_mult = 2.0
	}

	// Mouse look
	if rl.IsMouseButtonDown(input.look_button) {
		if !ec.mouse_locked {
			rl.DisableCursor()
			ec.mouse_locked = true
		}

		mouse_delta := rl.GetMouseDelta()
		yaw := -mouse_delta.x * ec.rot_speed
		pitch := -mouse_delta.y * ec.rot_speed

		dist := rl.Vector3Length(cam.target - cam.position)
		forward = rl.Vector3Normalize(cam.target - cam.position)

		rotation := rl.MatrixRotate(up, yaw)
		rotation = rl.Matrix(rotation * rl.MatrixRotate(right, pitch))
		forward = rl.Vector3Transform(forward, rotation)
		cam.target = cam.position + forward * dist
	} else if ec.mouse_locked {
		rl.EnableCursor()
		ec.mouse_locked = false
	}

	move_speed := ec.move_speed * speed_mult

	// Movement
	if rl.IsKeyDown(input.forward) {
		cam.position += forward * (move_speed * dt)
		cam.target += forward * (move_speed * dt)
	}
	if rl.IsKeyDown(input.backward) {
		cam.position -= forward * (move_speed * dt)
		cam.target -= forward * (move_speed * dt)
	}
	if rl.IsKeyDown(input.left) {
		cam.position -= right * (move_speed * dt)
		cam.target -= right * (move_speed * dt)
	}
	if rl.IsKeyDown(input.right) {
		cam.position += right * (move_speed * dt)
		cam.target += right * (move_speed * dt)
	}
	if rl.IsKeyDown(input.down) {
		cam.position -= up * (move_speed * dt)
		cam.target -= up * (move_speed * dt)
	}
	if rl.IsKeyDown(input.up) {
		cam.position += up * (move_speed * dt)
		cam.target += up * (move_speed * dt)
	}

	// Zoom
	zoom := input.zoom_axis * ec.zoom_speed
	if zoom != 0 {
		cam.position += forward * zoom
	}

	// Pan
	if rl.IsMouseButtonDown(input.pan_button) {
		pan := input.pan_axis
		panX := right * (-pan.x * ec.pan_speed)
		panY := up * (pan.y * ec.pan_speed)
		cam.position += panX + panY
		cam.target += panX + panY
	}
}
