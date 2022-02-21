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
            if [ $kak_hook_param = "<esc>" ]; then
                echo "execute-keys <esc>"
            else
                # Reduce selections to cursors.  It's unclear why 2 ; are
                # necessasry.
                echo "execute-keys ';;'"
                # Insert the character by inserting a space and then replacing
                # with the target character.  This seems to handle more
                # cases than inserting the character directly.
                echo "execute-keys -draft 'i <esc>hr$kak_hook_param'"
                # Delete all non-newline characters.  This prevents wrapping
                # in replace mode.
                echo "try %{ execute-keys -draft 'Z<a-K>\n<ret>dz' }"
                echo "enter-user-mode replace-aux"
            fi
        }
    }
}
