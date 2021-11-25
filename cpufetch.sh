#!/bin/bash
number=$(((RANDOM%250)))
number2=$(((RANDOM%250)))
number3=$(((RANDOM%250)))
number4=$(((RANDOM%250)))
number5=$(((RANDOM%250)))
number6=$(((RANDOM%250)))
number7=$(((RANDOM%250)))
/home/wax/.zsh/cpufetch/cpufetch --color ${number},${number2},45:${number7},${number3},200:0,0,0:100,${number4},45:0,${number6},${number5}
