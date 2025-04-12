#!/usr/bin/env bash
#deshuffle is a terminal game in Bash written by Christos Angelopoulos under GPLv2, March 2025

function load_colors() {
  C0="\0033[38;5;242m" #Grid  Color
  C1="\0033[31m"       # Red
  C2="\0033[32m"       # Green
  C3="\0033[33m"       # Yellow
  C4="\0033[34m"       # Blue
  C5="\0033[35m"       # Magenta
  C6="\0033[36m"       # Cyan
  C7="\0033[37m"       # White
  C8="\0033[47m"       # Cursor Background Color
  C9="\0033[38;5;232m" # Black
  I="\0033[7m"         #invert
  J="\0033[5m"         #blink
  b="\0033[1m"         #bold
  n="\0033[m"          #reset
}

function load_config() {
  [[ -z "$CONFIG_FILE" ]] || source "$CONFIG_FILE"
  #DEFAULT VALUES in case config not loaded
  [[ -z $PREFERRED_EDITOR ]] && PREFERRED_EDITOR=${EDITOR-nano}
  [[ -z $LEGEND_TOGGLE ]] && LEGEND_TOGGLE=yes
  echo "$LEGEND_TOGGLE" >/tmp/deshuffle_LEGEND_TOGGLE.txt
  [[ -z $DEFINITION_TOGGLE ]] && DEFINITION_TOGGLE=yes
  [[ -z $DIFFICULTY ]] && DIFFICULTY=easy
  [[ -z $TIMER_TOGGLE ]] && TIMER_TOGGLE=on
  [[ -z $TIME_LIMIT ]] && TIME_LIMIT=15
  [[ -z $LEVEL_UP ]] && LEVEL_UP=5

  [[ $TIME_LIMIT -lt 1 ]] && TIME_LIMIT=1
  [[ $TIME_LIMIT -gt 30 ]] && TIME_LIMIT=15
  [[ $LEVEL_UP -lt 0 ]] && LEVEL_UP=1
  [[ $LEVEL_UP -gt 30 ]] && LEVEL_UP=5
}

get_hiscore_grep_string() {
  if [[ "$TIMER_TOGGLE" == "on" ]]; then
    HISCORE_GREP_STRING="DIFFICULTY:$DIFFICULTY TIMER:$TIMER_TOGGLE TIME LIMIT: $TIME_LIMIT LEVEL UP: $LEVEL_UP"
  else
    HISCORE_GREP_STRING="DIFFICULTY:$DIFFICULTY TIMER:$TIMER_TOGGLE"
  fi
}

function any_key {

  echo -e "${C0}Press any key to $1"
  read -sn 1 ccc
  clear
}

function show_rules() {
  clear
  echo -e "${C3}DESHUFFLE
-The simple aim of the game is to put all the given letters in order 
to find the shuffled word. There is not only one solution to every 
puzzle. If the user find a word with the same letters, 
the solution will be accepted.
-The game ends when the user fails to find the word in time, or fails 
to create an acceptable word altogether.
-If the score is among the 10 best scores achieved, it makes it in the 
Top Ten Scores.

-By default, the game is configured to be played against the clock, 
but the timer can be toggled off, as well.
-The time available after a number of found words also reduces, so 
the game gets harder as it goes. This reducing is also configurable.
-The level of difficulty, as far as word length is concerned, can be 
also confugured: easy (4 letter words), medium (4 letter and 5 letter 
words in turns), hard (5 letter words).
-The user can also toggle the appearence of the word definitions, and 
the appearance of the game info.
DISCLAIMER
-The 4 and 5 letter word list were created by parsing 
 /usr/share/dict/words
-The sources of the adjusted word definitions are :
 https://dictionaryapi.dev/ API
 https://www.wordnik.com/words/
 Therefore there is no liability as far as these words, definitions, and use are concerened."
}

