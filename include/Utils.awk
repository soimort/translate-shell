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

# Detect curl.
function initCurl() {
    Curl = detectProgram("curl", "--version")
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

# Return 1 if the first version is newer than the second; otherwise return 0.
function newerVersion(ver1, ver2,    i, group1, group2) {
    split(ver1, group1, ".")
    split(ver2, group2, ".")
    for (i = 1; i <= 4; i++) {
        if (group1[i] + 0 > group2[i] + 0)
            return 1
        else if (group1[i] + 0 < group2[i] + 0)
            return 0
    }
    return 0
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
                params = params " " parameterize(ARGV[i], "\"")
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

# Fetch the content of a URL. Return a null string if failed.
function curl(url,    command, content, line) {
    initCurl()

    if (!Curl) {
        l(">> not found: curl")
        w("[WARNING] curl is not found.")
        return NULLSTR
    } else {
        command = Curl " --location --silent " url
        content = NULLSTR
        while ((command |& getline line) > 0)
            content = (content ? content "\n" : NULLSTR) line
        return content
    }
}

# Dump a Unicode string into a byte array. Return the length of the array.
# NOTE: can only be ran once for each text! Build a cache.
function dump(text, group,    command, temp) {
    command = "hexdump" " -e'1/1 \"%03d\" \" \"'"
    ("echo " parameterize(text) PIPE command) | getline temp
    split(temp, group, " ")
    return length(group) - 1
}
