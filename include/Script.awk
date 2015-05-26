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
function upgrade(    i, newVersion, registry, tokens) {
    RegistryIndex = "https://raw.githubusercontent.com/soimort/translate-shell/registry/index.trans"

    registry = curl(RegistryIndex)
    if (!registry) {
        e("[ERROR] Failed to check for upgrade.")
        ExitCode = 1
        return
    }

    tokenize(tokens, registry)
    for (i in tokens)
        if (tokens[i] == ":translate-shell")
            newVersion = literal(tokens[i + 1])
    if (newerVersion(newVersion, Version)) {
        w("Current version: \t" Version)
        w("New version available: \t" newVersion)
        w("Download from: \t" "http://www.soimort.org/translate-shell/trans")
    } else {
        w("Current version: \t" Version)
        w("Already up-to-date.")
    }
}
