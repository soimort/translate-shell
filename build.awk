#!/usr/bin/gawk -f

@include "include/Commons"
@include "metainfo"

function init() {
    BuildPath = "build/"
    Trans     = BuildPath Command

    ManPath   = "man/"
    Ronn      = ManPath Command ".1.ronn"
    RonnStyle = ManPath "styles/night.css"
    Man       = ManPath Command ".1"
}

# Task: clean
function clean() {
    ("rm -fr " parameterize(BuildPath)) | getline
    return 0
}

# Task: man
function man() {
    return system("ronn --manual=" parameterize(toupper(Command) " MANUAL") \
                  " --organization=" parameterize(Version) \
                  " --style=" parameterize(RonnStyle) \
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
                        while (getline inline < (group[1] ".awk")) {
                            if (inline = squeeze(inline))
                                print inline > Trans # effective LOC
                        }
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

        w("[FAILED] Unknown target: " AnsiCode["underline"] target AnsiCode["no underline"])
        w("         Supported targets: " \
          AnsiCode["underline"] "bash" AnsiCode["no underline"] ", " \
          AnsiCode["underline"] "zsh" AnsiCode["no underline"] ", " \
          AnsiCode["underline"] "gawk" AnsiCode["no underline"])
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
            d("[OK] Task " AnsiCode["bold"] task AnsiCode["no bold"] " completed.")
        } else if (status < 0) {
            w("[FAILED] Unknown task: " AnsiCode["bold"] task AnsiCode["no bold"])
            exit 1
        } else {
            w("[FAILED] Task " AnsiCode["bold"] task AnsiCode["no bold"] " failed.")
            exit 1
        }
    }
}
