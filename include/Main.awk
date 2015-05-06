####################################################################
# Main.awk                                                         #
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

# Initialization #0. (prior to option parsing)
function init0() {
    initGawk()          #<< Commons.awk/AnsiCode

    # Languages.awk
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

    Option["no-ansi"] = 0

    Option["width"] = ENVIRON["COLUMNS"] ? ENVIRON["COLUMNS"] : 64
    Option["indent"] = 4

    Option["view"] = 0
    Option["pager"] = ENVIRON["PAGER"]

    Option["browser"] = ENVIRON["BROWSER"]

    Option["play"] = 0
    Option["player"] = ENVIRON["PLAYER"]

    Option["proxy"] = ENVIRON["HTTP_PROXY"] ? ENVIRON["HTTP_PROXY"] : ENVIRON["http_proxy"]
    Option["user-agent"] = ENVIRON["USER_AGENT"]

    Option["interactive"] = 0
    Option["no-rlwrap"] = 0
    Option["emacs"] = 0
    Option["prompt"] = ENVIRON["TRANS_PS"] ? ENVIRON["TRANS_PS"] : "%s>"
    Option["prompt-color"] = ENVIRON["TRANS_PS_COLOR"] ? ENVIRON["TRANS_PS_COLOR"] : "default"

    Option["input"] = NULLSTR
    Option["output"] = STDOUT

    Option["hl"] = ENVIRON["HOME_LANG"] ? ENVIRON["HOME_LANG"] : UserLang
    Option["sl"] = ENVIRON["SOURCE_LANG"] ? ENVIRON["SOURCE_LANG"] : "auto"
    Option["tl"][1] = ENVIRON["TARGET_LANG"] ? ENVIRON["TARGET_LANG"] : UserLang

    Option["theme"] = "default"
}

# Initialization script.
function initScript(    file, line, script) {
    if (belongsTo("-no-init", ARGV) || belongsTo("--no-init", ARGV))
        return

    # Find the initialization file
    file = "init.trans"
    if (!fileExists(file)) {
        file = "translate-shell"
        if (!fileExists(file)) {
            file = ENVIRON["HOME"] "/.init.trans"
            if (!fileExists(file)) {
                file = ENVIRON["HOME"] "/.translate-shell"
                if (!fileExists(file)) {
                    file = ENVIRON["HOME"] "/.translate-shell/init.trans"
                    if (!fileExists(file)) {
                        file = "/etc/translate-shell"
                        if (!fileExists(file)) return
                    }
                }
            }
        }
    }

    script = NULLSTR
    while (getline line < file)
        script = script "\n" line
    loadOptions(script)
}

# Initialization #2. (prior to interactive mode handling)
function init2() {
    # Set theme
    setTheme()

    # Disable ANSI escape codes if required
    if (Option["no-ansi"])
        delete AnsiCode
}

# Initialization #3.
function init3(    group) {
    # Translate.awk
    initHttpService()

    # Initialize pager
    if (Option["view"]) {
        if (!Option["pager"]) {
            initPager()
            Option["pager"] = Pager
        }

        if (!Option["pager"]) {
            w("[WARNING] No available terminal pager.")
            Option["view"] = 0
        }
    }

    # Initialize browser
    if (!Option["browser"]) {
        "xdg-mime query default text/html" SUPERR |& getline Option["browser"]
        match(Option["browser"], "(.*).desktop$", group)
        Option["browser"] = group[1]
    }

    # Initialize audio player or speech synthesizer
    if (Option["play"]) {
        if (!Option["player"]) {
            initAudioPlayer()
            Option["player"] = AudioPlayer ? AudioPlayer : Option["player"]
            if (!Option["player"])
                initSpeechSynthesizer()
        }

        if (!Option["player"] && !SpeechSynthesizer) {
            w("[WARNING] No available audio player or speech synthesizer.")
            Option["play"] = 0
        }
    }
}

# Main entry point.
BEGIN {
    init0() # initialization #0
    initScript() # initialization script

    # Option parsing
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
            printf("%-22s%s\n", "User Language", getName(UserLang) " (" getDisplay(UserLang) ")")
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
            man()
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

        # -verbose
        match(ARGV[pos], /^--?verbose$/)
        if (RSTART) {
            Option["verbose"] = 1 # default value
            continue
        }

        # -d, -dictionary
        match(ARGV[pos], /^--?d(i(c(t(i(o(n(a(ry?)?)?)?)?)?)?)?)?$/)
        if (RSTART) {
            Option["show-original-dictionary"] = 1
            Option["show-dictionary"] = 0
            Option["show-alternatives"] = 0
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

        # -theme [theme]
        match(ARGV[pos], /^--?theme(=(.*)?)?$/, group)
        if (RSTART) {
            Option["theme"] = group[1] ?
                (group[2] ? group[2] : Option["theme"]) :
                ARGV[++pos]
            continue
        }

        # -no-ansi
        match(ARGV[pos], /^--?no-ansi$/)
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

        # -v, -view
        match(ARGV[pos], /^--?v(i(ew?)?)?$/)
        if (RSTART) {
            Option["view"] = 1
            continue
        }

        # -pager [program]
        match(ARGV[pos], /^--?pager(=(.*)?)?$/, group)
        if (RSTART) {
            Option["view"] = 1
            Option["pager"] = group[1] ?
                (group[2] ? group[2] : Option["pager"]) :
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

        # -u [agent], -user-agent [agent]
        match(ARGV[pos], /^--?(user-agent|u)(=(.*)?)?$/, group)
        if (RSTART) {
            Option["user-agent"] = group[2] ?
                (group[3] ? group[3] : Option["user-agent"]) :
                ARGV[++pos]
            continue
        }

        # -I, -interactive, -shell
        match(ARGV[pos], /^--?(int(e(r(a(c(t(i(ve?)?)?)?)?)?)?)?|shell|I)$/)
        if (RSTART) {
            Option["interactive"] = 1
            continue
        }

        # -no-rlwrap
        match(ARGV[pos], /^--?no-rlwrap$/)
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

        # -no-init
        match(ARGV[pos], /^--?no-init/)
        if (RSTART) continue

        # --
        match(ARGV[pos], /^--$/)
        if (RSTART) {
            ++pos # skip the end-of-options option
            break # no more option from here
        }

        break # no more option from here
    }

    init2() # initialization #2

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

    if (Option["interactive"]) {
        print AnsiCode["bold"] AnsiCode[tolower(Option["prompt-color"])] getVersion() AnsiCode[0] > STDERR
        print AnsiCode[tolower(Option["prompt-color"])] "(:q to quit)" AnsiCode[0] > STDERR
    }

    init3() # initialization #3

    if (pos < ARGC) {
        # More parameters

        # Translate remaining parameters
        for (i = pos; i < ARGC; i++) {
            # Verbose mode: separator between sources
            if (Option["verbose"] && i > pos)
                p(replicate(Option["chr-source-seperator"], Option["width"]))

            translate(ARGV[i], 1) # inline mode
        }

        # If input not specified, we're done
    } else {
        # No more parameter besides options

        # If input not specified, use stdin
        if (!Option["input"]) Option["input"] = STDIN
    }

    # If input specified, start translating
    if (Option["input"])
        translateMain()

    exit ExitCode
}
