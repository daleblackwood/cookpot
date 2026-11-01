class_name CookMath


static func dease(dt: float, sharpness: float) -> float:
	return clamp(1.0 - pow(1.0 - sharpness, dt * 60.0), 0.0, 1.0)


static func clamp_s(n: float, lim: float) -> float:
	var alim = absf(lim)
	return clampf(n, -alim, alim)


static func clamp_v(v: Vector3, lim: float) -> Vector3:
	var alim = absf(lim)
	return v.clampf(-alim, alim)


static func rnd(r: int) -> int:
	return(r * 1664525 + 1013904223) % 2147483647