function show_hiscores() {
  echo -e "${C1}${b}T O P   T E N${n}"
  echo -e "${C2}DIFFICULTY:\t$DIFFICULTY"
  echo -e "${C2}TIMER:\t\t$TIMER_TOGGLE"
  [[ "$TIMER_TOGGLE" == "on" ]] && echo -e "TIME LIMIT:\t$TIME_LIMIT \nLEVEL UP:\t$LEVEL_UP"
  get_hiscore_grep_string
  if [[ -n $(grep "$HISCORE_GREP_STRING" "$SHARE_DIR/hiscores.txt") ]]; then
    TOP_10_LENGTH=$(grep -c "$HISCORE_GREP_STRING" "$SHARE_DIR/hiscores.txt")
    if [[ $TOP_10_LENGTH -gt 10 ]]; then TOP_10_LENGTH=10; fi
    ii=1
    i=1
    echo -e "${C0}╭───────────────────────────────────────╮"
    echo -e "${C0}│no     Words   Date       Time         │"
    echo -e "${C0}├───────────────────────────────────────┤"
    while [[ $i -le $TOP_10_LENGTH ]]; do
      [[ "$(grep "$HISCORE_GREP_STRING" "$SHARE_DIR/hiscores.txt" | sort -rn | cat -n | sed -n ${i}p | awk '{print $3,$4}')" == "$WIN_TIME" ]] && h="${I}" || h=""
      echo -e "${C0}│${h}\0033[3${ii}m""$(grep "$HISCORE_GREP_STRING" "$SHARE_DIR/hiscores.txt" | sort -rn | cat -n | sed -n ${i}p | sed 's/@.*//;s/^ *//')""${n}${C0}│"
      [[ $i -lt $TOP_10_LENGTH ]] && echo -e "├───────────────────────────────────────┤"
      sleep 0.2
      ((i++))
      ((ii++))
      [[ $ii -gt 7 ]] && ii=1
    done
    echo -e "╰───────────────────────────────────────╯"
  else
    echo -e "${C0}No statistics available just yet.${n}"
  fi
}

function install_readsn1() {
  echo -e "#!/usr/bin/env bash
echo \$\$>/tmp/deshuffle_read_PID.txt
read -sn 1 x
echo \$x" >/tmp/readsn1.sh
  chmod +x /tmp/readsn1.sh
}

function print_word() {
  local W=("${@//_/ }")
  WORD_PRINT0=""
  WORD_PRINT1=""
  WORD_PRINT2=""
  for ((i = 2; i < $((WORD_LENGTH + 2)); i++)); do
    WORD_PRINT0="$WORD_PRINT0$1╭───╮"
    WORD_PRINT1="$WORD_PRINT1$1│ $2${W[i]^^} $1│"
    WORD_PRINT2="$WORD_PRINT2$1╰───╯"
  done
  PAD_L=$((35 - WORD_LENGTH * 5 - 1))
  echo -e "│ $WORD_PRINT0${PAD:0:PAD_L}${C0}│"
  echo -e "│ $WORD_PRINT1${PAD:0:PAD_L}${C0}│"
  echo -e "│ $WORD_PRINT2${PAD:0:PAD_L}${C0}│"
}

function print_time() {
  CURRENT_TIME_STR="$CURRENT_TIME""  "
  CURRENT_TIME_STR="${CURRENT_TIME_STR:0:2}"
  TIMER_STR="$CURRENT_TIME_STR ${C2}"
  for ((i = 0; i < $CURRENT_TIME; i++)); do
    TIMER_STR="$TIMER_STR""━"
  done
  TIMER_STR="$TIMER_STR""$PAD"
  #TIMER_STR="${TIMER_STR:0:35}"
  echo -e "│ ${C6}${TIMER_STR:0:43}""${C0}│\n├───────────────────────────────────┤"
}

play_legend() {
  echo -en "├───────────────────────────────────┤\n│ ${C3}a-z${n}              ${C6}   Put In Letter ${C0}│\n│ ${C3}Enter              ${C6}   Accept Word ${C0}│\n├───────────────────────────────────┤\n│ ${C3}Backspace ${n}       ${C6}   Delete Letter${C0} │\n│ ${C3}Delete              ${C6}   Abort Word ${C0}│\n│ ${C3}I                    ${C6} Toggle Info ${C0}│\n│ ${C3}M                    ${C6}   Main Menu ${C0}│\n│ ${C3}Q                    ${C1}   Quit Game${C0} │\n├─────────┬───────────┬─────────────┤\n│${C5}${COMMENT0:0:83}${C0}│\n╰─────────┴───────────┴─────────────╯\n${n}"
}

function print_box() {
  echo -e "${C0}╭───────────────────────────────────╮"
  [[ "$TIMER_TOGGLE" == "on" ]] && print_time
  print_word "${C0}" "${C3}" "${WORD2[@]}"
  print_word "${C0}" "${C6}" "${WORD1[@]}"
  [[ $LEGEND_TOGGLE == yes ]] && play_legend || echo -e "╰───────────────────────────────────╯\n${C0} Hit I to show info"

}

