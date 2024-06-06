if status is-interactive
      # Commands to run in interactive sessions can go here
    function ls -w exa 
        command exa $argv
    end
    function ll -w exa
        command exa --long --no-user --no-time --smart-group $argv
    end
    function lls -w exa 
        ll --total-size $argv
    end 
    function tree -w exa 
        command exa --tree $argv
    end
    function ftree -w exa 
        tree --level 1 $argv
    end
    function suc -w command -d 'alisas for su -c "argv"'
        command su -c "$argv"
    end
    function subc -w command -d 'alisas for su build -c "argv"'
        command su build -c "$argv"
    end
    function lazygit -w lazygit
        command lazygit --use-config-file="$(command lazygit -cd)/config.yml,$(command lazygit -cd)/catppuccin/themes-mergable/mocha/mauve.yml"
    end

  starship init fish | source
  zoxide init --cmd cd fish | source
  eval (zellij setup --generate-auto-start fish | string collect)
  eval (zellij setup --generate-completion fish | string collect)
end

set -a PATH "$HOME/.cargo/bin"
# Created by `pipx`
set PATH $PATH "$HOME/.local/bin"
