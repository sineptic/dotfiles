function as_build -w command -d "create sudoer user 'build', run command and delete it"
  set -f file_location "$(path dirname $(status --current-filename))"
  cp -f $file_location/as_build/as_build_template $file_location/as_build/tmp
  echo $argv >> $file_location/as_build/tmp
  printf "Root " # ... Password: 
  su -c "$file_location/as_build/root_script"
  rm -f $file_location/as_build/tmp
end
