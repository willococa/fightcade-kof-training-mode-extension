<a name="readme-top"></a>

<div align="center">

  <h3><b>FightCade Training Mode extension for KOF</b></h3>
<p> This is an extension for the fighcade Training Mode On the KoF Games, it is tested and
developed mainly for kof 98, but it should work in other KOF's until 2k2 (had a little test on this but don't take my word for it)
most KOF  have the same memory addresses  and functions on the original script <a href="https://github.com/peon2/fbneo-training-mode">fbneo-training-mode</a></p>
</div>

## Installation and Use
1) Copy the files guipages.lua , kof98.lua, tests_kof98.lua in the folder Fightcade\emulator\fbneo\fbneo-training-mode\games\kof98 or the
    equivalent folder on your FC installation
2) If you want to try it in other KOF version change the name of the files for their matching folders (kof98.lua to kof2002.lua)
    pay attention to the line:
    ```
    testsRun = false
    if testsRun then
        require('games.kof98.tests_kof98')	--here you may have to chage the name too though this code doesn't suposse to execute
    end
    ```
3) Now run the training mode and a new page in the Graphical Interfase should appear with the options of the captures below, please take into account that these are not perfect features and some bugs may occur, and also that you will have to tweak on reversals directly on code for frame perfect results (probably will add these options to GUI on a future version if worth the work)

4) Options:
    * toggle Guard on/off - It will guard crouching and it changes direction depending on p1 facing position (better than the regular option of just seting a direction to press the default raining option has), why not standing? guard? cuz is hard to make these feature without the character walking backwards and I was just trying to have something working, maybe will add this in the future
    * toggle Random Guard on/off this only works (or should) when the first one is also active, why? explained bellow, ideal to practice confirms
    * toggle reversal on/off this will activate the first reversal (or the only) you can see in the option Current Reversal Move, DPC is       default but you can change this on the moves (explanation bellow)
    * toggle reversal random on/off if this option is on it will triger the reversals in the option Current Reversal Move(s) randomly, ideal to prove Option Selects or situations where you want the dummy to do 2 things or more
    * Reversal move active settings - This will take you to a different page where you can activate or deactivate the reversal moves you want in the  Current Reversal Move(s) list
    * toggle recovery on/off - this will make it so in soft knockdowns the dummy will tech and stand up quickly (press AB), as knockdown times are different depending on the move you hit the character with and even the different characters you'll have to tweak this in the moves array (if you don't care about reversal timing i advice you to create a move and make it repeat several times as needed. more explanation about creating more moves bellow) NOTE: in order to have a reversal move be executed after a knockdown this option has to be on, and for now it won't work if the guard option is on (weird behaviour on these feature so I'll add it later), some moves trigger the (p2 airbound  and has been hit) flag so sometimes the reversal and the recovery loop this is a bug that I still have to fix
