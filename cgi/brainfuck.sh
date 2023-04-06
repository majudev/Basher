#! /bin/bash
# Brainfuck - Troy Deck
# https://gist.github.com/tdeck/58bd5c1f86a27b212811

#############
# Constants #
#############
CELLS=500

###########
# Globals #
###########
# The buffer holds the cells that form the program's working memory
buffer=()
# The stack holds the start pointer for each loop 
stack=()
# The address pointer, into the cell buffer
ap=0

# Fill the buffer with zeros
for i in {1..$CELLS}; do
    buffer+=(0)
done

# Read everything up to ! as source code
read -r -d '!' code
echo

###############
# Interpreter #
###############
for ((ip = 0; ip < ${#code}; ip++ )); do # ip is our instruction pointer
    op=${code:$ip:1}
    case "$op" in
        '[') 
            if [[ ${buffer[$ap]} == 0 ]]; then
                depth=1
                while [[ $depth > 0 ]]; do
                    ((ip++))
                    op=${code:$ip:1}
                    if [[ "$op" == '[' ]]; then
                        ((depth++))
                    elif [[ "$op" == ']' ]]; then
                        ((depth--))
                    fi
                done
            else
                stack+=($ip) 
            fi
            ;;
        ']') 
            if [[ ${buffer[$ap]} != 0 ]]; then
                ((ip = stack[${#stack[@]}-1]))
            else
                unset stack[${#stack[@]}-1]
            fi
            ;;

        '>') ((ap=(ap+1) % CELLS)) ;;
        '<') ((ap=(ap==0) ? CELLS-1 : ap-1)) ;;

        '+') ((buffer[ap]=(buffer[ap]+1) % 256)) ;;
        '-') ((buffer[ap]=(buffer[ap]==0) ? 255 : buffer[ap]-1)) ;;

        '.') printf "\x$(printf %x ${buffer[$ap]})" ;;
        ',') buffer[$ap]=$(printf "%d" "'$(read -n 1)") ;;
    esac
done
