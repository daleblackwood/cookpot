## Cookpot Plugin by Completely Cooked Games

Cookpot is a plugin for Godot that provides essential tools for game prototyping, including input handling, sound effect management, graphic fx pooling / spawning and music management


## Features


### CookInput:

A simple input handler for up to 4 players, supporting both gamepad and keyboard inputs. Perfect for local multiplayer setups.

It also has keyboard bindings for gamepads one and two as well as mouse bindings for gamepad one.

**For example:** to find out if the primary input is pressed, do the following:
```
var input := CookInput.get_inputs(0)
if input.primary:
	print("A or Y is pressed on gamepad one. Or the Spacebar, IDK.")
```


### CookMath:

A collection of maths functions to assist with common operations (i.e. delta-independant easing) in 3D game development.

**For example:** to slow the velocity down to zero exponentially, independent of framerate, do this:
```
velocity = velocity.lerp(Vector3.ZERO, CookMath.dease(delta, 0.1))
```


### CookSFX:

A one-shot sound effect player with sound effect grouping functionality, allowing for easy management and playback of sound effects.

**For example:** to play a jump sound:

1. Create a CookSFXList resource.
2. Add a sound called something like `res://sounds/jump.wav` to the CookSFXList resource.
3. Add the CookSFXList resource to the CookSFX scene (or assign via code)
4. Call `CookSFX.play("jump", global_transform.origin)` to play it
```
CookSFX.play("<registered-sound-file-basename>", global_transform.origin)
```

**Groups**:

You can group sounds by calling them jump1, jump2, jump3, etc - they'll automatically switch between.


### CookMusic:

A looping background music player with master volume and loop control

**For example:** to play a music:

1. Create a CookMusicList resource.
2. Add a music file called something like `res://music/music.mp3`
3. Add the CookMusicList resource to the CookMusic scene (or assign via code)
4. Call `CookMusic.play("music")`

```
CookSFX.play("<registered-music-file-basename>")
```


**Repeats**:

Set the start loop and end loop points (in seconds) to have continuous music.


### CookGFX:

A one-shot scene effect instnacer with pooling functionality, allowing for easy management and playback of graphics effects.

**For example:**, to play a smoke particle effect:

1. Create a CookGFXList resource.
2. Add a scene with a smoke particle called something like `res://gfx/smoke.tsn` to the CookGFXList resource.
3. Add the CookGFXList resource to the CookGFX scene (or assign via code)
4. Call `CookGFX.fire("smoke", global_transform.origin)`

```
 # instatiate 1 gfx inst
CookGFX.fire("<registered-effect-scene-basename>", global_transform.origin, [optional-data])

 # instatiate 10
CookGFX.fire_many(10, "<registered-effect-scene-basename>", global_transform.origin, [optional-data])

 # fire a rigidbody and impulse fling
CookGFX.fire_body("<registered-effect-scene-basename>", global_transform.origin, 20, 10, [optional-data])

# fire many rigidbodies
CookGFX.fire_bodies(3, ...) 
```

And if you need to handle the firing event in a script...

```
func _on_fire(data: Variant) -> void:
	print("fire", data)
```

## How to Use this plugin

Add the plugin to your Godot project and you're ready to go.