5) Moves:
    * Unfortunately, due to my limit knowledge of the scripts and lua programming this is all i have been able to develop, I, at the beggining wanted to work with the recording slots the framework already had, but i just couldn't make it work, and trying to learn from the original FC devs' I noticed that it seems they also have some trouble with it so i decided to just implement my own rudimentary moves behaviour. 
    + the moves are written in the file guipages lua in such manner: 
         ```
         --[[ REVERSAL MOVE ACTIVE SETTINGS  ]]

            moves = {
                ['DPC'] = {
                    ["sequence"] = {
                        { 'forward'},
                        { 'forward'},
                        {'_'},
                        {'_'},
                        {'down'},
                        {'down'},
                        {'down', 'forward','c'},
                        {'down', 'forward','c'},
                        {'c'},
                        {'c'},
                        {'c'}},
                        times = 5,
                        default = true
                },
                ['DPD'] = {
                    ["sequence"] = {
                        { 'forward'},
                        { 'forward'},
                        {'_'},
                        {'_'},
                        {'down'},
                        {'down'},
                        {'down', 'forward','d'},
                        {'down', 'forward','d'},
                        {'d'},
                        {'d'},
                        {'d'}},
                        times = 5,
                },
                ['DPA'] = {
                    ["sequence"] = {
                        {'_'},
                        {'_'},
                        { 'forward'},
                        { 'forward'},
                        {'_'},
                        {'_'},
                        {'down'},
                        {'down'},
                        {'down', 'forward','a'},
                        {'down', 'forward','a'},
                        {'a'},
                        {'a'},
                        {'a'}},
                        times = 13
                },
            ...
            ```
    as you see the name of the move is an uppercase index which contains inside a sequence, the secuence is an array of elements separated by {} and each one means the command the CPU should execute each frame one after the other, so when the DPC move is executed in its first frame the CPU will press { 'forward'}, and in the next { 'forward'}, later on it will even press various buttons in the same frame {'down', 'forward','c'}, the {'_'} just means to do nothing on that particular frame, this said please take the following advice in account:
        - repeat at least once each command you want to give to the CPU, it appears that the KOF engine need a button press to ocurr for at least two frames in order to count it as valid
        - use the button hold trick if you are pointing for frame perfect reversals, like when you see:
            ```
                {'down', 'forward','a'},
                {'down', 'forward','a'},
                {'a'},
                {'a'},
                {'a'}
            ```
        the a button in the end frames is there to tell the CPU that precise button is being hold for a longer time, these will simulate the effect of the "button hold trick" in KOF which buffer the last inputs and help you to triger that move in the next frame available to do so (so you'll get a reversal without needing to be perfect on the frame you would have needed to press the button)
    * the times option: this is the times you want the cpu to repeat the whole sequence, prety valid when you want to just mash a button, not so good if you want to mash a special move as depending when the dummy comes out of blockstun or recovery it might trigger a different chunk sequence and do something different
    * the empty frames {'_'}: this is why sometimes I rather use a delay or empty frame (no button is pressed) if i want to practice a setup that needs to be frame perfect, IMPORTANT NOTE!!! On this matter I think I should advice to change the empty frames of the AB move in the list has if you want to practice for another knockdown (i have it set for ioris wakeup dp after a jumping CD)
6) Comments and Questions:
    * Why are this options separated (guard and random guard) and dependant on each other still?: Like I said this was just a personal project and I went feature after feature while I was on the march and I needed something, these will probably be improved later if I decide is worth the trouble but my first goal was not to be user friendly but to make it work
    * why do I have to go to the code to tweak the moves and can't directly from the GUI ? priorities, it was better to develop some central little features than to embellish the ones already working, if needed I will make this easier in the future but right now is not as if it is nuclear science, just give it a try and you'lll understand fast how it works and I honestly believe is useful enough to practice anything one could desire. I just don't even know if someone will find this usefull at all for me to put more effort than what I need to acomplish my own labbing requirements
    * will X feature be developed in the future? I don't know, the code is open as the FBNeo and Fightcade license ask it, so anyone can add to it, I will do so if I really see my time is worth for now I hope at least one person finds it useful and that person is obviously me XD, if more people really seem to like it I will add more things for the game. 
## Captures

<img src="c1.PNG"/>
<br/>
<img src="c2.PNG"/>
<br/>
<!-- ACKNOWLEDGEMENTS -->

## 🙏 Acknowledgments

> 

I would like to thank the FightCade Devs for their fabulous work and all the other developers and technologies tha are involved or used in the project, this is just a little extension of their work
Also expecifically to the <a href="https://github.com/peon2/fbneo-training-mode">Fbneo Training Mode</a>

<p align="right">(<a href="#readme-top">back to top</a>)</p>
<!-- LICENSE -->

## 📝 License <a name="license"></a>

This project is [BSD 2-Clause License](./LICENSE) licensed. I think this is the license this script should inherit, but i honestly don't know how this expecific license work, just please note that this work is not based in my original code and is just an extension on the work of others, feel free to extend it too and share it with the community, don't sell it.
<p align="right">(<a href="#readme-top">back to top</a>)</p>