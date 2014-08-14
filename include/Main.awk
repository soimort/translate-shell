####################################################################
# Main.awk                                                         #
####################################################################

# Detect gawk version.
function initGawk(    group) {
    Gawk = "gawk"
    GawkVersion = PROCINFO["version"]

    split(PROCINFO["version"], group, ".")
    if (group[1] < 3 || (group[1] == 3 && group[2] < 1)) {
        e("[ERROR] Oops! Your gawk (version " GawkVersion ") appears to be too old.\nYou need at least gawk 3.1 to run this script.")
        exit -1
    }
}

# Main initialization.
function init() {
    metainfo()

    # Commons
    initUrlEncoding()
    initAnsiCode()

    # Main
    initGawk()          #<< AnsiCode

    # Languages
    initBiDi()
    initLocale()
    initLocaleDisplay() #<< Locale, BiDi
    initUserLang()      #<< Locale

    # Translate
    initHttpService()

    RS = "\n"

    ExitCode = 0

    Option["debug"] = 0

    Option["verbose"] = 1
    Option["width"] = ENVIRON["COLUMNS"] ? ENVIRON["COLUMNS"] : 64

    Option["play"] = 0
    Option["player"] = ENVIRON["PLAYER"] ? ENVIRON["PLAYER"] : AudioPlayer

    Option["interactive"] = 0
    Option["no-rlwrap"] = 0
    Option["prompt"] = ENVIRON["TRANSLATE_PS"] ? ENVIRON["TRANSLATE_PS"] : "%s>"
    Option["prompt-color"] = ENVIRON["TRANSLATE_PS_COLOR"] ? ENVIRON["TRANSLATE_PS_COLOR"] : "blue"

    Option["input"] = ""
    Option["output"] = "/dev/stdout"

    Option["hl"] = ENVIRON["HOME_LANG"] ? ENVIRON["HOME_LANG"] : UserLang
    Option["sl"] = ENVIRON["SOURCE_LANG"] ? ENVIRON["SOURCE_LANG"] : "auto"
    Option["tl"][1] = ENVIRON["TARGET_LANG"] ? ENVIRON["TARGET_LANG"] : UserLang
}

# Main entry point.
BEGIN {
    init()

    pos = 0
    while (ARGV[++pos]) {
        # -, -no-op
        match(ARGV[pos], /^-(-?no-op)?$/)
        if (RSTART) continue

        # -V, -version
        match(ARGV[pos], /^--?(vers(i(on?)?)?|V)$/)
        if (RSTART) {
            print getVersion()
            exit
        }

        # -H, -help
        match(ARGV[pos], /^--?(help|H)$/)
        if (RSTART) {
            print getHelp("endonym")
            exit
        }

        # -h, -help-english
        match(ARGV[pos], /^--?(help-e(n(g(l(i(sh?)?)?)?)?)?|h)$/)
        if (RSTART) {
            print getHelp("name")
            exit
        }

        # -C, -code-reference
        match(ARGV[pos], /^--?(code(-(r(e(f(e(r(e(n(ce?)?)?)?)?)?)?)?)?)?|C)$/)
        if (RSTART) {
            print getCodeReference("code")
            exit
        }

        # -R, -reference
        match(ARGV[pos], /^--?(ref(e(r(e(n(ce?)?)?)?)?)?|R)$/)
        if (RSTART) {
            print getCodeReference("name")
            exit
        }

        # -d, -debug
        match(ARGV[pos], /^--?d(e(b(ug?)?)?)?$/)
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

        # -w [num], -width [num]
        match(ARGV[pos], /^--?w(i(d(th?)?)?)?(=(.*)?)?$/, group)
        if (RSTART) {
            Option["width"] = group[4] ?
                (group[5] ? group[5] : Option["width"]) :
                ARGV[++pos]
            continue
        }

        # -p, -play
        match(ARGV[pos], /^--?p(l(ay?)?)?$/)
        if (RSTART) {
            if (Option["player"] || SpeechSynthesizer)
                Option["play"] = 1
            else
                w("[WARNING] No available audio player or speech synthesizer is found.")
            continue
        }

        # -P [program], -player [program]
        match(ARGV[pos], /^--?(player|P)(=(.*)?)?$/, group)
        if (RSTART) {
            Option["play"] = 1
            Option["player"] = group[2] ?
                (group[3] ? group[3] : Option["player"]) :
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
        # '{[code]=[code]+...}'
        match(ARGV[pos], /^[{([]?([[:alpha:]][[:alpha:]][[:alpha:]]?(-[[:alpha:]][[:alpha:]])?)?(:|=)((@?[[:alpha:]][[:alpha:]][[:alpha:]]?(-[[:alpha:]][[:alpha:]])?\+)*(@?[[:alpha:]][[:alpha:]][[:alpha:]]?(-[[:alpha:]][[:alpha:]])?)?)[})\]]?$/, group)
        if (RSTART) {
            if (group[1]) Option["sl"] = group[1]
            if (group[4]) split(group[4], Option["tl"], "+")
            continue
        }

        break # no more option from here
    }

    # Option parsing finished
    # Enter interactive mode?
    if (Option["interactive"] && !Option["no-rlwrap"]) {
        # Initialize Rlwrap
        initRlwrap()

        # Try to call Rlwrap
        if (Rlwrap) {
            # Get current script name if possible
            getline temp < "/proc/self/cmdline"
            split(temp, group, "\0")

            # Be careful - never fork Rlwrap again in the next system call!
            command = Rlwrap " " Gawk " -f " (group[3] ? group[3] : Program) " -- -no-rlwrap"
            for (i = 1; i < length(ARGV); i++)
                if (ARGV[i])
                    command = command " " parameterize(ARGV[i])
            if (!system(command))
                exit # return from child process

            # Rlwrap failed, continue
        } else {
            # Rlwrap not found, continue
            # Don't warn users - their terminal might be fancier than you think (e.g. emacs)
        }
    }

    if (Option["play"]) {
        # Initialize audio player or speech synthesizer
        initAudioPlayer()
        if (!AudioPlayer) initSpeechSynthesizer()
    }

    if (pos < ARGC) {
        # More parameters

        # Translate the rest parameters
        for (i = pos; i < ARGC; i++) {
            # Verbose mode: separator between sources
            if (Option["verbose"] && i > pos)
                print replicate("═", Option["width"])

            translate(ARGV[i])
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
