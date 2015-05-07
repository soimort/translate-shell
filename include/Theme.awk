####################################################################
# Theme.awk                                                        #
####################################################################

function prettify(name, string,    i, temp) {
    temp = string
    if ("sgr-" name in Option)
        if (isarray(Option["sgr-" name]))
            for (i in Option["sgr-" name])
                temp = ansi(Option["sgr-" name][i], temp)
        else
            temp = ansi(Option["sgr-" name], temp)
    return temp
}

function randomColor(    i) {
    i = int(5 * rand())
    switch (i) {
    case 0: return "green"
    case 1: return "yellow"
    case 2: return "blue"
    case 3: return "magenta"
    case 4: return "cyan"
    default: return "default"
    }
}

function setRandomTheme(    i, n, temp) {
    srand(systime())
    for (i = 0; i < 3; i++) {
        do temp = randomColor(); while (belongsTo(temp, n))
        n[i] = temp
    }

    Option["sgr-prompt-message"] = Option["sgr-languages"] = n[0]
    Option["sgr-original-dictionary-detailed-word-class"][1] = n[0]
    Option["sgr-original-dictionary-detailed-word-class"][2] = "bold"
    Option["sgr-original-dictionary-synonyms"] = n[0]
    Option["sgr-original-dictionary-synonyms-word-class"][1] = n[0]
    Option["sgr-original-dictionary-synonyms-word-class"][2] = "bold"
    Option["sgr-original-dictionary-examples"] = n[0]
    Option["sgr-original-dictionary-see-also"] = n[0]
    Option["sgr-dictionary-word-class"][1] = n[0]
    Option["sgr-dictionary-word-class"][2] = "bold"

    Option["sgr-original"][1] = Option["sgr-original-phonetics"][1] = n[1]
    Option["sgr-original"][2] = Option["sgr-original-phonetics"][2] = "bold"
    Option["sgr-prompt-message-original"][1] = n[1]
    Option["sgr-prompt-message-original"][2] = "bold"
    Option["sgr-languages-sl"] = n[1]
    Option["sgr-original-dictionary-detailed-explanation"][1] = n[1]
    Option["sgr-original-dictionary-detailed-explanation"][2] = "bold"
    Option["sgr-original-dictionary-detailed-example"] = n[1]
    Option["sgr-original-dictionary-detailed-synonyms"] = n[1]
    Option["sgr-original-dictionary-detailed-synonyms-item"][1] = n[1]
    Option["sgr-original-dictionary-detailed-synonyms-item"][2] = "bold"
    Option["sgr-original-dictionary-synonyms-synonyms"] = n[1]
    Option["sgr-original-dictionary-synonyms-synonyms-item"][1] = n[1]
    Option["sgr-original-dictionary-synonyms-synonyms-item"][2] = "bold"
    Option["sgr-original-dictionary-examples-example"] = n[1]
    Option["sgr-original-dictionary-examples-original"][1] = n[1]
    Option["sgr-original-dictionary-examples-original"][2] = "bold"
    Option["sgr-original-dictionary-examples-original"][3] = "underline"
    Option["sgr-original-dictionary-see-also-phrases"] = n[1]
    Option["sgr-original-dictionary-see-also-phrases-item"][1] = n[1]
    Option["sgr-original-dictionary-see-also-phrases-item"][2] = "bold"
    Option["sgr-dictionary-explanation"] = n[1]
    Option["sgr-dictionary-explanation-item"][1] = n[1]
    Option["sgr-dictionary-explanation-item"][2] = "bold"
    Option["sgr-alternatives-original"][1] = n[1]
    Option["sgr-alternatives-original"][2] = "bold"

    Option["sgr-translation"][1] = Option["sgr-translation-phonetics"][1] = n[2]
    Option["sgr-translation"][2] = Option["sgr-translation-phonetics"][2] = "bold"
    Option["sgr-languages-tl"] = n[2]
    Option["sgr-dictionary-word"][1] = n[2]
    Option["sgr-dictionary-word"][2] = "bold"
    Option["sgr-alternatives-translations"] = n[2]
    Option["sgr-alternatives-translations-item"][1] = n[2]
    Option["sgr-alternatives-translations-item"][2] = "bold"
    Option["sgr-brief-translation"][1] = Option["sgr-brief-translation-phonetics"][1] = n[2]
    Option["sgr-brief-translation"][2] = Option["sgr-brief-translation-phonetics"][2] = "bold"
}

function setDefaultTheme() {
    Option["sgr-translation"] = Option["sgr-translation-phonetics"] = "bold"
    Option["sgr-prompt-message-original"] = "underline"
    Option["sgr-languages-sl"] = "underline"
    Option["sgr-languages-tl"] = "bold"
    Option["sgr-original-dictionary-detailed-explanation"] = "bold"
    Option["sgr-original-dictionary-detailed-synonyms-item"] = "bold"
    Option["sgr-original-dictionary-synonyms-synonyms-item"] = "bold"
    Option["sgr-original-dictionary-examples-original"][1] = "bold"
    Option["sgr-original-dictionary-examples-original"][2] = "underline"
    Option["sgr-original-dictionary-see-also-phrases-item"] = "bold"
    Option["sgr-dictionary-word"] = "bold"
    Option["sgr-alternatives-original"] = "underline"
    Option["sgr-alternatives-translations-item"] = "bold"
}

function setTheme(    file, line, script) {
    if (Option["theme"] && Option["theme"] != "default") {
        file = Option["theme"]
        if (!fileExists(file))
            file = ENVIRON["HOME"] "/.translate-shell/" Option["theme"]
    }

    if (file && fileExists(file)) {
        # Read from theme file
        script = NULLSTR
        while (getline line < file)
            script = script "\n" line
        loadOptions(script)
    } else if (Option["theme"] == "none")
        ;# skip
    else if (Option["theme"] == "random")
        setRandomTheme()
    else
        setDefaultTheme()
}
