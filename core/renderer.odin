package game

import rl "vendor:raylib"

draw_scene :: proc(fleet: ^Fleet, camera: EditorCamera) {
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)
	rl.BeginMode3D(camera.camera)

	if fleet.highlighted {
		fleet.color = rl.YELLOW
	} else {
		fleet.color = rl.BLUE
	}

	draw_fleet(fleet^)
	rl.DrawSphere(fleet.current_dest, 0.2, rl.RED)
	rl.DrawGrid(100, 2)

	rl.EndMode3D()
	draw_ui()
	rl.EndDrawing()
}
