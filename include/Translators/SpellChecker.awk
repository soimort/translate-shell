####################################################################
# SpellChecker.awk                                                 #
####################################################################
BEGIN {
    provides("spell")
    provides("aspell")
    provides("hunspell")
}

# Detect external (ispell -a compatible) spell checker.
function spellInit() {
    Ispell = detectProgram("aspell", "--version") ? "aspell" :
        (detectProgram("hunspell", "--version") ? "hunspell" : "")

    if (!Ispell) {
        e("[ERROR] Spell checker (aspell or hunspell) not found.")
        exit 1
    }
}

function aspellInit() {
    if (!(Ispell = detectProgram("aspell", "--version") ? "aspell" : "")) {
        e("[ERROR] Spell checker (aspell) not found.")
        exit 1
    }
}

function hunspellInit() {
    if (!(Ispell = detectProgram("hunspell", "--version") ? "hunspell" : "")) {
        e("[ERROR] Spell checker (hunspell) not found.")
        exit 1
    }
}

# Check a string.
function spellTranslate(text, sl, tl, hl,
                        isVerbose, toSpeech, returnPlaylist, returnIl,
                        ####
                        args, i, j, r, line, group, word, sug) {
    args = " -a" (sl != "auto" ? " -d " sl : "")
    if (system("echo" PIPE Ispell args SUPOUT SUPERR)) {
        e("[ERROR] No dictionary for language: " sl)
        exit 1
    }

    i = 1
    r = ""
    while ((("echo " parameterize(text) PIPE Ispell args SUPERR) |& getline line) > 0) {
        match(line,
              /^& (.*) [[:digit:]]+ [[:digit:]]+: ([^,]+)(, ([^,]+))?(, ([^,]+))?/,
              group)
        if (RSTART) {
            ExitCode = 1 # found a spelling error

            word = group[1]
            sug = "[" group[2]
            if (group[4]) sug = sug "|" group[4]
            if (group[6]) sug = sug "|" group[6]
            sug = sug "]"

            j = i + index(substr(text, i), word) - 1
            r = r substr(text, i, j - i)
            r = r ansi("bold", ansi("red", word)) ansi("yellow", sug)
            i = j + length(word)
        }
    }
    r = r substr(text, i)
    return r
}

function aspellTranslate(text, sl, tl, hl,
                         isVerbose, toSpeech, returnPlaylist, returnIl) {
    return spellTranslate(text, sl, tl, hl)
}

function hunspellTranslate(text, sl, tl, hl,
                           isVerbose, toSpeech, returnPlaylist, returnIl) {
    return spellTranslate(text, sl, tl, hl)
}
