####################################################################
# Utils.awk                                                        #
####################################################################

# Detect gawk version.
function initGawk(    group) {
    Gawk = "gawk"
    GawkVersion = PROCINFO["version"]

    split(PROCINFO["version"], group, ".")
    if (group[1] < 4) {
        e("[ERROR] Oops! Your gawk (version " GawkVersion ") "          \
          "appears to be too old.\n"                                    \
          "        You need at least gawk 4.0.0 to run this program.")
        exit 1
    }
}

# Detect external bidirectional algorithm utility (fribidi);
# Fallback to Unix `rev` if not found.
function initBiDi() {
    FriBidi = detectProgram("fribidi", "--version", 1)
    BiDiNoPad = FriBidi ? "fribidi --nopad" : "rev"
    BiDi = FriBidi ? "fribidi --width %s" :
        "rev | sed \"s/'/\\\\\\'/\" | xargs printf '%%s '"
}

# Detect external readline wrapper (rlwrap).
function initRlwrap() {
    Rlwrap = detectProgram("rlwrap", "--version")
}

# Detect emacs.
function initEmacs() {
    Emacs = detectProgram("emacs", "--version")
}

# Log any value if debugging is enabled.
function l(value, name, inline, heredoc, valOnly, numSub, sortedIn) {
    if (Option["debug"]) {
        if (name)
            da(value, name, inline, heredoc, valOnly, numSub, sortedIn)
        else
            d(value)
    }
}

# Return a log message if debugging is enabled.
function m(string) {
    if (Option["debug"])
        return ansi("cyan", string) RS
}

# Fork a rlwrap process as the wrapper. Return non-zero if failed,
function rlwrapMe(    i, command) {
    initRlwrap()

    if (!Rlwrap) {
        l(">> not found: rlwrap")
        return 1
    } else if (!(ENVIRON["TRANS_PROGRAM"] || fileExists(EntryPoint))) {
        l(">> not found: $TRANS_PROGRAM or EntryPoint")
        return 1
    } else {
        command = Rlwrap " " Gawk " " (ENVIRON["TRANS_PROGRAM"] ?
                                       "\"${TRANS_PROGRAM}\"" :
                                       "-f " EntryPoint)                \
            " - " parameterize("-no-rlwrap") # never fork rlwrap again!
        for (i = 1; i < length(ARGV); i++)
            if (ARGV[i])
                command = command " " parameterize(ARGV[i])

        l(">> forking: " command)
        if (!system(command)) {
            l(">> process exited with code 0")
            exit ExitCode
        } else {
            l(">> process exited with non-zero return code")
            return 1
        }
    }
}

# Fork an emacs process as the front-end. Return non-zero if failed,
function emacsMe(    i, params, el, command) {
    initEmacs()

    if (!Emacs) {
        l(">> not found: emacs")
        return 1
    } else if (!(ENVIRON["TRANS_PROGRAM"] || fileExists(EntryPoint))) {
        l(">> not found: $TRANS_PROGRAM or EntryPoint")
        return 1
    } else {
        params = ""
        for (i = 1; i < length(ARGV); i++)
            if (ARGV[i])
                params = params " " (parameterize(ARGV[i], "\""))
        if (ENVIRON["TRANS_PROGRAM"]) {
            el = "(progn (setq trans-program (getenv \"TRANS_PROGRAM\")) " \
                "(setq explicit-shell-file-name \"" Gawk "\") "         \
                "(setq explicit-" Gawk "-args (cons trans-program '(\"-\" \"-I\" \"-no-rlwrap\"" params "))) " \
                "(command-execute 'shell) (rename-buffer \"" Name "\"))"
        } else {
            el = "(progn (setq explicit-shell-file-name \"" Gawk "\") " \
                "(setq explicit-" Gawk "-args '(\"-f\" \"" EntryPoint "\" \"--\" \"-I\" \"-no-rlwrap\"" params ")) " \
                "(command-execute 'shell) (rename-buffer \"" Name "\"))"
        }
        command = Emacs " --eval " parameterize(el)

        l(">> forking: " command)
        if (!system(command)) {
            l(">> process exited with code 0")
            exit ExitCode
        } else {
            l(">> process exited with non-zero return code")
            return 1
        }
    }
}
