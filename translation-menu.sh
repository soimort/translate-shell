#!/bin/bash
###################################################################
#Script Name	: translation-menu.sh
#Description	: Program for easy use of the translate-shell project
#Date         : 11/05/2016
#Author       : @soimort 
#Adaptation   : @matheusmazzola & @jeanrafaellourenco 
#Ref          : https://github.com/soimort/translate-shell
###################################################################

# To do: Improve validation to configure the translation project.
dependence=$(dpkg --get-selections | grep "gawk" )

if [ -n "$dependence" ] ;
then echo
echo -n "INITIATING PROGRAM..."
sleep 3
clear

else echo -n "CONFIGURING PROGRAMS..."
  sleep 3
  sudo apt-get update;
  sudo wget git.io/trans;
  sudo chmod +x trans;
  sudo mv trans /usr/bin/;
  sudo apt-get install gawk -y;
  clear
  echo -n "PRESS ANY KEY TO CONTINUE..."
  read
  sleep 3
  clear

fi


MenuT(){
echo "**********************************************"
echo "**              Translator                  **"
echo "**                                          **"
echo "** [1]-Translate from Portuguese to English **"
echo "** [2]-Translate from English to Portuguese **"
echo "** [3]-Identify a Word                      **"
echo "** [4]-Dictionary                           **"
echo "** [5]-Translate another language           **"
echo "** [6]-List of languages available          **"
echo "** [0]-exit                                 **"
echo "**********************************************"
echo "by: @soimort | Menu: @matheusmazzola & @jeanrafaellourenco."
echo
echo -n  "Choose an option: "

read optionT
case $optionT in
      1) Pt_en ;;
      2) En_pt ;;
	  3) Identify ;;
      4) Dictionary ;;
      5) Another ;;
	  6) List ;;
      0) clear;echo -n "LEAVING THE PROGRAM..."; sleep 3; exit ;;
      *) echo "Unknown option."; MenuT ;
   esac
}

Pt_en(){
clear
echo "Enter the text to be Translated: "
read text
clear
trans pt:en "$text"

read -p "Press any key to continue"
sleep 2
clear
        MenuT
}
En_pt(){
clear
echo "Enter the text to be Translated: "
read text
clear
trans en:pt "$text"

read -p "Press any key to continue"
sleep 2
clear
        MenuT
}
Identify(){
clear
echo "Enter the Word to be Identified: "
read word
clear
trans -id $word

read -p "Press any key to continue"
sleep 2
clear
        MenuT
}
Dictionary(){
clear
echo "Enter the word to be searched in the dictionary PT ou EN: "
read word
clear
trans -d $word

read -p "Press any key to continue"
sleep 2
clear
        MenuT
}
Another(){
clear

echo "Enter the acronym for Language to be Translated: "
read one
clear
echo "Type the acronym for the desired language: "
read two
clear
echo "Now Enter the text: "
read text
clear
trans $one:$two "$text"

read -p "Press any key to continue"
sleep 2
clear
        MenuT
}
List(){
clear

trans -R

read -p "Press any key to continue"
sleep 2
clear
        MenuT
}
MenuT
