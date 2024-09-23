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
2. Add the CookSFXList resource to the CookSFX scene (or assign via code)
3. Call `CookSFX.play("jump", global_transform.origin)` to play it


### CookMusic:

A looping background music player with master volume and loop control

**For example:** to play a music:

1. Create a CookMusicList resource.
2. Add a music file called something like `res://music/music.mp3`
2. Add the CookMusicList resource to the CookMusic scene (or assign via code)
3. Call `CookMusic.play("music")`



### CookGFX:

A one-shot scene effect instnacer with pooling functionality, allowing for easy management and playback of graphics effects.

**For example:**, to play a smoke particle effect:

1. Create a CookGFXList resource.
1. Add a scene with a smoke particle called something like `res://gfx/smoke.tsn` to the CookGFXList resource.
2. Add the CookGFXList resource to the CookGFX scene (or assign via code)
3. Call `CookGFX.fire(self, "smoke", global_transform.origin)`

## How to Use

Add the plugin to your Godot project and you're ready to go.
