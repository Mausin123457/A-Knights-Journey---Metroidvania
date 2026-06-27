Before starting, another beginner mistake I made, don't write your devlog in your README...


============================================================================

Devlog

============================================================================

CHAPTER 1: Before the project.

============================================================================


Before starting this project I already had experience with some different things that are important to making a game. I already have about 5 years of art experience, so pixel art and asset making is fun and doable to me and takes me less time then most other people. This alone is a huge advantage. Furthermore, since I am in school for IT I also have programming experience, which I hope will help me with making this project. I have never really made a game before though, so level design, gameplay mechanics etc. are still pretty new to me. So I am very excited to learn new things and take you guys with me in this process. I will be fully transparant with you guys, taking you with me through the mistakes, the things that went well and tips if you ever want to make your own game that helped me.

I have been wanting to make a game for a while now, probably about 3 years. Metroidvania's are so interesting to me and I LOVE them, since I started playing Hollow Knight, and recently also Nine Sols, I have wanted to create my own metroidvania. After stumbling onto an asset of a knight online on Itch.io, and having a few weeks off of school for the summer vacation, I got reinspired to just start working on this game. So that is how we got here!

Like I said below I will be updating you guys on my process, chapter 2 will be everything I have done up until the point of making this repo public and everything after that will be just based on feeling, if I feel like a new chapter is due, I will split it up.  

============================================================================

CHAPTER 2: Humble beginnings.

============================================================================

10-06-2026: I downloaded Godot, watched two tutorials and started with some simple character controls. I remembered watching a video a way back telling me to never start with making assets, so I made sure to just keep a rectangle with the classic purple and black as my player. In this fase I was already working with GIT, but I decided to keep my repo private for the beginning, since right now it didn't look like much yet. For the player I decided to opt for a state machine player, since I won't be having too many states and being a programmer this seemed like a way to keep my code nice and clean. I got the hang of GDscript pretty easily, since I already have experience in multiple languages including python, java and C#. Since GDscript is pretty close to python it was pretty easy to learn this language. After I created my state machine and I got decent movement that felt good to me to play with, I decided it was time for some assets.

I tried to create my own character as the player, but I just couldn't get anything decent down, then I remembered why I even started this project. I had seen an asset on Itch.io of a knight and immediately got inspired to finally start working on a game, which at that time was something I had always wanted to do. So, because I got stuck and kind of wanted to honour the asset that made me even start this project, I decided that I would use that asset as my player character. This asset almost led to my biggest mistake, and definetely led to my biggest struggle yet, which I will talk more about in the next chapter. 

After importing this asset and the sprite sheet, I started working on my own assets for the world, I made a basic sprite sheet for the forest environment and some extra props, which i will probably be updating, changing and adding to a quite a few times in the future. After I created these assets and started to play with these to create my first room for this forest environment, I thought, "This game is starting to shape a bit, i should probably make my repository public! WOW, that is such a good idea, I can keep everyone updated and maybe gain some popularity!" And this thought leads me to my next chapter...

============================================================================

CHAPTER 3: Distaster and struggles for such a simple thing

============================================================================

18-06-2026: Like I have already stated before, I have 1 singular asset that is not mine. Now this asset I am allowed to use for both commercial and non-commercial projects, BUT not allowed to redistribute. I had not thought of this before and even when I was planning of making my repo public, I never thought of this. I was lucky, or just stupid enough, that I asked copilot if making my repo public for a game was normal and a good thing to do. Copilot responded postively, but also luckily told me to be careful with third party assets and to never give people access to the original spritesheet. I immediately went back to my repo, to see that I never added the assets folder to .gitignore... So there it was, the full spritesheet just sitting there for everyone to grab it. I deleted the spritesheet from github. At the same time it also got deleted from my computer of course. I quickly deleted the player assets folder, created a new folder, added it to .gitignore, and went to my file explorerer to just grab the spritesheet back anddddd... It was gone... Of course it was, github deletes files completely, not just from your github page. So I had to search online again for the spritesheet, after looking for about 40 minutes I found it again, I grabbed the sprites, created a new spritesheet that was identical to the one before, which also took me about 15 minutes, and it was finally back in its place. I pushed my changes to github. I checked if I didnt accidentally add it again, but there it just was, staring at me, the spritesheet, yet again, mocking me. Before getting mad, I decided to just check the commit history and I found out that in the history, when I commited the spritesheet for the first time, it kept a copy. So anyone who went into the history could have found the spritesheet and just downloaded it.

