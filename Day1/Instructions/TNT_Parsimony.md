% Linux, Alignment and Parsimony
% Jesus Martinez-Gomez
% `s c(current_date)`


This worksheet will walk you through some basic in Linux, aligning phylogenetic sequences with the program MAFT then inferring a phylogeny using the program "Tree analysis New Technology" (TNT).

# Basic of Linux

## Instillation


### Mac Instruction
1. Look for the Terminal.app using your finder. It should be in the following location Applications/Utilities/Terminal.app
2. Open it. 

### Windows instruction
For Window user we are going to install a Linux virtual machine. In essence this is a computer-in-computer. There are many benefits to installing Linux as many program are Unix basic. These instruction are for Windows 10 and they were taken from this (site)[https://www.bing.com/search?q=window+subsystem+for+linux&pc=MOZI&form=MOZLBR]
1.

## Basic Linux command

We will be inferring phylogenies using the program "Tree analysis New Technology" (TNT). This is a command line program, which means in order to run it you will use the "Terminal" app in Mac/ Linux or the "Command Prompt" app in Windows. It is developed in part by Kevin Nixon a Plant Biology faculty! ThThe following is a worksheet that you can follow to perform a basic parsimony analysis in TNT. 

# Download TNT
Installing and getting programs to work can be a challenge. Bioinformaticians can spend a great deal of time simply getting a program to run. Therefore These are general instructions and with the help of the instructors we will get the program running on your machine. 

1. Make a new folder somewhere on your computer, where you will keep all related data files.  
2. Download the DNA files I emailed you and move them into the folder.
3. Go to the following link to download the zip folder for TNT. [Link to TNT](http://www.lillo.org.ar/phylogeny/tnt/)
4. Unzip file 

# Mac User
5. Copy and paste the file "tnt.command" into the folder you made in step 1. 
6. Open the "Terminal" app search for using Finder
7. Drag and drop the "tnt.command" into the "Terminal" window
8. Congrats you did it!

### Windows User
5. Copy and paste the file "tnt.exe", into the folder you made in step 1. 
6. Open the command prompt, search for it using finder. 
7. Drag and drop the "tnt.exe" into command prompt
8. Congrats you did it!

## Introduction to TNT
As mentioned, TNT is a command line program meaning all inputs will be through the command line (you'll feel like a hacker). An alternative is to write script. A script is a simple text file that has all the instructions (aka commands) you want a program to run. We will not go through how to write a script, instead we will enter the commands one by one into the command line. This section will introduce you to some TNT basic and tips. 

First a brief note on syntax. Most TNT commands are a simple word or abbreviation, but in order to get the program to run them they must end with a semi-colon ";". So for example, try typing in the following command "help". You can simply copy and paste it into TNT. 

```python
help;
```

The "help" command above will give you all list of all the commands that TNT can run. Nifty. The "help" command can also be used to find information about other commands. For example we will be using the "mult" command later on in this workshop. To find out more information about "mult". Type the following. 
```pytbon
help mult;
```
If you are ever unsure about what a particular command does always use "help"


## TNT Analysis

### Setting Up TNT Analysis
We will now perform a basic parsimony inference. The first step is to specify settings in TNT. The "log" commands will generate a text file, (myLog.txt) that will keep track of all the subsequent commands you type and the output TNT produces. It is a good coding practice to keep log files, as they are a written history of the analysis you've done (future you will thank you).
```python
log myLog.txt;
```

Look at the folder, a new file called myLog.txt should be in there. You should be able to open this up by double clicking on it. It should be empty right now, but will fill up after we are done. The second step is to set the RAM memory usage. When TNT runs it takes up memory on your computer, the default setting for TNT memory usage is low. We'll set it to 200mb which is good for our tree size and no problem for a modern day computer. If you are analyzing a large tree, consider setting the memeory to something larger. 
```python
mxram 200;
```

The next step is to read in our data. Two important things to note:
1. Make sure your input file is in the correct format. TNT takes a special file a .tnt. Consult the TNT website for more detail on how to specify this file. 
2. Make sure your input file is in the same folder as the tnt.command (Mac) or tnt.exc (Windows)file. It should be if your followed "Download TNT" instructions above. 
```python
p accD_aligned.tnt;
```

TNT searches through tree space to find the most parsimonious tree or set of most parsimonious trees. TNT searches through many many trees most of which are not good (aka have a good parsimony score). Therefore we don't want to save every single tree, instead we will use the "hold" command to save the top 1000 trees. 
```python
hold 1000;
```

### Basic TNT Analysis 
We are ready to perform a basic parsimony tree search. We don't have time to explain what these do, but Kevin Nixon recommend these steps for good search. You may notice that instead of a single command there are four in the following line of code. T

```python
Mult; Rat; Drift; Sect;
```

This analysis may take a little while, and you will see some fun stuff pop up on your screen. Once its done you can view your most parsimonious phylogeny in your terminal window using the following code. 
```python
tp;
```

### Exporting and Quiting
Now the we have successfully completed an analysis we may want to export our best tree into a file for safe keeping. First we will use the command "taxname=", TNT changes our tip name during this analysis, "taxnames=" changes them back. Next we use the "export" command to generate a .nex file, which stand for Nexus. A Nexus file is a standard phylogenetic file. 
```python
taxname=;
export - myPhylogeny.nex;
```

Double check to see if a file called myPhylogeny.nex was created. Finally we can exit out of TNT using the "quit" command
```python
quit
```

Open the myLog.txt file again (if you already have it open, close it first), it should now be full of all the commands you inputed and the TNT output! Yay phylogenies! 

A final note. If you rerun the above code it will overwrite any files that exist on your computer. If you are running a different analysis make sure you change the names of the .log file and the .nex file 

## Viewing your Phylogeny
You should know have a .nex file in your folder. This .nex file contains the phylogeny you just infered and can be view in a tree viewer. There is a free Browser based tree viewer called (IcyTree)[https://icytree.org/]. Just drag and drop your .nex file into the browser


# References

