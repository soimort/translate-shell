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

function setDefaultTheme() {
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