19-06-2026: That was the point that I did get mad, mostly at myself. I had spent almost two hours on this, plus multiple days of hard work and commits with explanations of what I had done up until that point. But after cooling down, I decided to just make a new repository and start over. This time adding a dummy folder with an empty spritesheet for people to put their own sprites, I never leaked the spritesheet and everything was good. I went back to copilot to check if everything was good, but then he reccomended I create a License so that other people don't steal my stuff. So I also created a license and finally made the repo public.

So moral of the story, don't accidentally break a license and be very careful, small stupid mistakes can take away 2 hours of your life, for no good reason at all.

============================================================================

CHAPTER 4: Getting back into it

============================================================================

20-06-2026: After the whole hassle, I quickly got back to work on my creating a full level design for the game and a full map, where bosses will be, what regions I want, where abilities will be, etc. After creating this I immediately went to work on creating the layout for the two rooms. On my level design I have given all the rooms a number, starting at 0.1 and ending at 5.12 (since I have 5 regions). I decided to create these rooms so that I can work on room transitions and logic. I do want to add that I did not do any details yet, Just the simple layout of the ground and platforms, see the two pictures below to see that.

Room 1:
<img width="1206" height="766" alt="Screenshot 2026-06-20 143002" src="https://github.com/user-attachments/assets/85a73810-afd7-442d-81b6-6230e1ffbe6d" />



Room 2:
<img width="1266" height="821" alt="Screenshot 2026-06-20 142951" src="https://github.com/user-attachments/assets/05479eb8-419f-49f2-971c-181e12ce42b2" />


22-06-2026: This day I had another big blunder, my process is not very smooth, but that is to be expected in the beginning and shows how new I am to this and how this is all a learning process. I was working on level transitions and making those completely work, but I commited NOTHING in that entire process. When I was almost done and started fixing the little problems that were still left I started destroying everything on accident. (Mind you I was working around 11 PM at this time, I do not recommend this either...) So the bugs got bigger and bigger, and eventually it was so bad that I just had to put it out of its misery. This is when i realized I hadn't commited anything yet and that all of my progress for this entire day was just gone.
This was very frustrating and very demotivating, but I decided to just sleep and restart the next day.

24-06-2026: After a very long night and a nightmare about the previous day further, I tried again. I got the full level transition system back and this time I decided to commit my changes more often. Sure enough I got back to where I left off the previous day, with the exact same bug again. I commited yet again, actually fixed the bug this time and I felt so relieved. It was such a good feeling that I was even unable to continue, I just closed the project for the day and didn't touch it again.

25-06-2026: Today I just fixed some unwanted behaviour and some small bugs still left in the system. Not that much progress here.

26-06-2026: For this day I wanted to create a bit more visual appeal to my first rooms, so I added parallax layers, a background, a fog gradient, light streaks, a small light surrounding the player, an animated plant, animated torch and some trees and bushes. I will drop some screenshots from the game below, this is only the first room, but this is the style that I will be using throughout the entire first area, the forest.

Two in game screenshots of the first level (don't mind the state text above the player, this will obviously be gone in the actual game):

<img width="1445" height="791" alt="Screenshot 2026-06-27 114148" src="https://github.com/user-attachments/assets/a7143a2c-5a28-43f6-a0e0-f46c6a1a13d8" />

============================================================================


<img width="1407" height="796" alt="Screenshot 2026-06-27 114212" src="https://github.com/user-attachments/assets/514e022e-2da1-46ff-a56a-9d87003470ba" />


And this is a screenshot of the design for the second level, still in the editor:


<img width="492" height="355" alt="Screenshot 2026-06-27 114234" src="https://github.com/user-attachments/assets/e22f1db9-74f9-4b79-84d5-3c6dfb2763a5" />

============================================================================