function blank_word() {
  unset WORD1
  unset WORD2
  for ((i = 0; i < $WORD_LENGTH; i++)); do
    WORD1[i]="_"
    WORD2[i]="_"
  done
}

function timer() {

  echo -ne "\0033[H" #clear
  while [[ $CURRENT_TIME -gt 0 ]]; do
    clear
    source "/tmp/deshuffle_word2.txt"
    LEGEND_TOGGLE="$(cat /tmp/deshuffle_LEGEND_TOGGLE.txt)"
    kill "$(jobs -l | grep 'print_box' | awk '{print $2}')" >/dev/null 2>&1
    clear
    print_box &
    sleep 1
    ((CURRENT_TIME--))
    echo $CURRENT_TIME >/tmp/deshuffle_current_time.txt
  done
  kill "$(jobs -l | grep 'print_box' | awk '{print $2}')" >/dev/null 2>&1
  clear
  print_box &
  kill "$(cat /tmp/deshuffle_read_PID.txt)"
}

function new_word() {
  unset WORD0
  >/tmp/deshuffle_word2.txt
  case $DIFFICULTY in
  easy)
    WORD_DATABASE="$CONFIG_DIR/4l_word_database.psv"
    WORD_LENGTH=4
    ;;
  medium)
    if [[ $ALTER_DB -eq 0 ]]; then
      WORD_DATABASE="$CONFIG_DIR/4l_word_database.psv"
      WORD_LENGTH=4
      ALTER_DB=1
    else
      WORD_DATABASE="$CONFIG_DIR/5l_word_database.psv"
      WORD_LENGTH=5
      ALTER_DB=0
    fi
    ;;
  hard)
    WORD_DATABASE="$CONFIG_DIR/5l_word_database.psv"
    WORD_LENGTH=5
    ;;
  esac
  DB_WC_L="$(cat "$WORD_DATABASE" | wc -l)"
  WORD_INDEX=$((1 + RANDOM % DB_WC_L))
  #WORD_INDEX=1724
  WORD="$(sed -n "${WORD_INDEX}p" $WORD_DATABASE | sed 's/#.*//')"
  [[ "$DEFINITION_TOGGLE" == "yes" ]] && DEFINITIONS="$(sed -n "${WORD_INDEX}p" $WORD_DATABASE | sed 's/.*#/-/;s/|/\\n\\n-/g')"
  for ((i = 0; i < $WORD_LENGTH; i++)); do
    WORD0[i]=${WORD:i:1}
  done
  blank_word
  while [[ ${WORD0[@]} == ${WORD1[@]} ]] || [[ ${WORD1[@]} == *"_"* ]]; do
    blank_word
    for ((i = 0; i < $WORD_LENGTH; i++)); do
      L0=${WORD0[i]}
      x=$((RANDOM % WORD_LENGTH))
      while [[ ${WORD1[x]} != "_" ]]; do
        x=$((RANDOM % WORD_LENGTH))
      done
      WORD1[x]=$L0
    done
  done
  TIME_STRING=" timer off "
  COMMENT0=" $WORD_LENGTH chars ${C0}│${C5}${TIME_STRING:0:11}${C0}│${C2} SCORE: $SCORE ${PAD}"
  if [[ $TIMER_TOGGLE == "on" ]]; then
    [[ $LEVEL_UP != 0 ]] && START_TIME=$((TIME_LIMIT - SCORE / LEVEL_UP)) || START_TIME=$TIME_LIMIT
    [[ $START_TIME -lt 1 ]] && START_TIME=1
    CURRENT_TIME=$START_TIME
    echo $CURRENT_TIME >/tmp/deshuffle_current_time.txt
    TIME_STRING="   $START_TIME sec               "
    COMMENT0=" $WORD_LENGTH chars ${C0}│${C5}${TIME_STRING:0:11}${C0}│${C2} SCORE: $SCORE ${PAD}"
    timer &
  fi
  play_menu
}

function new_game() {
  WIN_TIME=""
  SCORE=0
  [[ "$DIFFICULTY" == "medium" ]] && ALTER_DB=0
  new_word
}

