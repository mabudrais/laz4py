(only tested on win32 python 2.7)
this project is aiming to extend lazarus ide support for python .
Current state:
run python code from lazarus you can also set break point and step through code.
partial  (stctrls)  support.
How to install:
1- Copy the the the file pydbbr.pas to C:\lazarus\debugger\
2- add pydbbr to uses in debugmanager.pas
3- rebuid the ide
4- open the demo project 
5- go to menue->tools->option->debugger select "python debuger" in debugger type and path
6- add your breakpoint in the main.py 
7- press run.
8- put the the mouse over any  variable it's value should apears.


