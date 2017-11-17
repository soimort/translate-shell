#!/usr/bin/gawk -f

# Not all 4.x versions of gawk can handle @include without ".awk" extension
# But the build.awk script and the single build should support gawk 4.0+.
@include "include/Commons.awk"
@include "include/Utils.awk"
@include "include/Languages.awk"
@include "metainfo.awk"

function init() {
    BuildPath            = "build/"
    Trans                = BuildPath Command
    TransAwk             = Trans ".awk"

    ManPath              = "man/"
    Man                  = ManPath Command ".1"
    ManTemplate          = Man ".template.md"
    ManMarkdown          = Man ".md"
    ManHtmlTemplate      = Man ".template.html"
    ManHtml              = Man ".html"

    PagesPath            = "gh-pages/"
    BadgeDownload        = PagesPath "images/badge-download"
    BadgeRelease         = PagesPath "images/badge-release"
    Index                = PagesPath "index.md"

    ReadmePath           = "./"
    ReadmeTemplate       = ReadmePath "README.template.md"
    Readme               = ReadmePath "README.md"

    WikiPath             = "wiki/"
    WikiHome             = WikiPath "Home.md"
    WikiLanguages        = WikiPath "Languages.md"
    WikiLanguagesHtml    = WikiLanguages ".html"

    RegistryPath         = "registry/"
    MainRegistryTemplate = RegistryPath "index.template.trans"
    MainRegistry         = RegistryPath "index.trans"
}

function man(    text) {
    text = readFrom(ManTemplate)
    gsub(/\$Version\$/, Version, text)
    gsub(/\$ReleaseDate\$/, ReleaseDate, text)
    writeTo(text, ManMarkdown)

    if (fileExists(ManHtmlTemplate))
        system("pandoc -s -t html --toc --toc-depth 1 --template " ManHtmlTemplate " " ManMarkdown " -o " ManHtml)
    return system("pandoc -s -t man " ManMarkdown " -o " Man)
}

function readme(    code, col, cols, content, group, i, j, num, language, r, rows, text) {
    text = readFrom(ReadmeTemplate)

    content = getOutput("gawk -f translate.awk -- -no-ansi -h")
    gsub(/\$usage\$/, content, text)

    initBiDi(); initLocale()
    # number of language codes with stable support
    num = 0
    for (code in Locale)
        if (Locale[code]["support"] != "unstable")
            num++
    rows = int(num / 3) + (num % 3 ? 1 : 0)
    cols[0][0] = cols[1][0] = cols[2][0] = NULLSTR
    i = 0
    saveSortedIn = PROCINFO["sorted_in"]
    PROCINFO["sorted_in"] = "compName"
    for (code in Locale) {
        # Ignore unstable languages
        if (Locale[code]["support"] == "unstable") continue

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
                language = length(group) == 1 ? group[1] "_language" : join(group, "_")
                r = r "**[" getName(cols[j][i]) "](" "http://en.wikipedia.org/wiki/" language ")** <br/> **" getEndonym(cols[j][i]) "** | **`" cols[j][i] "`** | "
            }
        r = r RS
    }
    gsub(/\$code-list\$/, r, text)

    content = readFrom(WikiHome)
    gsub(/\$wiki-home\$/, content, text)

    writeTo(text, Readme)
    return 0
}

function wiki(    code, group, iso, language, saveSortedIn) {
    initBiDi(); initLocale()

    #print "***" length(Locale) "*** *languages in total. "
    print "*Generated from the source code of Translate Shell " Version ".*\n" > WikiLanguages
    print "*Version: [English](https://github.com/soimort/translate-shell/wiki/Languages) " \
        "| [Chinese Simplified](https://github.com/soimort/translate-shell/wiki/Languages-%28%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87%29)*\n" > WikiLanguages
    print "| Code | Name | Family | [Writing system](https://github.com/soimort/translate-shell/wiki/Writing-Systems-and-Fonts) | Is [RTL](http://en.wikipedia.org/wiki/Right-to-left)? | Has dictionary? |" > WikiLanguages
    print "| :--: | ---: | -----: | :------------: | :---------------------------------------------------: | :-------------: |" > WikiLanguages
    saveSortedIn = PROCINFO["sorted_in"]
    PROCINFO["sorted_in"] = "@ind_num_asc"
    for (code in Locale) {
        # Ignore unstable languages
        if (Locale[code]["support"] == "unstable") continue

        split(getISO(code), group, "-")
        iso = group[1]
        split(getName(code), group, " ")
        language = length(group) == 1 ? group[1] "_language" :
            group[2] ~ /^\(.*\)$/ ? group[1] "_language" : join(group, "_")
        print sprintf("| **`%s`** <br/> [`%s`](%s) | **[%s](%s)** <br/> **%s** | %s | `%s` | %s | %s |",
                      getCode(code), iso, "http://www.ethnologue.com/language/" iso,
                      getName(code), "http://en.wikipedia.org/wiki/" language, getEndonym(code),
                      getFamily(code), getScript(code),
                      isRTL(code) ? "✓" : NULLSTR,
                      hasDictionary(code) ? "✓" : NULLSTR) > WikiLanguages
    }
    PROCINFO["sorted_in"] = saveSortedIn

    return system("pandoc -s -t html " WikiLanguages " -o " WikiLanguagesHtml)
}

