# Teslatech Game Dev Training Program 2024

Documentation of Teslatech Game Dev Training Program 2024.

# Table of Contents

| S.N. | Topic |
|------|-------|
| 1. |  [Godot Tasks](#1-godot-tasks)  |
| 2. |  [Type Racing](#2-type-racing)  |
| 3. |  [Project Euler](#3-project-euler)  |

***
***

# 1. Godot Tasks

> *Each of you will make a new branch for each Godot task/project with the naming convention 'task-name/first-name'. E.g. : first-2d-game/rojan*

> *Progress of each day is to be pushed into Git.*

Tasks involving the use of Godot Engine will be provided by the mentor to engage you in using and learning the Godot Engine and GDScript. You are to strictly complete the given task in given time. Failure to do so will lead to negative marking. The deadline for each task will be given in the Document itself which also consists of the detailed objectives of the task.

### **Some Rules**:

* In case of absence due to sickness or emergency, you will be given an additional days deadline to submit your work. This does not mean you will be given extra time on the day. You are to commit from your own extra free time to complete the given task to meet the next deadline. If you are absent for 1 day, you will be given 2 days (1 absent day + 1) deadline extension. If you are absent for consecutive 2 days, 3 days (2 absent days + 1) deadline extension and vice versa.

* The mentor has the right to either postpone or bring forward the deadline for given task whenever he/she sees fit.  

The provided Godot tasks are to be done in Godot v3.5.3.

> Firstly, if you haven't done it yet, go to the official [Godot website](https://godotengine.org) and download the required version of the engine and install it.

> Godot is a completely free and open-source game engine. No strings attached, no royalties nothing. Your game is yours, down to the last line of engine code.


# 2. Type Racing

> *Requirements :*
> * *WPM (Words per minute) : 65*
> * *Accuracy : 98%*
> * *The average data of the last 5 races will be taken for evaluation.*

The evaluation will be carried out by the mentor.

### **Some Rules:**

* Your evaluation for typing will be done strictly in TypeRacer only.

* If you have met the above requirements during the intership program, then you can request the mentor to validate it. If validated by the mentor, you are allowed to commit the time of Type Racing elsewhere (like Project Euler or Godot).

Typing can be an under-focused aspect. However, it is crucial for a programmer to maintain an above average consistency in typing accuracy and speed. Therefore, this section is focused to help targeted developers improve the accuracy and the speed of typing characters.

[TypeRacer](https://play.typeracer.com/) is a versatile website packed with a plethora of features targeted for typing. It enables users to either play a type race with their own colleagues or random users on the internet or practice themselves non-competitively. It is also beneficial to create an account on the website so that users can track and monitor their progress throughout various practice sessions.

**Regardless of the Websites chosen, it is highly recommended to maintain the standard finger pattern**

![](https://www.ratatype.com/static/i/learn/keyboard/it/keyboard.webp)


# 3. Project Euler

> *Progress of each day should be pushed into Git everyday before leaving.*

All the problems are to be done in GDScript itself to familiarize you with the language.

Project Euler is a series of challenging mathematical/computer programming problems that will require more than just mathematical insights to solve. Although mathematics will help you arrive at elegant and efficient methods, the use of a computer and programming skills will be required to solve most problems.

### Setting up Godot

We will be solving the project eular problems using the gdscript so we should install godot first.

### Creating Alias

Creating alias helps to launch application quicker and more accessible through terminal and since, we are depended on Visual Studio Code and terminal to run the script, we need to make **godot** alias that points to the actual executable binary we downloaded.

> **Alias** Snippet:
`alias godot="/Applications/Godot.app/Contents/MacOS/Godot"`
>

After executing above command in the terminal we can launch godot window by typing ***godot*** in the terminal.

**However** the changes only last for a terminal session and no longer works after shutdown/logoff etc.

So to make persistant alias we add the code snippet in the terminal profile.

And since we are using the **ZSH** terminal we add the snippet in `~/.zshrc`.

**Instruction**

1. `cd ~` -> `vi .zshrc`
2. After launching vim move to Insert mode by typing key **`i`**
3. Type **alias godot="/Applications/Godot.app/Contents/MacOS/Godot"**
4. Save and quit by:`Esc` -> `:wq` -> `Enter`
5. To take the changes execute `source ~/.zshrc` in terminal.

## Setting up Editor

For IDE we are using Visual Studio Code **[Download VSCode](https://code.visualstudio.com/)**. After Installing we are going to need a couple of extension to make before getting started with the problems. The extension can be added by navigating through the left sidebar of the application.

Then, search and install **gdscript**, **GDScript Formatter** and **godot-tools** extension.

## Setting up project directory

Create a new branch in the **interns-2024** directory after **cloning** the interns repo with the convention 'euler/first-name'.

> **/Users/[username]/projects/teslatech/interns-2024**

Using a common directory structure is encouraged so for all projects create inside of **/Users/[username]/projects/**

It is best to use Version Control system since we are going to need to make changes in the script for optimization process. Therefore, Initialize **git** in eular-project and set remote upstream url pointing to remote repository url.

> Refer to **Git** for more info

### Godot script Template

``` py

extends SceneTree

func _init():
    var start_time = Time.get_unix_time_from_system()
    var ans = main(1000, 1)
    var duration = Time.get_unix_time_from_system() - start_time
    print("Answer: %s, Duration: %.5f" % [ans, duration])
    quit()


func main(p_a: int, p_b: int) -> int:
    return get_sum(p_a, p_b)


func get_sum(p_a: int, p_b: int) -> int:
    return p_a + p_b

```

You can now run the script by using **godot -s [filepath]** in terminal.
