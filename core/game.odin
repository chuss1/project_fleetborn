package game
import "core:fmt"
import "core:math"
import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(1920, 1080, "Project Fleetborn")
	rl.SetTargetFPS(60)

	cube_model := rl.LoadModelFromMesh(rl.GenMeshCube(3.0, 1.0, 1.0))

	fleet := Fleet {
		default_pos   = rl.Vector3{0.0, 0.5, 0.0},
		default_size  = rl.Vector3{1.0, 1.0, 1.0},
		default_model = cube_model,
		current_pos   = rl.Vector3{0.0, 0.5, 0.0},
		current_size  = rl.Vector3{1.0, 1.0, 1.0},
		current_model = cube_model,
		current_dest  = rl.Vector3{0.0, 0.5, 0.0},
		color         = rl.BLUE,
		speed         = 5.0,
	}

	new_cam := EditorCamera {
		camera = rl.Camera3D {
			position = rl.Vector3{10.0, 10.0, 10.0},
			target = rl.Vector3{0.0, 0.0, 0.0},
			up = rl.Vector3{0.0, 1.0, 0.0},
			fovy = 45.0,
			projection = rl.CameraProjection.PERSPECTIVE,
		},
		move_speed = 20.0,
		rot_speed = 0.002,
		pan_speed = 0.1,
		zoom_speed = 2.0,
		mouse_locked = false,
	}

	input_state: InputState

	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()
		binding := get_updated_bindings(&default_input_binding)
		update_editor_camera(&new_cam, &binding, dt)
		update_input_state(&binding, &input_state, new_cam.camera)

		if input_state.click_world_pos_set {
			fleet.current_dest = input_state.click_world_pos
			fmt.println(
				"Fleet dest updated: %f, %f, %f",
				fleet.current_dest.x,
				fleet.current_dest.y,
				fleet.current_dest.z,
			)
		}

		update_fleet_position(&fleet, dt)

		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)

		rl.BeginMode3D(new_cam.camera)

		draw_fleet(fleet)

		rl.DrawSphere(fleet.current_dest, 0.2, rl.RED)

		rl.DrawGrid(100, 2)
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
