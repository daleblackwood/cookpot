## Cookpot Plugin by Completely Cooked Games

Cookpot is a utility plugin for the Godot Engine that provides essential tools for game development, including input handling, 3D math utilities, and sound effect management.
Features

### CookInput:
A simple input handler for up to 4 players, supporting both gamepad and keyboard inputs. Perfect for local multiplayer setups.

It also has keyboard bindings for gamepads one and two as well as mouse bindings for gamepad one.

To find out if the primary input is pressed, do the following:
```
var input := CookInput.get_inputs(0)
if input.primary:
	print("A or Y is pressed on gamepad one. Or the Spacebar, IDK.")
```

### CookMath:
A collection of maths functions to assist with common operations (i.e. delta-independant easing) in 3D game development.

To slow the velocity down to zero exponentially, independent of framerate, do this:
```
velocity = velocity.lerp(Vector3.ZERO, CookMath.dease(delta, 0.1)
```

### CookSFX:
A one-shot sound effect player with sound effect grouping functionality, allowing for easy management and playback of sound effects.

To play a jump sound:

1. Add one or more sounds prefixed with "jump" to the CookSFX scene.

2. Call `CookSFX.play("jump", global_transform.origin)`

## How to Use

Add the plugin to your Godot project. Get it done.
