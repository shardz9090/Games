<!-- TOC --><a name="godot-design-guidelines"></a>
# Godot Design Guidelines
This document consists of some curated Design guideline for GdScript and Project structure. Addition information regarding to design guidelines can be found in Godot Docs under [GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html) and [PEP 8 guideline](https://peps.python.org/pep-0008/)

**TABLE OF CONTENTS**
<!-- TOC start -->
- [Godot Design Guidelines](#godot-design-guidelines)
   * [Naming conventions¶](#naming-conventions)
   * [Code Order](#code-order)
   * [Comments](#comments)
   * [Code Layout](#code-layout)
      + [Indentation¶](#indentation)
      + [Trailing comma¶](#trailing-comma)
      + [Blank lines¶](#blank-lines)
      + [Line length¶](#line-length)
      + [One statement per line¶](#one-statement-per-line)
      + [Format multiline statements for readability¶](#format-multiline-statements-for-readability)
      + [Avoid unnecessary parentheses¶](#avoid-unnecessary-parentheses)
      + [Boolean operators¶](#boolean-operators)
   * [Static Typing](#static-typing)
   * [Scene Organization](#scene-organization)
   * [Return Types](#return-types)

<!-- TOC end -->

<!-- TOC --><a name="naming-conventions"></a>
## Naming conventions[¶](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#naming-conventions "Permalink to this headline")

```py
# variable name should be 
var name: <space><Type> = <value>

example: 
var player_name: String = "User21"
```

**Constants :** Write constants with CONSTANT_CASE, that is to say in all caps with an underscore (_) to separate words:

```py
const MAX_SPEED = 200
```

**Enums :** Use PascalCase for enum names and CONSTANT_CASE for their members, as they are constants:

> enum should always start with 1
```py
enum Element {
    EARTH = 1,
    WATER,
    AIR,
    FIRE
}
```

**Class :** Use PascalCase for class names

```py	
# this class file name sould be controllable_player.gd
class_name ControllablePlayer
```

**Public Variable :** Use snake_case for Public Variable

```py
var public_variable: int = 0
```

**Private Variable :** Use snake_case for Private Variable with “_” as prefix

```py
var _reconnecting_player: Player
```

**Signal Name :** Use “snake_case” for signal name and must be in past tense
>signal should always have parenthesis

```py
signal user_account_deleted(p_deleted_account) # p_deleted_account <Player>
```

**Signal Parameter Name :** Use “snake_case” for signal parameter name with “p_” as prefix.

```py
signal user_account_deleted(p_deleted_account) # p_deleted_account <Player>
```

**Function name :** Use “snake_case” for function names

```py
func _on_user_account_deleted(p_deleted_account: Player ) -> void:
```

**Unused Function parameter :** Use “snake_case” with "\_p_" prefix

```py
func _process(_p_delta: float) -> void:
```

**Local variable :** Use “snake_case” with “m_” prefix

```py
func foo() -> void:
    var m_bar: String = "bar"
    print(m_bar)
```

**Unused variable :** use strict "\_\_" as variable name for return value that is not used.
```py
func _ready() -> void:
    var __: int = RemoteConfig.connect("activated", self, "_on_remote_config_activated", [], CONNECT_ONESHOT)


func foo() -> void:
    var x: Dictionary = {"cat": "meow", "dog": "whoof"}
    var __: bool = x.erase("cat")
```

**File Naming :** Every file name should strictly adhere to “snake_case” convention

**Folder Naming :** Every folder name should strictly adhere to “snake_case” convention


<!-- TOC --><a name="code-order"></a>
## Code Order
```
1. Script Description ## Comment regarding script file
2. tool
3. class_name
4. extends
5. signals
6. enums
7. constants
8. exported variables
9. public variables
10. private variables
11. onready variables
12. optional built-in virtual _init method
13. built-in virtual _ready method
14. remaining built-in virtual methods
15. static methods
16. public methods
17. private methods
```
In case of methods add newer functions to the ***end of the respective*** function category.


### Virtual Methods Code Order 
```
1. _init ( ) virtual
2. _enter_tree ( ) virtual
3. _ready ( ) virtual
4. _process ( float delta ) virtual
5. _physics_process ( float delta ) virtual
6. _input ( InputEvent event ) virtual
7. _unhandled_input ( InputEvent event ) virtual
8. _unhandled_key_input ( InputEventKey event ) virtual
9. _gui_input ( InputEvent event )
10. _notification ( int what ) virtual
11. _to_string ( ) virtual
12. _exit_tree ( ) virtual
```
> addition vertial methods such as _get, _get_property_list, _set etc can be kept before _exit tree.

<!-- TOC --><a name="comments"></a>
## Comments
Use single line comments for consistency i.e “#” except for script description.
-   When adding actual comments the comment must include “<space> after “#”
-   For code line comment “<space>” is not required and can use “cmd + k” key inside code to comment and uncomment.

Script description comment should include double hash **"##"**

```py
## Builder Class
## Compilation of static methods that returns:
## 	-> Different Success and Failure HTTPResponse Object
class_name HTTPResponseBuilder
extends Reference
```
***Example:***


<!-- TOC --><a name="code-layout"></a>
## Code Layout

<!-- TOC --><a name="indentation"></a>
### Indentation[¶](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#indentation "Permalink to this headline")

Use indentation with **tabs** 

>Tips: Enable both Draw Space and Draw tabs in Editor Settings under Indentation  
Editor_Settings > Indentation > Draw Space / Draw Tabs

>Each indent level should be one greater than the block containing it.

**Good**:

```py
for i in range(10):
    print("hello")
```

**Bad**:

```py
for i in range(10):
    print("hello")

for i in range(10):
    print("hello")
```

**Good**:
```py
effect.interpolate_property(
    sprite,
    "transform/scale",
    sprite.get_scale(),
    Vector2(2.0, 2.0),
    0.3,
    Tween.TRANS_QUAD,
    Tween.EASE_OUT
)
```

**Not Recommended**:

```py
effect.interpolate_property(sprite, "transform/scale",
    sprite.get_scale(), Vector2(2.0, 2.0), 0.3,
    Tween.TRANS_QUAD, Tween.EASE_OUT)
```

**Bad**:

```py
effect.interpolate_property(sprite, "transform/scale",
    sprite.get_scale(), Vector2(2.0, 2.0), 0.3,
    Tween.TRANS_QUAD, Tween.EASE_OUT)
```

>Exceptions to this rule are **arrays, dictionaries, and enums. Use a single indentation level** to distinguish continuation lines:

**Good**:

```py
var party: Array = [
    "Godot",
    "Godette",
    "Steve",
]

var character_dict: Dictionary = {
    "Name": "Bob",
    "Age": 27,
    "Job": "Mechanic",
}

enum Tiles {
    TILE_BRICK,
    TILE_FLOOR,
    TILE_SPIKE,
    TILE_TELEPORT,
}
```

**Bad**:

```py
var party = [
        "Godot",
        "Godette",
        "Steve",
]

var character_dict = {
        "Name": "Bob",
        "Age": 27,
        "Job": "Mechanic",
}

enum Tiles {
        TILE_BRICK,
        TILE_FLOOR,
        TILE_SPIKE,
        TILE_TELEPORT,
}
```

<!-- TOC --><a name="trailing-comma"></a>
### Trailing comma[¶](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#trailing-comma "Permalink to this headline")

Use a trailing comma on the last line in arrays, dictionaries, and enums. This results in easier refactoring and better diffs in version control as the last line doesn't need to be modified when adding new elements.

**Good**:

```py
enum Tiles  {
	TILE_BRICK,
	TILE_FLOOR,
	TILE_SPIKE,
	TILE_TELEPORT,
}
```

**Bad**:

```py
enum Tiles  {
	TILE_BRICK,
	TILE_FLOOR,
	TILE_SPIKE,
	TILE_TELEPORT
}
```

Trailing commas are unnecessary in single-line lists, so don't add them in this case.

**Good**:

```py
enum  Tiles  {TILE_BRICK,  TILE_FLOOR,  TILE_SPIKE,  TILE_TELEPORT}
```

**Bad**:

```py
enum  Tiles  {TILE_BRICK,  TILE_FLOOR,  TILE_SPIKE,  TILE_TELEPORT,}
```

<!-- TOC --><a name="blank-lines"></a>
### Blank lines[¶](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#blank-lines "Permalink to this headline")

Surround functions and class definitions with two blank lines:

```py
func heal(amount):
    health += amount
    health = min(health, max_health)
    health_changed.emit(health)


func take_damage(amount, effect=null):
    health -= amount
    health = max(0, health)
    health_changed.emit(health)
```

Use one blank line inside functions to separate logical sections.

>Note
We use a single line between classes and function definitions in the class reference and in short code snippets in this documentation.

<!-- TOC --><a name="line-length"></a>
### Line length[¶](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#line-length "Permalink to this headline")

Keep individual lines of code under 80 characters.
This helps to read the code on small displays and with two scripts opened side-by-side in an external text editor. For example, when looking at a differential revision.

> change max character value in Editor Settings

>Modify Guideline color size and length under Editor setting and color for more visibility

<!-- TOC --><a name="one-statement-per-line"></a>
### One statement per line[¶](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#one-statement-per-line "Permalink to this headline")

Never combine multiple statements on a single line. No, C programmers, not even with a single line conditional statement.

**Good**:

```py
if position.x > width:
    position.x = 0

if flag:
    print("flagged")
```

**Bad**:

```py
if position.x > width: position.x = 0

if flag: print("flagged")

The only exception to that rule is the ternary operator:

next_state = "idle" if is_on_floor() else "fall"
```

<!-- TOC --><a name="format-multiline-statements-for-readability"></a>
### Format multiline statements for readability[¶](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#format-multiline-statements-for-readability "Permalink to this headline")

When you have particularly long  `if`  statements or nested ternary expressions, wrapping them over multiple lines improves readability. Since continuation lines are still part of the same expression, 2 indent levels should be used instead of one.

GDScript allows wrapping statements using multiple lines using parentheses or backslashes. Parentheses are favored in this style guide since they make for easier refactoring. With backslashes, you have to ensure that the last line never contains a backslash at the end. With parentheses, you don't have to worry about the last line having a backslash at the end.

When wrapping a conditional expression over multiple lines, the  `and`/`or`  keywords should be placed at the beginning of the line continuation, not at the end of the previous line.

**Good**:

```py
var angle_degrees = 135
var quadrant = (
    "northeast" if angle_degrees <=  90
    else "southeast" if angle_degrees <= 180
    else "southwest" if angle_degrees <= 270
    else "northwest"
)

var position = Vector2(250, 350)
if (
    position.x > 200 and position.x < 400
    and position.y > 300 and position.y < 400
):
    pass
```

**Bad**:

```py
var angle_degrees = 135
var quadrant = "northeast" if angle_degrees <= 90 else  "southeast" if angle_degrees <= 180 else "southwest" if angle_degrees  <= 270 else "northwest"

var position = Vector2(250, 350)
if position.x > 200 and position.x < 400 and position.y > 300 and position.y < 400:
    pass
```

<!-- TOC --><a name="avoid-unnecessary-parentheses"></a>
### Avoid unnecessary parentheses[¶](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#avoid-unnecessary-parentheses "Permalink to this headline")

Avoid parentheses in expressions and conditional statements. Unless necessary for order of operations or wrapping over multiple lines, they only reduce readability.

**Good**:

```py
if  is_colliding():
    queue_free()
```

**Bad**:

```py
if  (is_colliding()):
    queue_free()
```

<!-- TOC --><a name="boolean-operators"></a>
### Boolean operators[¶](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#boolean-operators "Permalink to this headline")

Prefer the plain English versions of boolean operators, as they are the most accessible:

    -Use `and` instead of `&&`.
        
    -Use `or` instead of `||`.
        
    -Use `not` instead of `!`.
    
You may also use parentheses around boolean operators to clear any ambiguity. This can make long expressions easier to read.

**Good**:

```py
if (foo and bar) or not baz:
    print("condition is true")
```

**Bad**:

```py
if foo && bar || !baz:
    print("condition is true")
```

<!-- TOC --><a name="static-typing"></a>
## Static Typing

Enforce static typing for all variables and Nodes
**Good:**

```py
var health: int = 0
```

>Alternatively, godot also recommends infer type that auto assigns in compile time however for developer experience [autocomplete] use Strict Type

**Not Recommended**

```py
var health :int = 10
```

**Bad**

```py
var health = 0
```

<!-- TOC --><a name="scene-organization"></a>
## Scene Organization
>**Re-useable scenes/ui-component must be locked so the changes is not shown in version control system (Git) each time the scene file is opened within godot editor**

### Node Naming Convention
The node name should be in "PascalCase"
![alt text]([Node t](Scene_Node_Naming_Convention.png))


## Inter-Node Communication
The parent node should communicate to child node via function calls while child node should always communicate to parent node via Signal calls.

```
           _______ 
          |       |
          | Parent|<--------
          |_______|        |
              |            |
              ↓            |
        function call      |
              ↓            |
              |            |
              |            |
           ___↓___         |
          |       |        |
          | Child |        |
          |_______|        |
             ↓             |
             |   Signal    |
             |    emit     |
             |------------>|

```

<!-- TOC --><a name="return-types"></a>
## Return Types
Always ensure the return type is added to the function and the function ideally should always have only return type, i.e no nullable. In some case, this is required but minimize such practice.

```py
func get_match_player(p_uid: String) -> Player:
    for m_player in Match.players:
        if m_player.uid == p_uid:
            return m_player
    assert(false, "Match player with uid : [%s] not found" % [p_uid])
    return null
```
