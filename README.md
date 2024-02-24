# Trev's `.dotfiles`

Hello, and welcome to my `.dotfiles` repository. To use this repository, you can maintain dotfiles manually or install `stow`!

Using stow, you can run the following commands to copy my dotfiles into your main directory!

1. First, check to make sure that stow is not doing anything that you do not want it to do. You can do so using the `-n` flag, with the verbose flag.

    ```sh
    stow -nv .
    ```

    I would also back up any **VERY IMPORTANT** `.dotfiles` so they are never accidentally overwritten.

2. If everything looks good, you can run the real `stow` command like so:

    ```sh
    stow -v .
    ```
    If step 1 showed results you are not happy with, you can use the stow command on individual files, so you do not overwrite anything important! For example:

    ```sh
    stow -v .zshrc
    ```

