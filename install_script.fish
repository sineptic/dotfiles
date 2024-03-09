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

function command_silent
  command $argv &>/dev/null
  if test $status -ne 0
    echo "ERROR: command '$argv' failed with code $status"
    exit
  end
end

function embed_command_silent
  $argv &>/dev/null
  if test $status -ne 0
    echo "ERROR: command '$argv' failed with code $status"
    exit
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
"wget",
"fisher",
}
set -l fonts {
"ttf-monofur-nerd",
"ttf-jetbrains-mono-nerd"
}
set programs_as_string $(for program in $programs; echo $(string trim $program); end | string collect | string split "\n" | string join " ")
set fonts_as_string $(for font in $fonts; echo $(string trim $font); end | string collect | string split "\n" | string join " ")
set dotfiles_dir $(realpath $(status dirname))


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

# execute commands with root access
set root_commands_as_string "$(string join -n "; " $root_commands)" 
if test -n $root_commands_as_string
  if fish_is_root_user
    command $root_commands_as_string
  else
    printf "Root " # root password
    command su -c $root_commands_as_string
  end
end

echo -n "Install dotfiles?"

function bat_dotfiles
  command_silent mkdir -p "$dotfiles_dir/bat/themes"
  command_silent ln -sf "$dotfiles_dir/bat" "$(path normalize "$(bat --config-dir)/..")/"
  command_silent wget --no-clobber -qP "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
  command_silent wget --no-clobber -qP "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
  command_silent wget --no-clobber -qP "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
  command_silent wget --no-clobber -qP "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
  command_silent bat cache --build
  echo "bat configuration is finished"
end

function fish_theming
  embed_command_silent fisher install catppuccin/fish 
  embed_command_silent fish_config theme save "Catppuccin Mocha"
  echo "fish theming is finished"
end

get_user_agreement
if test $status -eq 1
  bat_dotfiles
  fish_theming
  echo "configuration completed"
end
