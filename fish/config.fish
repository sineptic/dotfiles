if status is-interactive
      # Commands to run in interactive sessions can go here
    function ls -w eza 
        command eza $argv
    end
    function ll -w eza
        command eza --long --no-user --no-time --smart-group $argv
    end
    function lls -w eza 
        ll --total-size $argv
    end 
    function tree -w eza 
        command eza --tree $argv
    end
    function ftree -w eza 
        tree --level 1 $argv
    end
    function suc -w command -d 'alias for su -c "argv"'
        command su -c "$argv"
    end
    function subc -w command -d 'alias for su build -c "argv"'
        command su build -c "$argv"
    end
    function lazygit -w lazygit
        command lazygit --use-config-file="$(command lazygit -cd)/config.yml,$(command lazygit -cd)/catppuccin/themes-mergable/mocha/mauve.yml" $argv
    end
    function lg -w lazygit
        lazygit $argv
    end
    function c -w cargo
        command cargo $argv
    end
    function nv -w nvim
        command nvim $argv
    end
    function pass -w pass
        WAYLAND_DISPLAY="" EDITOR="nvim" command pass $argv
    end
    function passget -w "pass show"
        pass show $argv -c1
    end
    function z -w cd 
        cd $argv && ls
    end
    function .. 
        z ..
    end

  starship init fish | source
  zoxide init --cmd cd fish | source
  # eval (zellij setup --generate-auto-start fish | string collect)
  eval (zellij setup --generate-completion fish | string collect)
end

set -a PATH "$HOME/.cargo/bin"
# Created by `pipx`
set PATH $PATH "$HOME/.local/bin"
set -x EDITOR "nvim"
set -x copy_cmd "fish_clipboard_copy"
