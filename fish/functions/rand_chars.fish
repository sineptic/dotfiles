function rand_chars -a lenght
  command tr -dc A-Za-z0-9 </dev/urandom | head -c $lenght; echo
end
