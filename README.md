Welcome to Run For Your Life ! 
-----------------------------------------------------------------------------------------------------------------------------------

A tiny bit of backstory since it might help to understand why the level was made this way 
The level was designed by the lore of a creepy pasta series known as the Backrooms 
The level ! ( Also known as Run For Your Life ) you are droped into a long (10 miles) corridor 
And as the name says you have to start running since you are being followed my monsters  
This is a video for the Level ! https://www.youtube.com/watch?v=72bp0mvyA-w upon which the game is based 

-----------------------------------------------------------------------------------------------------------------------------------

About the game: 
Well since running for 10 min straight in a hallway dosent seem like the most gameplay and 
User experience orientated game, I decided to do some changes to the base concept but at the same time
Trying to keep the original idea 

Props/Objects have been placed along the path and your job is to run and avoid getting stuck in them: 
The objects vary from small wheels and buckets to racks and even moving walls (that will kill you if you touch them) 

-----------------------------------------------------------------------------------------------------------------------------------

Gameplay:
Controls: WASD to move, Space to jump, P to start playing in the main menu, M to come back to the main menu, and Esc to quit the game(Note ! it works in the build version of the game ) 
Since Running and avoiding objects again dosent feel like a lot of gameplay i decided to enhance the player feeling by adding Footsptes noises heavy breathing, and a monster that 
screams  and fallowes you.
But getting touched by a monster and dying seemed bland so i created what is known as a Jump Scare Scene which does exactly that, when the play is chought 
He gets jumpscared by the monster 
You objective is the same as in the lore of the level to run and to escape without getting chought 
The monsters is slightly slower than you but it never spanws far behind  you.

Youtube link to the video: https://www.youtube.com/watch?v=nqmofvNnhqM

-----------------------------------------------------------------------------------------------------------------------------------

Code explination:
BackToMainMenu.cs : As the name says after winning and wanting to try again this pice of code will send you back to the main menu 
Breathing.cs: Code wrote for checking player movment and playing the Heavy Breathing sound while the player runs.
CameraShake.cs [not working anymore]: It was ment to add the bobbing effect while running but i found out with the visual effects added it may cause nausea 
ExitGame.cs: Lets you leave the game (Only works on the build variant of the game, the actuall app/ .exe file not in the editor) 
ExitMenu.cs: Allowed you to chose between playing the game or quiting 
Footsteps.cs: The running footsteps played during the chase 
JumpScare.cs: The code that checks for a colision with the KillTrigger Box attached to the monster and changes the scene to the jumpscare one 
MonsApear.cs: This code sets the monster spawn which is triggerd in the begining after we start running
MonsterAttack.cs: Here we have the following script that the monster uses to chase the playet 
MovmentScript.cs: A simple movment script which adds a boolean value to check for movment and based on the answer it starts playing the Idle or Running animation 
ShowUI.cs: Close to the end of the lever a msg will spawned on the player screen with a last msg before escaping or dying 
SoundTrigger.cs: The chase music which is the actuall in lore chase music [Note: it might be a copyright issue ]
WallTriggerScript.cs: Not used it was ment to make the walls apear after they are getting triggerd but i found it useless since the animation tool could handle that 

-----------------------------------------------------------------------------------------------------------------------------------

Complexity:
I find that this game is more complex compared to the other projects that we had since it involves a lot more assets which 
are related to eachother. 
The sound trigger, monster spanwer trigger the player animations the sound and the enemy are ways on which the complexity of the level
is shown but more importantly it uses scences as as gameplay elements as in the Jumpscare scene which is made with animations and sound effects 
to try and scare the payer. 
The level is also hardend by the multitude of objects that are present and the dodge skill mechanic on the player part which is needed 

-----------------------------------------------------------------------------------------------------------------------------------

The game has 4 States:
Main Menu
Play State 
Jump Scare State (This is the lose state too ) 
Win State

-----------------------------------------------------------------------------------------------------------------------------------

Disclaimer: In the video i use a different playet model ( I had to change it cause it was over the git hub allowed size of 100MB) 
The Esc key works in the build version 
https://youtu.be/3eFDzRNkHeA This is the video of the Build verison of it with the Esc key working 


