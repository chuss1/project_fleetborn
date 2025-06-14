package game

import "core:fmt"
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


draw_fleet_ui_main :: proc(fleet: ^Fleet) {
	if !fleet.selected {return}

	fleet.selected = rl.GuiWindowBox((rl.Rectangle){144, 144, 128, 48}, "FLEET MENU") == 0
}
