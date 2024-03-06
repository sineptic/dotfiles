#!/usr/bin/env fish

function get_user_agreement -d "user must write 'y'(return 1) or 'n'(return 0)"
  set -l input ""

  while test $input != "y" 
    and test $input != "n"
  
    printf "('y'es or 'n'o): \n"
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
set -l programs_as_string $(for program in $programs; echo $(string trim $program); end | string collect | string split "\n" | string join " ")
set -l fonts_as_string $(for font in $fonts; echo $(string trim $font); end | string collect | string split "\n" | string join " ")


echo "Install programs?"
get_user_agreement
if test $status -eq 1
  printf "Root " # root password
  command su -c "pacman -Sy --needed $programs_as_string"
end

printf "\n"

echo "Install fonts?"
get_user_agreement
if test $status -eq 1
  printf "Root " # root password
  command su -c "pacman -Sy --needed $fonts_as_string"
end

printf "\n"

echo "Install dotfiles?"
get_user_agreement
if test $status -eq 1
  # TODO
  echo "ERROR: unimplemented"
end
