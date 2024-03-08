#!/usr/bin/env fish

set root_commands

function get_user_agreement -d "user must write 'y'(return 1) or 'n'(return 0)"
  set -l input ""

  while test $input != "y" 
    and test $input != "n"
  
    printf "\n('y'es or 'n'o): \n"
    read -f -p "printf '\e[2K\e[1A\e[15C             '" input
  end
  
  if test $input = "y"
    return 1
  else
    return 0
  end
end


set -l programs {
"neovim", 
"zellij",
"bat",
"eza",
"zoxide",
"btop",
"fastfetch",
"fisher",
"fzf",
"less",
"python",
"python-pip",
"starship",
}
set -l fonts {
"ttf-monofur-nerd",
"ttf-jetbrains-mono-nerd"
}
set programs_as_string $(for program in $programs; echo $(string trim $program); end | string collect | string split "\n" | string join " ")
set fonts_as_string $(for font in $fonts; echo $(string trim $font); end | string collect | string split "\n" | string join " ")


echo -n "Install programs?"
get_user_agreement
if test $status -eq 1
  set -a root_commands "pacman -Sy --needed $programs_as_string"
end

printf "\n"

echo -n "Install fonts?"
get_user_agreement
if test $status -eq 1
  set -a root_commands "pacman -Sy --needed $programs_as_string"
end

printf "\n"

echo -n "Install dotfiles?"
get_user_agreement
if test $status -eq 1
  # TODO
  echo "ERROR: unimplemented"
end


# execute root root commands
set root_commands_as_string 
if fish_is_root_user
  command "$(string join -n "; " $root_commands)"
else
  printf "Root " # root password
  command su -c "$(string join -n "; " $root_commands)"
end

