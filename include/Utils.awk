####################################################################
# Utils.awk                                                        #
####################################################################

# Log any value if debugging is enabled.
function l(value, name) {
    if (Option["debug"]) {
        if (name)
            da(value, name)
        else
            d(value)
    }
}

# Return a log message if debugging is enabled.
function m(string) {
    if (Option["debug"])
        return ansi("cyan", string) RS
}
