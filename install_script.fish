#!/usr/bin/env fish

set root_commands

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
"yazi",
"lazygit",
"alacritty",
"pass",
}
set -l fonts {
"ttf-monofur-nerd",
"ttf-zed-mono-nerd",
}
set programs_as_string $(for program in $programs; echo $(string trim $program); end | string collect | string split "\n" | string join " ")
set fonts_as_string $(for font in $fonts; echo $(string trim $font); end | string collect | string split "\n" | string join " ")
set dotfiles_dir $(realpath $(status dirname))

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
  set -f status_cache $status
  if test $status_cache -ne 0
    echo "ERROR: command '$argv' failed with code $status_cache"
    exit
  end
end

function embed_command_silent
  $argv &>/dev/null
  set -f status_cache $status
  if test $status_cache -ne 0
    echo "ERROR: command '$argv' failed with code $status_cache"
    exit
  end
end



echo -n "Install programs?"
get_user_agreement
if test $status -eq 1
  set -a root_commands "pacman -Sy --needed $programs_as_string"
end

printf "\n"

echo -n "Install fonts?"
get_user_agreement
if test $status -eq 1
  set -a root_commands "pacman -Sy --needed $fonts_as_string"
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
  echo "y" | embed_command_silent fish_config theme save "Catppuccin Mocha"
  echo "fish theming is finished"
end

function btop_dotfiles
  command_silent mkdir -p "$dotfiles_dir/btop/themes"
  command_silent ln -sf "$dotfiles_dir/btop" "$HOME/.config/"
  command_silent wget --no-clobber -qP "$dotfiles_dir/btop/themes" https://github.com/catppuccin/btop/raw/main/themes/catppuccin_frappe.theme
  command_silent wget --no-clobber -qP "$dotfiles_dir/btop/themes" https://github.com/catppuccin/btop/raw/main/themes/catppuccin_latte.theme
  command_silent wget --no-clobber -qP "$dotfiles_dir/btop/themes" https://github.com/catppuccin/btop/raw/main/themes/catppuccin_macchiato.theme
  command_silent wget --no-clobber -qP "$dotfiles_dir/btop/themes" https://github.com/catppuccin/btop/raw/main/themes/catppuccin_mocha.theme
  echo "btop configuration is finished"
end

function starship_dotfiles
  command_silent rm -rf "$dotfiles_dir/starship/catppuccin/"
  command_silent mkdir -p "$dotfiles_dir/starship/catppuccin/"
  command_silent wget --no-clobber -qP "$dotfiles_dir/starship/catppuccin" https://github.com/sineptic/starship-catppuccin/raw/main/starship.toml

  command_silent rm -rf "$dotfiles_dir/starship/kanagawa/"
  command_silent mkdir -p "$dotfiles_dir/starship/kanagawa/"
  command_silent wget --no-clobber -qP "$dotfiles_dir/starship/kanagawa" https://github.com/sineptic/starship-kanagawa/raw/main/starship.toml

  # set -f selected_theme "catppuccin"
  set -f selected_theme "kanagawa"
  command_silent ln -sf "$dotfiles_dir/starship/$selected_theme/starship.toml" "$HOME/.config/"
  echo "starship configuration is finished"
end

function fzf_theming
  set -Ux FZF_DEFAULT_OPTS "--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
end

function fish_dotfiles
  command_silent ln -sf "$dotfiles_dir/fish" "$HOME/.config/"
  fish_theming
  echo "fish configuration is finished"
end

function zellij_dotfiles
  command_silent ln -sf "$dotfiles_dir/zellij" "$HOME/.config/"
  echo "zellij configuration is finished"
end

function alacritty_dotfiles # TODO: add theme downloading
  command_silent ln -sf "$dotfiles_dir/alacritty" "$HOME/.config/"
  echo "alacritty configuration is finished"
end

function yazi_dotfiles # TODO: add theme downloading
  command_silent ln -sf "$dotfiles_dir/yazi" "$HOME/.config/"
  echo "yazi configuration is finished"
end


function lazygit_dotfiles # TODO: add theme downloading
  command_silent ln -sf "$dotfiles_dir/lazygit" "$HOME/.config/"
  echo "lazygit configuration is finished"
end

echo -n "Install dotfiles?"
get_user_agreement
if test $status -eq 1
    bat_dotfiles
    btop_dotfiles
    starship_dotfiles
    fish_dotfiles
    fzf_theming
    zellij_dotfiles
    alacritty_dotfiles
    yazi_dotfiles
    lazygit_dotfiles
    echo "configuration completed"
end