function doc() {
    man()
    readme()
    wiki()
    return 0
}

function readSqueezed(fileName, squeezed,    group, line, ret) {
    if (fileName ~ /\*$/) # glob simulation
        return readSqueezed(fileName ".awk", squeezed)

    ret = NULLSTR
    if (fileExists(fileName))
        while (getline line < fileName) {
            match(line, /^[[:space:]]*@include[[:space:]]*"(.*)"$/, group)
            if (RSTART) { # @include
                if (group[1] ~ /\.awk$/)
                    append(Includes, group[1])

                if (ret) ret = ret RS
                ret = ret readSqueezed(group[1], squeezed)
            } else if (!squeezed || line = squeeze(line)) { # effective LOC
                if (ret) ret = ret RS
                ret = ret line
            }
        }
    return ret
}

function build(target, type,    i, group, inline, line, temp) {
    # Default target: bash
    if (!target) target = "bash"

    ("mkdir -p " parameterize(BuildPath)) | getline

    if (target == "bash" || target == "zsh") {

        print "#!/usr/bin/env " target > Trans

        if (fileExists("DISCLAIMER")) {
            print "#" > Trans
            while (getline line < "DISCLAIMER")
                print "# " line > Trans
            print "#" > Trans
        }

        print "export TRANS_ENTRY=\"$0\"" > Trans
        print "if [[ ! $LANG =~ (UTF|utf)-?8$ ]]; then export LANG=en_US.UTF-8; fi" > Trans

        print "read -r -d '' TRANS_PROGRAM << 'EOF'" > Trans
        print readSqueezed(EntryPoint, TRUE) > Trans
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

        print "gawk -f <(echo -E \"$TRANS_PROGRAM\") - \"$@\"" > Trans

        ("chmod +x " parameterize(Trans)) | getline

        # Rebuild EntryScript
        print "#!/bin/sh" > EntryScript
        print "TRANS_DIR=`dirname $0`" > EntryScript
        print "gawk \\" > EntryScript
        for (i = 0; i < length(Includes) - 1; i++)
            print "-i \"${TRANS_DIR}/" Includes[i] "\" \\" > EntryScript
        print "-f \"${TRANS_DIR}/" Includes[i] "\" -- \"$@\"" > EntryScript
        ("chmod +x " parameterize(EntryScript)) | getline
        return 0

    } else if (target == "awk" || target == "gawk") {

        "uname -s" | getline temp
        print (temp == "Darwin" ?
               "#!/usr/bin/env gawk -f" : # macOS
               "#!/usr/bin/gawk -f") > TransAwk

        print readSqueezed(EntryPoint, TRUE) > TransAwk

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

function release(    content, group, sha1, size, temp, text) {
    d("Updating registry ...")
    # Update registry
    text = readFrom(MainRegistryTemplate)
    gsub(/\$Version\$/, Version, text)
    writeTo(text, MainRegistry)

    d("Updating gh-pages/images ...")
    # Update gh-pages/images/badge-release
    text = readFrom(BadgeRelease ".temp")
    gsub(/\$Version\$/, Version, text)
    writeTo(text, BadgeRelease)
    system("save-to-png " BadgeRelease)
    # Update gh-pages/images/badge-download
    ("wc -c " Trans) | getline temp
    split(temp, group)
    size = int(group[1] / 1000)
    text = readFrom(BadgeDownload ".temp")
    gsub(/\$Size\$/, size, text)
    writeTo(text, BadgeDownload)
    system("save-to-png " BadgeDownload)

    d("Updating gh-pages/index.md ...")
    # Update gh-pages/index.md
    ("sha1sum " Trans) | getline temp
    split(temp, group)
    sha1 = group[1]
    content = readFrom(Readme)
    text = readFrom(Index ".temp")
    gsub(/\$sha1\$/, sha1, text)
    gsub(/\$Version\$/, Version, text)
    gsub(/\$readme\$/, content, text)
    writeTo(text, Index)

    return 0
}

function test() {
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

        case "test":
            status = test()
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
