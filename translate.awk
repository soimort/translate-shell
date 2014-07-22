#!/usr/bin/gawk -f

function help() {
    print "Usage: translate {[source]=[target]} text ...\n" \
        "       translate {[source]=[target1]+[target2]+...} text ...\n" \
        "       translate text ...\n\n" \
        "Language codes for [source] and [target]:\n" \
            "┌───────────────────────┬─────────────────────┬─────────────────┐\n" \
    "│ Afrikaans     - \33[1maf\33[21m    │ Georgian       - \33[1mka\33[21m │ Persian    - \33[1mfa\33[21m │\n" \
    "│ Albanian      - \33[1msq\33[21m    │ German         - \33[1mde\33[21m │ Polish     - \33[1mpl\33[21m │\n" \
    "│ Arabic        - \33[1mar\33[21m    │ Greek          - \33[1mel\33[21m │ Portuguese - \33[1mpt\33[21m │\n" \
    "│ Azerbaijani   - \33[1maz\33[21m    │ Gujarati       - \33[1mgu\33[21m │ Romanian   - \33[1mro\33[21m │\n" \
    "│ Basque        - \33[1meu\33[21m    │ Haitian Creole - \33[1mht\33[21m │ Russian    - \33[1mru\33[21m │\n" \
    "│ Bengali       - \33[1mbn\33[21m    │ Hebrew         - \33[1miw\33[21m │ Serbian    - \33[1msr\33[21m │\n" \
    "│ Belarusian    - \33[1mbe\33[21m    │ Hindi          - \33[1mhi\33[21m │ Slovak     - \33[1msk\33[21m │\n" \
    "│ Bulgarian     - \33[1mbg\33[21m    │ Hungarian      - \33[1mhu\33[21m │ Slovenian  - \33[1msl\33[21m │\n" \
    "│ Catalan       - \33[1mca\33[21m    │ Icelandic      - \33[1mis\33[21m │ Spanish    - \33[1mes\33[21m │\n" \
    "│ Chinese Simp. - \33[1mzh-CN\33[21m │ Indonesian     - \33[1mid\33[21m │ Swahili    - \33[1msw\33[21m │\n" \
    "│ Chinese Trad. - \33[1mzh-TW\33[21m │ Irish          - \33[1mga\33[21m │ Swedish    - \33[1msv\33[21m │\n" \
    "│ Croatian      - \33[1mhr\33[21m    │ Italian        - \33[1mit\33[21m │ Tamil      - \33[1mta\33[21m │\n" \
    "│ Czech         - \33[1mcs\33[21m    │ Japanese       - \33[1mja\33[21m │ Telugu     - \33[1mte\33[21m │\n" \
    "│ Danish        - \33[1mda\33[21m    │ Kannada        - \33[1mkn\33[21m │ Thai       - \33[1mth\33[21m │\n" \
    "│ Dutch         - \33[1mnl\33[21m    │ Korean         - \33[1mko\33[21m │ Turkish    - \33[1mtr\33[21m │\n" \
    "│ English       - \33[1men\33[21m    │ Latin          - \33[1mla\33[21m │ Ukrainian  - \33[1muk\33[21m │\n" \
    "│ Esperanto     - \33[1meo\33[21m    │ Latvian        - \33[1mlv\33[21m │ Urdu       - \33[1mur\33[21m │\n" \
    "│ Estonian      - \33[1met\33[21m    │ Lithuanian     - \33[1mlt\33[21m │ Vietnamese - \33[1mvi\33[21m │\n" \
    "│ Filipino      - \33[1mtl\33[21m    │ Macedonian     - \33[1mmk\33[21m │ Welsh      - \33[1mcy\33[21m │\n" \
    "│ Finnish       - \33[1mfi\33[21m    │ Malay          - \33[1mms\33[21m │ Yiddish    - \33[1myi\33[21m │\n" \
    "│ French        - \33[1mfr\33[21m    │ Maltese        - \33[1mmt\33[21m │                 │\n" \
    "│ Galician      - \33[1mgl\33[21m    │ Norwegian      - \33[1mno\33[21m │                 │\n" \
    "└───────────────────────┴─────────────────────┴─────────────────┘"
}

BEGIN {
    if (ARGC < 2) {
        help()
        exit
    }

    RS = ORS = "\r\n"
    FS = OFS = "\n"
    httpProtocol = "http://"
    httpHost = "translate.google.com"
    httpPort = 80
    httpService = "/inet/tcp/0/" httpHost "/" httpPort
    urlEncoding["\n"] = "%0A"
    urlEncoding[" "]  = "%20"
    urlEncoding["\""] = "%22"
    urlEncoding["&"]  = "%26"

    match(ARGV[1], /^[{([]?([a-z][a-z](-[A-Z][A-Z])?)?=((@?[a-z][a-z](-[A-Z][A-Z])?\+)*(@?[a-z][a-z](-[A-Z][A-Z])?)?)[})\]]?$/, param)
    text_p = RSTART
    sl = param[1] == "" ? "auto" : param[2]
    split(param[3], tls, "+")
    if (length(tls) == 0) tls[1] = ""

    while (ARGV[++text_p]) {
        $0 = ""
        getline < ARGV[text_p]
        if (NF)
            split($0, texts)
        else
            split(ARGV[text_p], texts)
        n = length(texts)

        for (tls_i = 1; tls_i <= length(tls); tls_i++) {
            tl = ((tls[tls_i] == "") ? "auto" : tls[tls_i])
            tl = substr(tl, 1 + (showPhonetically = index(tl, "@")))

            for (texts_i = 1; texts_i <= n; texts_i++) {
                text = texts[texts_i]
                for (key in urlEncoding)
                    gsub(key, urlEncoding[key], text)

                url = httpProtocol httpHost "/translate_a/t?client=t&ie=UTF-8&oe=UTF-8" \
                    "&sl=" sl "&tl=" tl "&text=" text

                print "GET " url |& httpService
                while ((httpService |& getline) > 0)
                    content = $0
                close(httpService)

                translation = phonetics = ""
                match(content, /\]\]/)
                s0 = substr(content, 3, RSTART - 2)
                while (s0 != "") {
                    match(s0, /\[[^\]]*\]/)
                    t0 = substr(s0, RSTART + 1, RLENGTH - 2)
                    s0 = substr(s0, RLENGTH + 2)

                    for (i = 0; t0 != ""; i++) {
                        match(t0, /[^\\]","/)
                        f[i] = substr(t0, 2, RSTART - 1)
                        t0 = substr(t0, RSTART + 3)
                    }

                    translation = translation f[0]
                    phonetics = phonetics ((f[2] != "") ? (f[2] " ") : f[0])
                }

                output = showPhonetically ? phonetics : translation
                output = gensub(/\\( |\\|\")/, "\\1", "g", output)
                output = gensub(/\\n/, "\n", "g", output)
                output = gensub(/(\") /, "\\1", "g", output)
                output = gensub(/ ('|;|:|\.|\,|\!|\?)/, "\\1", "g", output)
                printf output "\n"
            }
        }
    }
}
