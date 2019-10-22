#!/bin/bash
if ! [ -x "$(command -v git)" ]; then
    echo "Installing git..." >&2
    sudo apt install -y git;
fi

if ! [ -x "$(command -v tmux)" ]; then
    echo "Installing tmux..." >&2
    sudo apt install -y tmux;
fi

cd && git clone https://github.com/hongsophal/.tmux.git &&
ln -s -f .tmux/.tmux.conf && cp .tmux/.tmux.conf.local . &&
echo "Success" || echo "Fail";
