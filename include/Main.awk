####################################################################
# Main.awk                                                         #
####################################################################

# Detect gawk version.
function initGawk(    group) {
    Gawk = "gawk"
    GawkVersion = PROCINFO["version"]

    split(PROCINFO["version"], group, ".")
    if (group[1] < 4) {
        e("[ERROR] Oops! Your gawk (version " GawkVersion ") appears to be too old.\nYou need at least gawk 4.0.0 to run this program.")
        exit 1
    }
}

# Pre-initialization (before option parsing).
function preInit() {
    initGawk()          #<< AnsiCode

    # Languages
    initBiDi()
    initLocale()
    initLocaleDisplay() #<< Locale, BiDi
    initUserLang()      #<< Locale

    RS = "\n"

    ExitCode = 0

    Option["debug"] = 0

    Option["verbose"] = 1
    Option["show-original"] = 1
    Option["show-original-phonetics"] = 1
    Option["show-translation"] = 1
    Option["show-translation-phonetics"] = 1
    Option["show-prompt-message"] = 1
    Option["show-languages"] = 1
    Option["show-original-dictionary"] = 0
    Option["show-dictionary"] = 1
    Option["show-alternatives"] = 1

    Option["width"] = ENVIRON["COLUMNS"] ? ENVIRON["COLUMNS"] : 64
    Option["indent"] = 4

    Option["browser"] = ENVIRON["BROWSER"]

    Option["play"] = 0
    Option["player"] = ENVIRON["PLAYER"]

    Option["proxy"] = ENVIRON["HTTP_PROXY"] ? ENVIRON["HTTP_PROXY"] : ENVIRON["http_proxy"]

    Option["interactive"] = 0
    Option["no-rlwrap"] = 0
    Option["emacs"] = 0
    Option["prompt"] = ENVIRON["TRANS_PS"] ? ENVIRON["TRANS_PS"] : "%s>"
    Option["prompt-color"] = ENVIRON["TRANS_PS_COLOR"] ? ENVIRON["TRANS_PS_COLOR"] : "default"

    Option["input"] = ""
    Option["output"] = "/dev/stdout"

    Option["hl"] = ENVIRON["HOME_LANG"] ? ENVIRON["HOME_LANG"] : UserLang
    Option["sl"] = ENVIRON["SOURCE_LANG"] ? ENVIRON["SOURCE_LANG"] : "auto"
    Option["tl"][1] = ENVIRON["TARGET_LANG"] ? ENVIRON["TARGET_LANG"] : UserLang
}

# Post-initialization (after option parsing).
function postInit() {
    # Translate
    initHttpService()
}

