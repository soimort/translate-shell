####################################################################
# Theme.awk                                                        #
####################################################################

function prettify(name, string,    i, temp) {
    temp = string
    if ("sgr-" name in Option)
        for (i in Option["sgr-" name])
            temp = ansi(Option["sgr-" name][i], temp)
    return temp
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
    } else {
        # Default theme
        Option["sgr-original"][1] = "bold"
        Option["sgr-original"][2] = "negative"
        Option["sgr-translation"][1] = "bold"
        Option["sgr-prompt-message-original"][1] = "underline"
        Option["sgr-original-dictionary-detailed-explanation"][1] = "bold"
        Option["sgr-original-dictionary-examples-original"][1] = "bold"
        Option["sgr-original-dictionary-examples-original"][2] = "negative"
        Option["sgr-original-dictionary-see-also-item"][1] = "underline"
        Option["sgr-dictionary-word"][1] = "bold"
        Option["sgr-alternatives-original"][1] = "underline"
        Option["sgr-alternatives-translation"][1] = "bold"
    }
}
