_complete_option() {
    COMPREPLY=($(compgen -W "$(trans -help -no-ansi \
        | awk '{\
            for (i = 1; i <= NF; i++) {\
                if (index($i, "-") == 1) {\
                    sub(/[,\.]$/, "", $i);\
                    print $i\
                }\
            }\
        }')" -- "$cur"))
}

_complete_engine() {
    COMPREPLY=($(compgen -W "$(trans -list-engines | awk '{ print gensub(/ |\*/, "", "g") }')" -- "$cur"))
}

_complete_language() {
    local multiple="$1"
    if [ "$multiple" ]; then
        # Without this '+' and whatever precedes it, is removed from the command line.
        COMP_WORDBREAKS+=+
        cur="${cur//*+/}"
    fi

    COMPREPLY=($(compgen -W "$(trans -list-codes; trans -list-languages; trans -list-languages-english | sort)" -- "$cur"))
}

_has_language_delimiter() {
    case "$cur" in
        *[:=]*)
            true
            ;;
        *)
            false
            ;;
    esac
}

_translate() {
    COMPREPLY=()
    # Remove '+'s if they are added to this variable in _complete_language(). Maybe not needed?
    COMP_WORDBREAKS="${COMP_WORDBREAKS//+/}"
    cur="$(_get_cword)"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [ "${prev:0:1}" = "-" ]; then
        case "$prev" in
            -s|-sl|-source|-from|-hl|-host)
                _complete_language false
                ;;
            -t|-tl|-target|-to|-L|-linguist)
                _complete_language true
                ;;
            -e|-engine)
                _complete_engine
                ;;
        esac
    elif [ "${cur:0:1}" = "-" ]; then
        _complete_option
    # Complete shorcut formatted languages.
    elif _has_language_delimiter; then
        # Remove first language and/or delimiter from cur.
        cur="${cur/*[:=]/}"
        _complete_language true
    else
        _complete_language true
    fi

    return 0
} &&
complete -F _translate default trans