# Main entry point.
BEGIN {
    preInit()

    pos = 0
    while (ARGV[++pos]) {
        # -, -no-op
        match(ARGV[pos], /^-(-?no-op)?$/)
        if (RSTART) continue

        # -V, -version
        match(ARGV[pos], /^--?(vers(i(on?)?)?|V)$/)
        if (RSTART) {
            print getVersion()
            print
            printf("%-22s%s\n", "gawk (GNU Awk)", PROCINFO["version"])
            printf("%s\n", FriBidi ? FriBidi : "fribidi (GNU FriBidi) [NOT INSTALLED]")
            printf("%-22s%s\n", "User Language", Locale[getCode(UserLang)]["name"] " (" show(Locale[getCode(UserLang)]["endonym"]) ")")
            exit
        }

        # -H, -h, -help
        match(ARGV[pos], /^--?(h(e(lp?)?)?|H)$/)
        if (RSTART) {
            print getHelp()
            exit
        }

        # -M, -m, -manual
        match(ARGV[pos], /^--?(m(a(n(u(al?)?)?)?)?|M)$/)
        if (RSTART) {
            if (ENVIRON["TRANS_MANPAGE"])
                system("echo -E \"${TRANS_MANPAGE}\" | " \
                       "groff -Wall -mtty-char -mandoc -Tutf8 -rLL=${COLUMNS}n -rLT=${COLUMNS}n | " \
                       (system("most 2>/dev/null") ?
                        "less -s -P\"\\ \\Manual page " Command "(1) line %lt (press h for help or q to quit)\"" :
                        "most -Cs"))
            else
                print getHelp()
            exit
        }

        # -r, -reference
        match(ARGV[pos], /^--?r(e(f(e(r(e(n(ce?)?)?)?)?)?)?)?$/)
        if (RSTART) {
            print getReference("endonym")
            exit
        }

        # -R, -reference-english
        match(ARGV[pos], /^--?(reference-(e(n(g(l(i(sh?)?)?)?)?)?)?|R)$/)
        if (RSTART) {
            print getReference("name")
            exit
        }

        # -D, -debug
        match(ARGV[pos], /^--?(debug|D)$/)
        if (RSTART) {
            Option["debug"] = 1
            continue
        }

        # -v, -verbose
        match(ARGV[pos], /^--?v(e(r(b(o(se?)?)?)?)?)?$/)
        if (RSTART) {
            Option["verbose"] = 1 # default value
            continue
        }

        # -b, -brief
        match(ARGV[pos], /^--?b(r(i(ef?)?)?)?$/)
        if (RSTART) {
            Option["verbose"] = 0
            continue
        }

        # -show-original [yes|no]
        match(ARGV[pos], /^--?show-original(=(.*)?)?$/, group)
        if (RSTART) {
            Option["show-original"] = yn(group[1] ? group[2] : ARGV[++pos])
            continue
        }

        # -show-original-phonetics [yes|no]
        match(ARGV[pos], /^--?show-original-phonetics(=(.*)?)?$/, group)
        if (RSTART) {
            Option["show-original-phonetics"] = yn(group[1] ? group[2] : ARGV[++pos])
            continue
        }

        # -show-translation [yes|no]
        match(ARGV[pos], /^--?show-translation(=(.*)?)?$/, group)
        if (RSTART) {
            Option["show-translation"] = yn(group[1] ? group[2] : ARGV[++pos])
            continue
        }

        # -show-translation-phonetics [yes|no]
        match(ARGV[pos], /^--?show-translation-phonetics(=(.*)?)?$/, group)
        if (RSTART) {
            Option["show-translation-phonetics"] = yn(group[1] ? group[2] : ARGV[++pos])
            continue
        }

        # -show-prompt-message [yes|no]
        match(ARGV[pos], /^--?show-prompt-message(=(.*)?)?$/, group)
        if (RSTART) {
            Option["show-prompt-message"] = yn(group[1] ? group[2] : ARGV[++pos])
            continue
        }

        # -show-languages [yes|no]
        match(ARGV[pos], /^--?show-languages(=(.*)?)?$/, group)
        if (RSTART) {
            Option["show-languages"] = yn(group[1] ? group[2] : ARGV[++pos])
            continue
        }

        # -show-original-dictionary [yes|no]
        match(ARGV[pos], /^--?show-original-dictionary(=(.*)?)?$/, group)
        if (RSTART) {
            Option["show-original-dictionary"] = yn(group[1] ? group[2] : ARGV[++pos])
            continue
        }

        # -show-dictionary [yes|no]
        match(ARGV[pos], /^--?show-dictionary(=(.*)?)?$/, group)
        if (RSTART) {
            Option["show-dictionary"] = yn(group[1] ? group[2] : ARGV[++pos])
            continue
        }

        # -show-alternatives [yes|no]
        match(ARGV[pos], /^--?show-alternatives(=(.*)?)?$/, group)
        if (RSTART) {
            Option["show-alternatives"] = yn(group[1] ? group[2] : ARGV[++pos])
            continue
        }

        # -no-ansi
        match(ARGV[pos], /^--?no-ansi/)
        if (RSTART) {
            Option["no-ansi"] = 1
            continue
        }

        # -w [num], -width [num]
        match(ARGV[pos], /^--?w(i(d(th?)?)?)?(=(.*)?)?$/, group)
        if (RSTART) {
            Option["width"] = group[4] ?
                (group[5] ? group[5] : Option["width"]) :
                ARGV[++pos]
            continue
        }

        # -indent [num]
        match(ARGV[pos], /^--?indent(=(.*)?)?$/, group)
        if (RSTART) {
            Option["indent"] = group[1] ?
                (group[2] ? group[2] : Option["indent"]) :
                ARGV[++pos]
            continue
        }

        # -browser [program]
        match(ARGV[pos], /^--?browser(=(.*)?)?$/, group)
        if (RSTART) {
            Option["browser"] = group[1] ?
                (group[2] ? group[2] : Option["browser"]) :
                ARGV[++pos]
            continue
        }

        # -p, -play
        match(ARGV[pos], /^--?p(l(ay?)?)?$/)
        if (RSTART) {
            Option["play"] = 1
            continue
        }

        # -player [program]
        match(ARGV[pos], /^--?player(=(.*)?)?$/, group)
        if (RSTART) {
            Option["play"] = 1
            Option["player"] = group[1] ?
                (group[2] ? group[2] : Option["player"]) :
                ARGV[++pos]
            continue
        }

        # -x [proxy], -proxy [proxy]
        match(ARGV[pos], /^--?(proxy|x)(=(.*)?)?$/, group)
        if (RSTART) {
            Option["proxy"] = group[2] ?
                (group[3] ? group[3] : Option["proxy"]) :
                ARGV[++pos]
            continue
        }

        # -I, -interactive
        match(ARGV[pos], /^--?(int(e(r(a(c(t(i(ve?)?)?)?)?)?)?)?|I)$/)
        if (RSTART) {
            Option["interactive"] = 1
            continue
        }

        # -no-rlwrap
        match(ARGV[pos], /^--?no-rlwrap/)
        if (RSTART) {
            Option["no-rlwrap"] = 1
            continue
        }

        # -E, -emacs
        match(ARGV[pos], /^--?(emacs|E)$/)
        if (RSTART) {
            Option["emacs"] = 1
            continue
        }

        # -prompt [prompt_string]
        match(ARGV[pos], /^--?prompt(=(.*)?)?$/, group)
        if (RSTART) {
            Option["prompt"] = group[1] ?
                (group[2] ? group[2] : Option["prompt"]) :
                ARGV[++pos]
            continue
        }

        # -prompt-color [color_code]
        match(ARGV[pos], /^--?prompt-color(=(.*)?)?$/, group)
        if (RSTART) {
            Option["prompt-color"] = group[1] ?
                (group[2] ? group[2] : Option["prompt-color"]) :
                ARGV[++pos]
            continue
        }

        # -i [file], -input [file]
        match(ARGV[pos], /^--?i(n(p(ut?)?)?)?(=(.*)?)?$/, group)
        if (RSTART) {
            Option["input"] = group[4] ?
                (group[5] ? group[5] : Option["input"]) :
                ARGV[++pos]
            continue
        }

        # -o [file], -output [file]
        match(ARGV[pos], /^--?o(u(t(p(ut?)?)?)?)?(=(.*)?)?$/, group)
        if (RSTART) {
            Option["output"] = group[5] ?
                (group[6] ? group[6] : Option["output"]) :
                ARGV[++pos]
            continue
        }

        # -l [code], -lang [code]
        match(ARGV[pos], /^--?l(a(ng?)?)?(=(.*)?)?$/, group)
        if (RSTART) {
            Option["hl"] = group[3] ?
                (group[4] ? group[4] : Option["hl"]) :
                ARGV[++pos]
            continue
        }

        # -s [code], -source [code]
        match(ARGV[pos], /^--?s(o(u(r(ce?)?)?)?)?(=(.*)?)?$/, group)
        if (RSTART) {
            Option["sl"] = group[5] ?
                (group[6] ? group[6] : Option["sl"]) :
                ARGV[++pos]
            continue
        }

        # -t [codes], -target [codes]
        match(ARGV[pos], /^--?t(a(r(g(et?)?)?)?)?(=(.*)?)?$/, group)
        if (RSTART) {
            if (group[5]) {
                if (group[6]) split(group[6], Option["tl"], "+")
            } else
                split(ARGV[++pos], Option["tl"], "+")
            continue
        }

        # Shortcut format
        # '[code]:[code]+...' or '[code]=[code]+...'
        match(ARGV[pos], /^[{(\[]?([[:alpha:]][[:alpha:]][[:alpha:]]?(-[[:alpha:]][[:alpha:]])?)?(:|=)((@?[[:alpha:]][[:alpha:]][[:alpha:]]?(-[[:alpha:]][[:alpha:]])?\+)*(@?[[:alpha:]][[:alpha:]][[:alpha:]]?(-[[:alpha:]][[:alpha:]])?)?)[})\]]?$/, group)
        if (RSTART) {
            if (group[1]) Option["sl"] = group[1]
            if (group[4]) split(group[4], Option["tl"], "+")
            continue
        }

        # --
        match(ARGV[pos], /^--$/)
        if (RSTART) {
            ++pos # skip the end-of-options option
            break # no more option from here
        }

        break # no more option from here
    }

    # Option parsing finished
    postInit()

    if (Option["interactive"] && !Option["no-rlwrap"]) {
        # Interactive mode
        initRlwrap() # initialize Rlwrap

        if (Rlwrap && (ENVIRON["TRANS_PROGRAM"] || fileExists(EntryPoint))) {
            command = Rlwrap " " Gawk " " (ENVIRON["TRANS_PROGRAM"] ?
                                           "\"${TRANS_PROGRAM}\"" :
                                           "-f " EntryPoint) " -" \
                " -no-rlwrap" # be careful - never fork Rlwrap recursively!
            for (i = 1; i < length(ARGV); i++)
                if (ARGV[i])
                    command = command " " parameterize(ARGV[i])

            if (!system(command))
                exit # child process finished, exit
            else
                ; # skip
        } else
            ; # skip

    } else if (!Option["interactive"] && !Option["no-rlwrap"] && Option["emacs"]) {
        # Emacs interface
        Emacs = "emacs"

        if (ENVIRON["TRANS_PROGRAM"] || fileExists(EntryPoint)) {
            params = ""
            for (i = 1; i < length(ARGV); i++)
                if (ARGV[i])
                    params = params " " (parameterize(ARGV[i], "\""))
            if (ENVIRON["TRANS_PROGRAM"]) {
                el = "(progn (setq trans-program (getenv \"TRANS_PROGRAM\")) " \
                    "(setq explicit-shell-file-name \"" Gawk "\") " \
                    "(setq explicit-" Gawk "-args (cons trans-program '(\"-\" \"-I\" \"-no-rlwrap\"" params "))) " \
                    "(command-execute 'shell) (rename-buffer \"" Name "\"))"
            } else {
                el = "(progn (setq explicit-shell-file-name \"" Gawk "\") " \
                    "(setq explicit-" Gawk "-args '(\"-f\" \"" EntryPoint "\" \"--\" \"-I\" \"-no-rlwrap\"" params ")) " \
                    "(command-execute 'shell) (rename-buffer \"" Name "\"))"
            }
            command = Emacs " --eval " parameterize(el)

            if (!system(command))
                exit # child process finished, exit
            else
                Option["interactive"] = 1 # skip
        } else
            Option["interactive"] = 1 # skip
    }

    if (Option["play"]) {
        # Initialize audio player or speech synthesizer
        if (!Option["player"]) {
            initAudioPlayer()
            Option["player"] = AudioPlayer ? AudioPlayer : Option["player"]
            if (!Option["player"])
                initSpeechSynthesizer()
        }

        if (!Option["player"] && !SpeechSynthesizer) {
            w("[WARNING] No available audio player or speech synthesizer is found.")
            Option["play"] = 0
        }
    }

    if (Option["interactive"]) {
        print AnsiCode["bold"] AnsiCode[tolower(Option["prompt-color"])] getVersion() AnsiCode[0] > "/dev/stderr"
        print AnsiCode[tolower(Option["prompt-color"])] "(:q to quit)" AnsiCode[0] > "/dev/stderr"
    }

    # Initialize browser
    if (!Option["browser"]) {
        "xdg-mime query default text/html 2>/dev/null" |& getline Option["browser"]
        match(Option["browser"], "(.*).desktop$", group)
        Option["browser"] = group[1]
    }

    # Disable ANSI SGR (Select Graphic Rendition) codes if required
    if (Option["no-ansi"])
        delete AnsiCode

    if (pos < ARGC) {
        # More parameters

        # Translate the remaining parameters
        for (i = pos; i < ARGC; i++) {
            # Verbose mode: separator between sources
            if (Option["verbose"] && i > pos)
                print replicate("═", Option["width"])

            translate(ARGV[i], 1) # inline mode
        }

        # If input not specified, we're done
    } else {
        # No more parameter besides options

        # If input not specified, use stdin
        if (!Option["input"]) Option["input"] = "/dev/stdin"
    }

    # If input specified, start translating
    if (Option["input"])
        translateMain()

    exit ExitCode
}
