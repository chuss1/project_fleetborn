package game
import "core:fmt"
import "core:math"
import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(1920, 1080, "Project Fleetborn")
	rl.SetTargetFPS(120)

	cube_model := rl.LoadModelFromMesh(rl.GenMeshCube(3.0, 1.0, 1.0))
	fleet := init_fleet(cube_model)
	camera := init_editor_camera()
	input_state: InputState

	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()

		binding := get_updated_bindings(&default_input_binding)
		update_editor_camera(&camera, &binding, dt)
		update_input_state(&binding, &input_state, camera.camera)

		update_fleet_position(&fleet, dt)
		update_fleet_bounding_box(&fleet)
		update_fleet_highlight(&fleet, &input_state, camera.camera)
		handle_fleet_selection(&fleet, &input_state)

		draw_scene(&fleet, camera)
	}
	rl.CloseWindow()
}