function end_round() {

  #COMMENT0="SCORE: $SCORE""$PAD"
  echo -e "${C0}╭───────────────────────────────────╮\n│ ${C1}${COMMENT1:0:33}${C0} │\n├───────────────────────────────────┤"
  print_word "${C2}" "${C2}" "${WORD0[@]}"
  echo -e "├───────────────────────────────────┤"
  if [[ "$DEFINITION_TOGGLE" == "yes" ]]; then
    DEFINITIONS="$(echo -e "$DEFINITIONS" | fold -s -w 35 | sed 's/^/│\\0033[36m/g;s/$/                                    /g' | cut -c 1-47 | sed 's/$/\\0033[38;5;242m│/g')"
    echo -e "$DEFINITIONS\n├─────────┬───────────┬─────────────┤"
  fi
  echo -e "│${C5}${COMMENT0:0:83}${C0}│\n╰─────────┴───────────┴─────────────╯"

}

function end_game() {
  WIN_TIME="$(date +%Y-%m-%d\ %T)"
  COMMENT1="MISSED THE WORD!$PAD"
  clear
  db2=Q
  end_round
  get_hiscore_grep_string
  if [[ $(grep -c "$HISCORE_GREP_STRING" "$SHARE_DIR/hiscores.txt") -lt 1 ]]; then
    TENTH="$((SCORE + 100))" #avoid first time error
  else
    TENTH="$(sort -rn "$SHARE_DIR/hiscores.txt" | grep "$HISCORE_GREP_STRING" | head -10 | tail -1 | awk '{print $1}')"
  fi
  if [ "$SCORE" -gt "$TENTH" ] || [[ "$(grep -c "$HISCORE_GREP_STRING" "$SHARE_DIR/hiscores.txt")" -lt 10 ]]; then
    any_key "continue"
    echo -e "$SCORE\t$WIN_TIME\t@$HISCORE_GREP_STRING" >>"$SHARE_DIR/hiscores.txt"
    echo -e "${C1}That's right, you made it to the${n}\n"
    show_hiscores
  fi
  any_key "return to main menu"
}

function check_word() {
  WORD0_SORTED="$(echo -e ${WORD0[@]} | sed 's/ /\\n/g')"
  WORD2_SORTED="$(echo -e ${WORD2[@]} | sed 's/ /\\n/g')"
  if [[ "$(echo -e $WORD0_SORTED | sort)" == "$(echo -e $WORD2_SORTED | sort)" ]]; then
    WORD2_STR="$(echo "${WORD2[@]}" | sed 's/ //g')"
    if [[ "$WORD2_STR" == "$WORD" ]]; then
      clear
      ((SCORE++))
      COMMENT1="SUCCESS!$PAD"
      COMMENT0=" $WORD_LENGTH chars ${C0}│${C5}${TIME_STRING:0:11}${C0}│${C2} SCORE: $SCORE ${PAD}"
      end_round
      any_key "continue"
      db2=Q
      new_word
    else
      GREP_STRING="^""$WORD2_STR"
      WORD3_STR="$(grep -E "$GREP_STRING" $WORD_DATABASE | sed 's/#.*//')"
      if [[ -n $WORD3_STR ]]; then
        for ((i = 0; i < $WORD_LENGTH; i++)); do
          WORD0[i]="${WORD3_STR:i:1}"
        done
        clear
        [[ "$DEFINITION_TOGGLE" == "yes" ]] && DEFINITIONS="$(grep -E "$GREP_STRING" $WORD_DATABASE | sed 's/.*#/-/;s/|/\\n\\n-/g')"
        ((SCORE++))
        COMMENT1="WORD ACCEPTED! (going for ${WORD^^})$PAD"
        COMMENT0=" $WORD_LENGTH chars ${C0}│${C5}${TIME_STRING:0:11}${C0}│${C2} SCORE: $SCORE ${PAD}"
        end_round
        any_key "continue"
        db2=Q
        new_word
      else
        end_game
        clear
      fi
    fi
  else
    end_game
  fi
}

