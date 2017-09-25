#!/bin/bash
source pics.sh

validChars="A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"

function game {
    letters=($1)
    guess=($2)
    wrong=($3)

    # echo "arguments: letters=(${letters[*]}) guess=(${guess[*]}) wrong=(${wrong[*]})"

    wrongCount=${#wrong[@]}
    echo wrongCount=$wrongCount
    clear

    # Continue the game if the player hasn't lost
    if [ $wrongCount -lt $picsCount ]; then
        echo "${pics[wrongCount]}"
        echo "${guess[*]}    ${wrong[*]}"

        # The player has filled the entire word. Finish the game.
        if [ "${letters[*]}" = "${guess[*]}" ]; then
            echo "You win!"
            return;
        fi

        # Read a single character from the keyboard.
        read -n 1 -s char

        # Make that character UPPERCASE
        char=$(echo $char | tr /a-z/ /A-Z/)

        # Check that the character is a letter
        if [[ "$validChars" != *$char* ]]; then
            # echo "Invalid character"
            game "${letters[*]}" "${guess[*]}" "${wrong[*]}"

        # Check that the player hasn't guessed that letter
        elif [[ "${wrong[*]} ${guess[*]}" == *$char* ]]; then
            # echo "You already guessed that character."
            game "${letters[*]}" "${guess[*]}" "${wrong[*]}"

        # Check if it is a correct letter
        elif [[ "${letters[*]}" == *$char* ]]; then
            # echo "You guessed a letter in the word!"

            # Fill in the guess with the correct letters
            i=0
            while [ $i -lt ${#letters[@]} ]; do
                if [ ${letters[i]} = $char ]; then
                    guess[$i]=$char
                fi
                i=$(( $i + 1 ))
            done
            game "${letters[*]}" "${guess[*]}" "${wrong[*]}"
        else
            # echo "You guessed an incorrect letter. Try again!"
            game "${letters[*]}" "${guess[*]}" "${wrong[*]} $char"
        fi
    else
        echo "$gameOver"
        echo "${guess[*]}    ${wrong[*]}"
        echo "The word was ${letters[*]}"
    fi
}

function clearGuess {
    while [ "$1" != "" ]; do
        echo -n "_ "
        shift
    done
    echo
}

function main {
    # Select a random word from words.lst
    words=(`cat words.lst`)
    word=${words[$RANDOM % ${#words[@]} ]}

    # Convert the word in to H A N G M A N format
    if [ "$word" = "" ]; then return; fi
    letters=($(echo $word | tr /a-z/ /A-Z/ | fold -w 1))

    # Initialize the guess as _ _ _ _ _ _ _
    guess=($(clearGuess ${letters[*]}))

    # Begin the game
    game "${letters[*]}" "${guess[*]}" ""
}
main
