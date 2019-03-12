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

# Detect whether the terminal emulator implements its own BiDi support.
# NOTE: not working inside an SSH session!
function initBiDiTerm() {
    if (ENVIRON["MLTERM"])
        BiDiTerm = "mlterm"
    else if (ENVIRON["KONSOLE_VERSION"])
        BiDiTerm = "konsole"
}

# Detect external bidirectional algorithm utility (fribidi);
# Fallback to Unix `rev` if not found.
function initBiDi() {
    FriBidi = detectProgram("fribidi", "--version", 1)
    BiDiNoPad = FriBidi ? "fribidi --nopad" : "rev" SUPERR
    BiDi = FriBidi ? "fribidi --width %s" :
        "rev" SUPERR "| sed \"s/'/\\\\\\'/\" | xargs printf '%%s '"
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
    }

    if (ENVIRON["TRANS_ENTRY"]) {
        command = Rlwrap " " ENVIRON["TRANS_ENTRY"] " "                 \
            parameterize("-no-rlwrap") # never fork rlwrap again!
    } else if (fileExists(ENVIRON["TRANS_DIR"] "/" EntryScript)) {
        command = Rlwrap " sh "                                         \
            parameterize(ENVIRON["TRANS_DIR"] "/" EntryScript)          \
            " - " parameterize("-no-rlwrap") # never fork rlwrap again!
    } else {
        l(">> not found: $TRANS_ENTRY or EntryPoint")
        return 1
    }
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

# Fork an emacs process as the front-end. Return non-zero if failed,
function emacsMe(    i, params, el, command) {
    initEmacs()

    if (!Emacs) {
        l(">> not found: emacs")
        return 1
    }

    params = ""
    for (i = 1; i < length(ARGV); i++)
        if (ARGV[i])
            params = params " " parameterize(ARGV[i], "\"")
    if (ENVIRON["TRANS_ENTRY"]) {
        el = "(progn (setq explicit-shell-file-name \"" ENVIRON["TRANS_ENTRY"] "\") " \
            "(setq explicit-" Command "-args '(\"-I\" \"-no-rlwrap\"" params ")) " \
            "(command-execute 'shell) (rename-buffer \"" Name "\"))"
    } else if (fileExists(ENVIRON["TRANS_DIR"] "/" EntryScript)) {
        el = "(progn (setq explicit-shell-file-name \"" "sh" "\") "     \
            "(setq explicit-" "sh" "-args '(\"" ENVIRON["TRANS_DIR"] "/" EntryScript "\" \"-I\" \"-no-rlwrap\"" params ")) " \
            "(command-execute 'shell) (rename-buffer \"" Name "\"))"
    } else {
        l(">> not found: $TRANS_ENTRY or EntryPoint")
        return 1
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

# Fetch the content of a URL. Return a null string if failed.
function curl(url, output,    command, content, line) {
    initCurl()

    if (!Curl) {
        l(">> not found: curl")
        w("[WARNING] curl is not found.")
        return NULLSTR
    }

    command = Curl " --location --silent"
    if (Option["proxy"])
        command = command " --proxy " parameterize(Option["proxy"])
    if (Option["user-agent"])
        command = command " --user-agent " parameterize(Option["user-agent"])
    command = command " " parameterize(url)
    if (output) {
        command = command " --output " parameterize(output)
        system(command)
        return NULLSTR
    }
    content = NULLSTR
    while ((command |& getline line) > 0)
        content = (content ? content "\n" : NULLSTR) line
    close(command)
    return content
}

# Fetch the content of a URL. Return a null string if failed.
function curlPost(url, data, output,    command, content, line) {
    initCurl()

    if (!Curl) {
        l(">> not found: curl")
        w("[WARNING] curl is not found.")
        return NULLSTR
    }

    command = Curl " --location --silent"
    if (Option["proxy"])
        command = command " --proxy " parameterize(Option["proxy"])
    if (Option["user-agent"])
        command = command " --user-agent " parameterize(Option["user-agent"])
    command = command " --request POST --data " parameterize(data)
    command = command " " parameterize(url)
    if (output) {
        command = command " --output " parameterize(output)
        system(command)
        return NULLSTR
    }
    content = NULLSTR
    while ((command |& getline line) > 0)
        content = (content ? content "\n" : NULLSTR) line
    close(command)
    return content
}

# Dump a Unicode string into a byte array. Return the length of the array.
function dump(text, group,    command, temp) {
    # hexdump tricks:
    # (1) use -v (--no-squeezing)
    # (2) use "%u" (unsigned integers)
    command = "hexdump" " -v -e'1/1 \"%03u\" \" \"'"
    command = "echo " parameterize(text) PIPE command
    command | getline temp
    split(temp, group, " ")
    close(command)
    return length(group) - 1
}

# Base64 encode a string.
function base64(text,    command, temp) {
    command = "echo -n " parameterize(text) PIPE "base64"
    command = "bash -c " parameterize(command, "\"")
    command | getline temp
    close(command)
    return temp
}

# Print a Unicode-escaped string. (requires GNU Bash)
function uprintf(text,    command, temp) {
    command = "echo -en " parameterize(text)
    command = "bash -c " parameterize(command, "\"")
    command | getline temp
    close(command)
    return temp
}
