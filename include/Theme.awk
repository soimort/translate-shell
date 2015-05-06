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
        Option["sgr-translation"] = "bold"
        Option["sgr-prompt-message-original"] = "underline"
        Option["sgr-original-dictionary-detailed-explanation"] = "bold"
        Option["sgr-original-dictionary-examples-original"][1] = "bold"
        Option["sgr-original-dictionary-examples-original"][2] = "negative"
        Option["sgr-original-dictionary-see-also-item"] = "underline"
        Option["sgr-dictionary-word"] = "bold"
        Option["sgr-alternatives-original"] = "underline"
        Option["sgr-alternatives-translation"] = "bold"
    }
}
