package game

import "core:math"
import rl "vendor:raylib"


EditorCamera :: struct {
	camera:       rl.Camera3D,
	move_speed:   f32,
	rot_speed:    f32,
	pan_speed:    f32,
	zoom_speed:   f32,
	mouse_locked: bool,
}

update_editor_camera :: proc(ec: ^EditorCamera, input: ^InputBinding, dt: f32) {
	cam := &ec.camera

	forward := rl.Vector3Normalize(cam.target - cam.position)
	right := rl.Vector3Normalize(rl.Vector3CrossProduct(forward, cam.up))
	up := cam.up

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

	// Movement
	if rl.IsKeyDown(input.forward) {
		cam.position += forward * (ec.move_speed * dt)
		cam.target += forward * (ec.move_speed * dt)
	}
	if rl.IsKeyDown(input.backward) {
		cam.position -= forward * (ec.move_speed * dt)
		cam.target -= forward * (ec.move_speed * dt)
	}
	if rl.IsKeyDown(input.left) {
		cam.position -= right * (ec.move_speed * dt)
		cam.target -= right * (ec.move_speed * dt)
	}
	if rl.IsKeyDown(input.right) {
		cam.position += right * (ec.move_speed * dt)
		cam.target += right * (ec.move_speed * dt)
	}
	if rl.IsKeyDown(input.down) {
		cam.position -= up * (ec.move_speed * dt)
		cam.target -= up * (ec.move_speed * dt)
	}
	if rl.IsKeyDown(input.up) {
		cam.position += up * (ec.move_speed * dt)
		cam.target += up * (ec.move_speed * dt)
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
