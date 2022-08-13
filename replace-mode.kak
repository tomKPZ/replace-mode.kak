declare-user-mode replace
declare-user-mode replace-aux
hook global ModeChange push:.*:next-key\[user.replace\] %{
    hook -once window RawKey .* %{
        # Skip the first keypress that takes us into replace mode.
        enter-user-mode replace-aux
    }
}
hook global ModeChange push:.*:next-key\[user.replace-aux\] %{
    hook -once window RawKey .* %{
        evaluate-commands %sh{
            if [ "$kak_hook_param" = '<esc>' ]; then
                echo 'execute-keys <esc>'
            else
                # Reduce selections to cursors.  It's unclear why 2 ; are
                # necessasry.
                echo "execute-keys ';;'"
                case "$kak_hook_param" in
                    '<left>')  echo 'execute-keys h' ;;
                    '<right>') echo 'execute-keys l' ;;
                    '<up>')    echo 'execute-keys k' ;;
                    '<down>')  echo 'execute-keys j' ;;
                    *)
                        key="$kak_hook_param"
                        if [ "$key" = "'" ]; then
                            key="''"
                        fi
                        # Insert the character by inserting a space and then replacing
                        # with the target character.  This seems to handle more
                        # cases than inserting the character directly.
                        echo "execute-keys -draft 'i <esc>hr$key'"
                        # Delete all non-newline characters.  This prevents wrapping
                        # in replace mode.
                        echo "try %{ execute-keys -draft 'Z<a-K>\n<ret>dz' }"
                    ;;
                esac
                echo "enter-user-mode replace-aux"
            fi
        }
    }
}
