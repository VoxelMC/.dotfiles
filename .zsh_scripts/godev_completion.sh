_godev()
{
    local MEMO_DIR=$HOME/Dev
    local cmd=$1 cur=$2 pre=$3
    local arr i file

    arr=( $( cd "$MEMO_DIR" && compgen -f -- "$cur" ) )
    COMPREPLY=()
    for ((i = 0; i < ${#arr[@]}; ++i)); do
        file=${arr[i]}
        if [[ -d $MEMO_DIR/$file ]]; then
            file=$file/
        fi
        COMPREPLY[i]=$file
    done
}
complete -F _godev -o nospace godev
