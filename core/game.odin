package game
import "core:math"
import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(1920, 1080, "Project Fleetborn")
	rl.SetTargetFPS(60)

	new_cam := EditorCamera {
		camera = rl.Camera3D {
			position = rl.Vector3{10.0, 10.0, 10.0},
			target = rl.Vector3{0.0, 0.0, 0.0},
			up = rl.Vector3{0.0, 1.0, 0.0},
			fovy = 45.0,
			projection = rl.CameraProjection.PERSPECTIVE,
		},
		move_speed = 10.0,
		rot_speed = 0.003,
		pan_speed = 0.1,
		zoom_speed = 2.0,
		mouse_locked = false,
	}

	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()
		update_editor_camera(&new_cam, dt)

		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)

		rl.BeginMode3D(new_cam.camera)
		rl.DrawCube(rl.Vector3{0.0, 0.0, 0.0}, 2.0, 2.0, 2.0, rl.RED)
		rl.DrawCubeWires(rl.Vector3{0.0, 0.0, 0.0}, 2.0, 2.0, 2.0, rl.DARKBROWN)
		rl.DrawGrid(20, 1)
		rl.EndMode3D()

		rl.DrawText(
			"Editor Camera Controls - RMB to rotate, MMB to pan, Scroll to zoom, WASD to move",
			20,
			20,
			20,
			rl.LIGHTGRAY,
		)
		rl.EndDrawing()
	}

	rl.CloseWindow()
}
