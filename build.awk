#!/usr/bin/gawk -f

# Not all 4.x versions of gawk can handle @include without ".awk" extension
# But the build.awk script and the single build should support gawk 4.0+.
@include "include/Commons.awk"
@include "include/Utils.awk"
@include "include/Languages.awk"
@include "metainfo.awk"

function readFrom(file,    line, text) {
    if (!file) file = "/dev/stdin"
    text = NULLSTR
    while (getline line < file)
        text = (text ? text "\n" : NULLSTR) line
    return text
}

function writeTo(text, file) {
    if (!file) file = "/dev/stdout"
    print text > file
}

function getOutput(command,    content, line) {
    content = NULLSTR
    while ((command |& getline line) > 0)
        content = (content ? content "\n" : NULLSTR) line
    return content
}

function init() {
    BuildPath            = "build/"
    Trans                = BuildPath Command
    TransAwk             = Trans ".awk"

    ManPath              = "man/"
    Man                  = ManPath Command ".1"
    ManSource            = Man ".md"
    ManTemplate          = Man ".template.html"
    ManHtml              = Man ".html"

    PagesPath            = "gh-pages/"

    ReadmePath           = "./"
    ReadmeTemplate       = ReadmePath "README.template.md"
    Readme               = ReadmePath "README.md"

    WikiPath             = "wiki/"
    WikiLanguages        = WikiPath "Languages.md"
    WikiLanguagesHtml    = WikiLanguages ".html"

    RegistryPath         = "registry/"
    MainRegistryTemplate = RegistryPath "index.template.trans"
    MainRegistry         = RegistryPath "index.trans"
}

function man() {
    if (fileExists(ManTemplate))
        system("pandoc -s -t html --toc --toc-depth 1 --template " ManTemplate " " ManSource " -o " ManHtml)
    return system("pandoc -s -t man " ManSource " -o " Man)
}

function pages() {
    # TODO
}

function readme(    code, col, cols, content, group, i, j, language, r, rows, text) {
    text = readFrom(ReadmeTemplate)

    content = getOutput("gawk -f translate.awk -- -no-ansi -h")
    gsub(/\$usage\$/, content, text)

    initBiDi(); initLocale()
    rows = int(length(Locale) / 3) + 1
    cols[0][0] = cols[1][0] = cols[2][0] = NULLSTR
    i = 0
    saveSortedIn = PROCINFO["sorted_in"]
    PROCINFO["sorted_in"] = "compName"
    for (code in Locale) {
        col = int(i / rows)
        append(cols[col], code)
        i++
    }
    PROCINFO["sorted_in"] = saveSortedIn
    r = "| Language | Code | Language | Code | Language | Code |" RS \
        "| :------: | :--: | :------: | :--: | :------: | :--: |" RS
    for (i = 0; i < rows; i++) {
        r = r "| "
        for (j = 0; j < 3; j++)
            if (cols[j][i]) {
                split(getName(cols[j][i]), group, " ")
                language = group[1]
                r = r "**[" getName(cols[j][i]) "](" "http://en.wikipedia.org/wiki/" language "_language" ")** <br/> **" getEndonym(cols[j][i]) "** | **`" cols[j][i] "`** | "
            }
        r = r RS
    }
    gsub(/\$code-list\$/, r, text)

    writeTo(text, Readme)
    return 0
}

function wiki(    code, group, iso, language, saveSortedIn) {
    initBiDi(); initLocale()

    print "| Code | Name | Family | [Writing system](https://github.com/soimort/translate-shell/wiki/Writing-Systems-and-Fonts) | Is [RTL](http://en.wikipedia.org/wiki/Right-to-left)? | Has dictionary? |" > WikiLanguages
    print "| :--: | ---: | -----: | :------------: | :---------------------------------------------------: | :-------------: |" > WikiLanguages
    saveSortedIn = PROCINFO["sorted_in"]
    PROCINFO["sorted_in"] = "@ind_num_asc"
    for (code in Locale) {
        split(getISO(code), group, "-")
        iso = group[1]
        split(getName(code), group, " ")
        language = group[1]
        print sprintf("| **`%s`** <br/> [`%s`](%s) | **[%s](%s)** <br/> **%s** | %s | `%s` | %s | %s |",
                      getCode(code), iso, "http://www.ethnologue.com/language/" iso,
                      getName(code), "http://en.wikipedia.org/wiki/" language "_language", getEndonym(code),
                      getFamily(code), getScript(code),
                      isRTL(code) ? "✓" : NULLSTR,
                      hasDictionary(code) ? "✓" : NULLSTR) > WikiLanguages
    }
    PROCINFO["sorted_in"] = saveSortedIn

    return system("pandoc -s -t html " WikiLanguages " -o " WikiLanguagesHtml)
}

function doc() {
    man()
    pages()
    readme()
    wiki()
    return 0
}

function build(target, type,    group, inline, line, temp) {
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

        print "read -r -d '' TRANS_MANPAGE << 'EOF'" > Trans
        if (fileExists(Man))
            while (getline line < Man)
                print line > Trans
        print "EOF" > Trans
        print "export TRANS_MANPAGE" > Trans

        if (type == "release")
            print "export TRANS_BUILD=release" temp > Trans
        else {
            temp = getGitHead()
            if (temp)
                print "export TRANS_BUILD=git:" temp > Trans
        }

        print "export TRANS_ABSPATH=$(cd \"$(dirname \"$0\")\" && pwd)/$(basename \"$0\")" > Trans

        print "export COLUMNS=$(tput cols)" > Trans

        print "gawk -f <(echo -E \"$TRANS_PROGRAM\") - \"$@\"" > Trans

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
                                print inline > TransAwk
                } else {
                    if (temp == "Darwin" && line == "#!/usr/bin/gawk -f")
                        # OS X: gawk not in /usr/bin, use a better shebang
                        print "#!/usr/bin/env gawk -f" > TransAwk
                    else
                        print line > TransAwk
                }
            }

        ("chmod +x " parameterize(TransAwk)) | getline
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

function clean() {
    ("rm -f " BuildPath Command "*") | getline
    return 0
}

function release() {
    # TODO
    text = readFrom(MainRegistryTemplate)
    gsub(/\$Version\$/, Version, text)
    writeTo(text, MainRegistry)

    return 0
}

BEGIN {
    init()

    pos = 0
    while (ARGV[++pos]) {
        # -target TARGET
        match(ARGV[pos], /^--?target(=(.*)?)?$/, group)
        if (RSTART) {
            target = tolower(group[2] ? group[2] : ARGV[++pos])
            continue
        }

        # -type TYPE
        match(ARGV[pos], /^--?type(=(.*)?)?$/, group)
        if (RSTART) {
            type = tolower(group[2] ? group[2] : ARGV[++pos])
            continue
        }

        # TASK
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

        case "man":
            status = man()
            break

        case "pages":
            status = pages()
            break

        case "readme":
            status = readme()
            break

        case "wiki":
            status = wiki()
            break

        case "doc":
            status = doc()
            break

        case "build":
            status = build(target, type)
            break

        case "clean":
            status = clean()
            break

        case "release":
            status = release()
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
