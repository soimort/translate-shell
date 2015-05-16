####################################################################
# Script.awk                                                       #
####################################################################

# Load options from the initialization script.
function loadOptions(script,    i, j, tokens, name, value) {
    tokenize(tokens, script)

    for (i in tokens) {
        if (tokens[i] ~ /^:/) {
            name = substr(tokens[i], 2)
            value = tokens[i + 1]

            if (value ~ /^[+-]?((0|[1-9][0-9]*)|[.][0-9]*|(0|[1-9][0-9]*)[.][0-9]*)([Ee][+-]?[0-9]+)?$/) {
                # Decimal number
                delete Option[name]
                Option[name] = value
            } else if (value == "false" || value == "true") {
                # Boolean
                delete Option[name]
                Option[name] = yn(value)
            } else if (value ~ /^".*"$/) {
                # String
                delete Option[name]
                Option[name] = literal(value)
            } else if (value == "[") {
                # List of strings
                delete Option[name]
                for (j = 1; tokens[i + j + 1] && tokens[i + j + 1] != "]"; j++) {
                    if (tokens[i + j + 1] ~ /^".*"$/)
                        Option[name][j] = literal(tokens[i + j + 1])
                    else {
                        e("[ERROR] Malformed configuration.")
                        return
                    }
                }
            } else {
                e("[ERROR] Malformed configuration.")
                return
            }
        }
    }
}

# Upgrade script.
function upgrade(    gitHead, i, newVersion, registry, tokens, trans) {
    if (!ENVIRON["TRANS_ABSPATH"]) {
        w("[ERROR] Not running from a single executable.")
        gitHead = getGitHead()
        if (gitHead)
            w("        Please try to upgrade via git commands.")
        else
            w("        Please download the latest release from here:" RS \
              "        https://github.com/soimort/translate-shell/releases")
        ExitCode = 1
        return
    }

    RegistryIndex = "https://raw.githubusercontent.com/soimort/translate-shell/registry/index.trans"
    TransExecutable = "http://www.soimort.org/translate-shell/trans"

    registry = curl(RegistryIndex)
    if (!registry) {
        e("[ERROR] Upgrading failed.")
        ExitCode = 1
        return
    }

    tokenize(tokens, registry)
    for (i in tokens)
        if (tokens[i] == ":translate-shell")
            newVersion = literal(tokens[i + 1])
    if (newerVersion(newVersion, Version)) {
        trans = curl(TransExecutable)
        if (trans) {
            print trans > ENVIRON["TRANS_ABSPATH"]
            print "Successfully upgraded to " newVersion "." > STDERR
        } else
            e("[ERROR] Upgrading failed due to network errors.")
    } else
        e("[ERROR] Already up-to-date.")
}
