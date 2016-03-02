source ~/.hosts # contains my servers' IP addresses

PATH=$PATH:~/bin
# homebrew
PATH=/usr/local/bin:$PATH
# ruby
PATH="~/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
# export
export PATH

export _retval="Use this value to return strings from zsh functions"

alias assets="rake assets:precompile RAILS_ENV=production"

function sshh() {
  host_alias=$1
  if [ $host_alias ]; then
    get_host_by_alias $1
    host=$_retval
    if [[ $host == "ERROR" ]]; then
      error "Invalid host alias '$host_alias'"
      return
    fi
    woo "Resolved host $host_alias --> $host"
    ssh "tyler@$host"
  else
    warn "No host identified"
    echo -n "${CYAN}Connecting to rigby"
    sleep .3
    echo -n "."
    sleep .3
    echo -n "."
    sleep .3
    echo ".${RESET}"
    ssh "tyler@$rigby"
  fi
}

function get_host_by_alias() {
  host_alias=$1
  if [[ $host_alias == "rigby" ]]; then
    str_return $rigby
  else
    str_return "ERROR"
  fi
}

function count_lines() {
  file_ending=$1
  if [ $file_ending ]; then
    echo `find . -name "*.$file_ending" | xargs wc -l`
  else
    echo `find . -name "*.java" | xargs wc -l`
  fi
}

# Sets a string return value for a function
function str_return() {
  export _retval=$1
}

# Logging
function woo() {
  echo ${GREEN}${1}${RESET}
}
function warn() {
  echo ${YELLOW}${1}${RESET}
}
function error() {
  echo ${RED}${1}${RESET}
}

# Colors
autoload -U colors && colors
for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN BLACK WHITE; do
  eval $COLOR='$fg_no_bold[${(L)COLOR}]'
  eval BOLD_$COLOR='$fg_bold[${(L)COLOR}]'
done
eval RESET='$reset_color'