function play_menu() {
  #for l in  "${C0}""R" "e" "a" "d" "y" "?";do echo -ne "$l";sleep 0.1;done
  sleep 0.1

  db2=""
  while [[ $db2 != "Q" ]]; do
    CURRENT_TIME="$(cat /tmp/deshuffle_current_time.txt)"
    kill "$(jobs -l | grep 'print_box' | awk '{print $2}')" >/dev/null 2>&1
    clear
    print_box
    db2="$(/tmp/readsn1.sh)"
    if [[ $(echo "$db2" | od) == "$backspace" ]]; then for ((i = $((WORD_LENGTH - 1)); i > -1; i--)); do if [[ ${WORD2[i]} != "_" ]]; then
      WORD2[i]="_"
      echo "WORD2=(${WORD2[@]})" >/tmp/deshuffle_word2.txt
      break
    fi; done; fi
    if [[ $(echo "$db2" | od) == "$delete" ]]; then
      for ((i = 0; i < $WORD_LENGTH; i++)); do WORD2[i]="_"; done
      echo "WORD2=(${WORD2[@]})" >/tmp/deshuffle_word2.txt
    fi
    case $db2 in
    "Q")
      kill "$(jobs -l | grep 'timer' | awk '{print $2}')" >/dev/null 2>&1
      clear
      exit
      ;;
    "M")
      kill "$(jobs -l | grep 'timer' | awk '{print $2}')" >/dev/null 2>&1
      clear
      db2=Q
      ;;
    [a-z])
      clear
      for ((i = 0; i < $WORD_LENGTH; i++)); do if [[ ${WORD2[i]} == "_" ]]; then
        WORD2[i]="$db2"
        echo "WORD2=(${WORD2[@]})" >/tmp/deshuffle_word2.txt
        break
      fi; done
      ;;
    "I")
      clear
      if [[ $LEGEND_TOGGLE == no ]]; then LEGEND_TOGGLE=yes; else LEGEND_TOGGLE=no; fi
      echo "$LEGEND_TOGGLE" >/tmp/deshuffle_LEGEND_TOGGLE.txt
      ;;
    "")
      kill "$(jobs -l | grep 'timer' | awk '{print $2}')" >/dev/null 2>&1
      check_word
      ;;
    *) clear ;;
    esac
  done
}

function cursor_reappear() {
  echo -e "\0033[?25h"
  exit
}

function main_menu() {
  clear
  mm=""
  while [[ "$mm" != "q" ]]; do
    echo -e "${C0}╭────────────────────────╮"
    echo -e "${C0}│   ${C1}${b}D E S H U F F L E${n} ${C0}   │"
    echo -e "${C0}├────────────────────────┤"
    echo -e "${C0}│${C5}${b} n             ${n}${C6}New Game ${C0}│"
    echo -e "${C0}├────────────────────────┤"
    echo -e "${C0}│${C5}${b} c            ${n}${C6}Configure ${C0}│"
    echo -e "${C0}├────────────────────────┤"
    echo -e "${C0}│${C5}${b} r            ${n}${C6}    Rules ${C0}│"
    echo -e "${C0}├────────────────────────┤"
    echo -e "${C0}│${C5}${b} h           ${n}${C6}Highscores ${C0}│"
    echo -e "${C0}├────────────────────────┤"
    echo -e "${C0}│${C5}${b} q                 ${n}${C6}Quit ${C0}│"
    echo -e "${C0}╰────────────────────────╯${n}"
    read -sn 1 mm
    case $mm in
    n)
      clear
      new_game
      ;;
    c)
      clear
      eval $PREFERRED_EDITOR $CONFIG_FILE
      echo -e "\0033[?25l"
      load_config
      ;;
    r)
      clear
      show_rules
      any_key "return to main menu"
      ;;
    h)
      clear
      show_hiscores
      any_key "return to main menu"
      ;;
    q)
      clear
      ;;
    *) clear ;;
    esac
  done
}

########################################
trap cursor_reappear HUP INT QUIT TERM EXIT ABRT
echo -e "\0033[?25l" # make cursor invisible
spacebar=$(
  cat <<eof
0000000 000012
0000001
eof
)
#detect BACKSPACE, solution found https://stackoverflow.com/questions/4196161/bash-read-backspace-button-behavior-problem
backspace=$(
  cat <<eof
0000000 005177
0000002
eof
)
delete=$(
  cat <<eof
0000000 005033
0000002
eof
)
CONFIG_FILE="$HOME/.config/deshuffle/deshuffle.config"
SHARE_DIR="$HOME/.local/share/deshuffle"
CONFIG_DIR="$HOME/.config/deshuffle"
PAD="                                      "
export -f play_menu
############## GAME ####################
install_readsn1
load_colors
load_config
main_menu
