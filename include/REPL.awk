####################################################################
# REPL.awk                                                         #
####################################################################

# Detect external readline wrapper (rlwrap).
function initRlwrap() {
    Rlwrap = ("rlwrap --version 2>/dev/null" | getline) ? "rlwrap" : ""
}

# Prompt for interactive session.
function prompt(    i, p, temp) {
    p = Option["prompt"]

    # Format specifiers supported by strftime().
    # Roughly following ISO 8601:1988, with the notable exception of "%S", "%t" and "%T".
    # GNU libc extensions like "%l", "%s" and "%_*" are not supported.
    # See: <https://www.gnu.org/software/gawk/manual/html_node/Time-Functions.html>
    #      <http://pubs.opengroup.org/onlinepubs/007908799/xsh/strftime.html>
    if (p ~ /%a/) gsub(/%a/, strftime("%a"), p)
    if (p ~ /%A/) gsub(/%A/, strftime("%A"), p)
    if (p ~ /%b/) gsub(/%b/, strftime("%b"), p)
    if (p ~ /%B/) gsub(/%B/, strftime("%B"), p)
    if (p ~ /%c/) gsub(/%c/, strftime("%c"), p)
    if (p ~ /%C/) gsub(/%C/, strftime("%C"), p)
    if (p ~ /%d/) gsub(/%d/, strftime("%d"), p)
    if (p ~ /%D/) gsub(/%D/, strftime("%D"), p)
    if (p ~ /%e/) gsub(/%e/, strftime("%e"), p)
    if (p ~ /%F/) gsub(/%F/, strftime("%F"), p)
    if (p ~ /%g/) gsub(/%g/, strftime("%g"), p)
    if (p ~ /%G/) gsub(/%G/, strftime("%G"), p)
    if (p ~ /%h/) gsub(/%h/, strftime("%h"), p)
    if (p ~ /%H/) gsub(/%H/, strftime("%H"), p)
    if (p ~ /%I/) gsub(/%I/, strftime("%I"), p)
    if (p ~ /%j/) gsub(/%j/, strftime("%j"), p)
    if (p ~ /%m/) gsub(/%m/, strftime("%m"), p)
    if (p ~ /%M/) gsub(/%M/, strftime("%M"), p)
    if (p ~ /%n/) gsub(/%n/, strftime("%n"), p)
    if (p ~ /%p/) gsub(/%p/, strftime("%p"), p)
    if (p ~ /%r/) gsub(/%r/, strftime("%r"), p)
    if (p ~ /%R/) gsub(/%R/, strftime("%R"), p)
    if (p ~ /%u/) gsub(/%u/, strftime("%u"), p)
    if (p ~ /%U/) gsub(/%U/, strftime("%U"), p)
    if (p ~ /%V/) gsub(/%V/, strftime("%V"), p)
    if (p ~ /%w/) gsub(/%w/, strftime("%w"), p)
    if (p ~ /%W/) gsub(/%W/, strftime("%W"), p)
    if (p ~ /%x/) gsub(/%x/, strftime("%x"), p)
    if (p ~ /%X/) gsub(/%X/, strftime("%X"), p)
    if (p ~ /%y/) gsub(/%y/, strftime("%y"), p)
    if (p ~ /%Y/) gsub(/%Y/, strftime("%Y"), p)
    if (p ~ /%z/) gsub(/%z/, strftime("%z"), p)
    if (p ~ /%Z/) gsub(/%Z/, strftime("%Z"), p)

    # %_ : prompt message
    if (p ~ /%_/)
        gsub(/%_/, showTranslationsOf(Option["hl"]), p)

    # %l : home language
    if (p ~ /%l/)
        gsub(/%l/, getDisplay(Option["hl"]), p)

    # %L : home language (English name)
    if (p ~ /%L/)
        gsub(/%L/, getName(Option["hl"]), p)

    # %s : source language
    # 's' is the format-control character for string

    # %S : source language (English name)
    if (p ~ /%S/)
        gsub(/%S/, getName(Option["sl"]), p)

    # %t : target languages, separated by "+"
    if (p ~ /%t/) {
        temp = getDisplay(Option["tl"][1])
        for (i = 2; i <= length(Option["tl"]); i++)
            temp = temp "+" getDisplay(Option["tl"][i])
        gsub(/%t/, temp, p)
    }

    # %T : target languages (English names), separated by "+"
    if (p ~ /%T/) {
        temp = getName(Option["tl"][1])
        for (i = 2; i <= length(Option["tl"]); i++)
            temp = temp "+" getName(Option["tl"][i])
        gsub(/%T/, temp, p)
    }

    # %, : target languages, separated by ","
    if (p ~ /%,/) {
        temp = getDisplay(Option["tl"][1])
        for (i = 2; i <= length(Option["tl"]); i++)
            temp = temp "," getDisplay(Option["tl"][i])
        gsub(/%,/, temp, p)
    }

    # %< : target languages (English names), separated by ","
    if (p ~ /%</) {
        temp = getName(Option["tl"][1])
        for (i = 2; i <= length(Option["tl"]); i++)
            temp = temp "," getName(Option["tl"][i])
        gsub(/%</, temp, p)
    }

    # %/ : target languages, separated by "/"
    if (p ~ /%\//) {
        temp = getDisplay(Option["tl"][1])
        for (i = 2; i <= length(Option["tl"]); i++)
            temp = temp "/" getDisplay(Option["tl"][i])
        gsub(/%\//, temp, p)
    }

    # %? : target languages (English names), separated by "/"
    if (p ~ /%\?/) {
        temp = getName(Option["tl"][1])
        for (i = 2; i <= length(Option["tl"]); i++)
            temp = temp "/" getName(Option["tl"][i])
        gsub(/%\?/, temp, p)
    }

    # %s : source language
    printf(AnsiCode["bold"] AnsiCode[tolower(Option["prompt-color"])] p AnsiCode[0] " ", getDisplay(Option["sl"])) > "/dev/stderr"
}
