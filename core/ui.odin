package game

import rl "vendor:raylib"

draw_ui :: proc() {
	rl.DrawText(
		"Editor Camera Controls - RMB to rotate, MMB to pan, Scroll to zoom, WASD to move",
		20,
		20,
		20,
		rl.LIGHTGRAY,
	)
}
