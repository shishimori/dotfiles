#!/bin/bash

LINK_FILES=(
    ./bash/.bash_aliases
)

for f in "${LINK_FILES[@]}"
do
    FROM_PATH=$(readlink -f $f)
    LINK_PATH="$HOME/$(basename $FROM_PATH)"

    if [ ! -e $LINK_PATH ]; then
        ln -snfv $FROM_PATH $LINK_PATH
    else
        echo "'$LINK_PATH' is already exists."
    fi
done
