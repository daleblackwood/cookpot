## Cookpot Plugin by Completely Cooked Games

Cookpot is a plugin for Godot that provides essential tools for game prototyping, including input handling, 3D math utilities, and sound effect management.
Features


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

1. Add one or more sounds prefixed with "jump" to a CookSFXList resource.
2. Add the CookSFXList resource to the CookSFX scene (or assign via code)
3. Call `CookSFX.play("jump", global_transform.origin)`


### CookGFX:

A one-shot scene effect instnacer with pooling functionality, allowing for easy management and playback of graphics effects.

**For example:**, to play a smoke particle effect:

1. Add a scene with a smoke particle called "smoke" to a CookGFXList resource.
2. Add the CookGFXList resource to the CookGFX scene (or assign via code)
3. Call `CookGFX.fire("smoke", global_transform.origin)`

## How to Use

Add the plugin to your Godot project. Get it done.
