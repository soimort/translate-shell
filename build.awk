#!/usr/bin/gawk -f

# Not all 4.x versions of gawk can handle @include without ".awk" extension
# But the build.awk script and the single build should support gawk 4.0+.
@include "include/Commons.awk"
@include "metainfo.awk"

function init() {
    BuildPath = "build/"
    Trans     = BuildPath Command

    ManPath   = "man/"
    Man       = ManPath Command ".1"
    Ronn      = Man ".ronn"
    RonnStyle = ManPath "styles/night.css"
}

# Task: clean
function clean() {
    ("rm -f " BuildPath Command "*") | getline
    return 0
}

# Task: man
function man() {
    return system("ronn "                                               \
                  "--manual=" parameterize(toupper(Command) " MANUAL")  \
                  " --organization=" parameterize(Version)              \
                  " --style=" parameterize(RonnStyle)                   \
                  " " Ronn)
}

# Task: build
function build(target,    group, inline, line, temp) {
    # Default target: bash
    if (!target) target = "bash"

    ("mkdir -p " parameterize(BuildPath)) | getline

    if (target == "bash" || target == "zsh") {

        print "#!/usr/bin/env " target > Trans
        print > Trans

        print "read -r -d '' TRANS_PROGRAM << 'EOF'" > Trans
        if (fileExists(EntryPoint))
            while (getline line < EntryPoint) {
                match(line, /^[[:space:]]*@include[[:space:]]*"(.*)"$/, group)
                if (RSTART) {
                    # Include file
                    if (fileExists(group[1] ".awk"))
                        while (getline inline < (group[1] ".awk"))
                            if (inline = squeeze(inline))
                                print inline > Trans # effective LOC
                } else {
                    if (line && line !~ /^[[:space:]]*#!/) {
                        # Remove preceding spaces
                        gsub(/^[[:space:]]+/, "", line)
                        print line > Trans
                    }
                }
            }
        print "EOF" > Trans
        print "export TRANS_PROGRAM" > Trans

        print "read -r -d '' TRANS_MANPAGE << 'EOF'" > Trans
        if (fileExists(Man))
            while (getline line < Man)
                print line > Trans
        print "EOF" > Trans
        print "export TRANS_MANPAGE" > Trans

        print "export COLUMNS" > Trans

        print "gawk \"$TRANS_PROGRAM\" - \"$@\"" > Trans

        ("chmod +x " parameterize(Trans)) | getline
        return 0

    } else if (target == "awk" || target == "gawk") {

        "uname -s" | getline temp

        if (fileExists(EntryPoint))
            while (getline line < EntryPoint) {
                match(line, /^[[:space:]]*@include[[:space:]]*"(.*)"$/, group)
                if (RSTART) {
                    # Include file
                    if (fileExists(group[1] ".awk"))
                        while (getline inline < (group[1] ".awk"))
                            if (inline = squeeze(inline, 1))
                                print inline > Trans".awk"
                } else {
                    if (temp == "Darwin" && line == "#!/usr/bin/gawk -f")
                        # OS X: gawk not in /usr/bin, use a better shebang
                        print "#!/usr/bin/env gawk -f" > Trans".awk"
                    else
                        print line > Trans".awk"
                }
            }

        ("chmod +x " parameterize(Trans".awk")) | getline
        return 0

    } else {

        w("[FAILED] Unknown target: " ansi("underline", target))
        w("         Supported targets: "                                \
          ansi("underline", "bash") ", "                                \
          ansi("underline", "zsh") ", "                                 \
          ansi("underline", "gawk"))
        return 1

    }
}

BEGIN {
    init()

    pos = 0
    while (ARGV[++pos]) {
        # -target [target]
        match(ARGV[pos], /^--?target(=(.*)?)?$/, group)
        if (RSTART) {
            target = tolower(group[2] ? group[2] : ARGV[++pos])
            continue
        }

        # [task]
        match(ARGV[pos], /^[^\-]/, group)
        if (RSTART) {
            append(tasks, ARGV[pos])
            continue
        }
    }

    # Default task: build
    if (!anything(tasks)) tasks[0] = "build"

    for (i = 0; i < length(tasks); i++) {
        task = tasks[i]
        status = 0
        switch (task) {

        case "clean":
            status = clean()
            break

        case "man":
            status = man()
            break

        case "build":
            status = build(target)
            break

        default: # unknown task
            status = -1
        }

        if (status == 0) {
            d("[OK] Task " ansi("bold", task) " completed.")
        } else if (status < 0) {
            w("[FAILED] Unknown task: " ansi("bold", task))
            exit 1
        } else {
            w("[FAILED] Task " ansi("bold", task) " failed.")
            exit 1
        }
    }
}
