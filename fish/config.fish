if status is-interactive
    # Commands to run in interactive sessions can go here
  function ls 
    command exa $argv
  end
  function ll
    command exa --long --no-user --no-time --smart-group $argv
  end
  function lls
    ll --total-size $argv
  end

  function tree
    command exa --tree $argv
  end
  function ftree
    tree --level 1 $argv
  end
  function suc -w command -d 'alisas for su -c "argv"'
    command su -c "$argv"
  end

  starship init fish | source
  zoxide init --cmd cd fish | source
  eval (zellij setup --generate-auto-start fish | string collect)
  eval (zellij setup --generate-completion fish | string collect)
end

# Created by `pipx`
set PATH $PATH /home/sineptic/.local/bin
