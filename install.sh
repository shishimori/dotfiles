#!/bin/bash

LINK_FILES=(
    ./bash/.bash_aliases
)

for f in "${LINK_FILES[@]}"
do
    FROM_PATH=$(readlink -f $f)

    FILE_NAME="$HOME/$(basename $FROM_PATH)"
    LINK_PATH=$(readlink -f $FILE_NAME)

    if [ ! -e $LINK_PATH ]; then
        ln -snfv $FROM_PATH $LINK_PATH
    else
        echo "'$LINK_PATH' is already exists."
    fi
done
