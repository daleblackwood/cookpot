@tool
class_name SceneSnapshot


static func capture(target: Node3D, settings: SnapshotTexture) -> Image:
	var editor = Engine.get_singleton(&"EditorInterface")
	if editor == null:
		return null

	var viewport := SubViewport.new()
	viewport.own_world_3d = true
	viewport.transparent_bg = true
	viewport.size = Vector2i.ONE * settings.resolution * settings.supersample
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	if settings.unshaded:
		viewport.debug_draw = Viewport.DEBUG_DRAW_UNSHADED

	var env := Environment.new()
	env.background_mode = Environment.BG_CLEAR_COLOR
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color.WHITE
	env.tonemap_mode = Environment.TONE_MAPPER_LINEAR
	var world_env := WorldEnvironment.new()
	world_env.environment = env
	viewport.add_child(world_env)

	var copy := target.duplicate() as Node3D
	copy.set_script(null)
	copy.transform = target.global_transform
	viewport.add_child(copy)

	var cam := Camera3D.new()
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	viewport.add_child(cam)

	editor.get_base_control().add_child(viewport)
	_frame_camera(cam, copy, editor.get_editor_viewport_3d(0).get_camera_3d().global_basis.orthonormalized())
	cam.make_current()

	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	var img := viewport.get_texture().get_image()
	viewport.queue_free()

	img.convert(Image.FORMAT_RGBA8)
	return _crop_square(img, settings.padding * settings.supersample, settings.resolution)


static func _frame_camera(cam: Camera3D, root: Node3D, basis: Basis) -> void:
	var to_cam := basis.inverse()
	var lo := Vector3.INF
	var hi := -Vector3.INF
	for vi: VisualInstance3D in root.find_children("*", "VisualInstance3D", true, false):
		var aabb := vi.get_aabb()
		for i in 8:
			var p := to_cam * (vi.global_transform * aabb.get_endpoint(i))
			lo = lo.min(p)
			hi = hi.max(p)
	if lo == Vector3.INF:
		lo = -Vector3.ONE * 0.5
		hi = Vector3.ONE * 0.5

	var center := Vector3((lo.x + hi.x) * 0.5, (lo.y + hi.y) * 0.5, hi.z + 1.0)
	cam.transform = Transform3D(basis, basis * center)
	cam.size = maxf(hi.x - lo.x, hi.y - lo.y) * 1.05
	cam.near = 0.05
	cam.far = hi.z - lo.z + 2.0


static func _crop_square(img: Image, pad: int, resolution: int) -> Image:
	var used := img.get_used_rect()
	if used.size == Vector2i.ZERO:
		return Image.create_empty(resolution, resolution, false, Image.FORMAT_RGBA8)
	var side := maxi(used.size.x, used.size.y) + pad * 2
	var origin := used.position + used.size / 2 - Vector2i.ONE * (side / 2)
	var out := Image.create_empty(side, side, false, Image.FORMAT_RGBA8)
	out.blit_rect(img, Rect2i(origin, Vector2i.ONE * side), Vector2i.ZERO)
	out.resize(resolution, resolution, Image.INTERPOLATE_LANCZOS)
	return out
