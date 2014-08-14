#!/usr/bin/gawk -f

@include "lib/Commons"
@include "lib/PLTokenizer"
@include "lib/PLParser"

# Get the translation of a string.
function getTranslation(text, sl, tl, hl,
                        isVerbose, toSpeech, returnPlaylist,
                        ####
                        altTranslations, article, ast, content,
                        explanation, group, i, il,
                        isPhonetic, j, original, phonetics,
                        r, rtl, saveSortedIn, segments,
                        temp, tokens, translation, translations,
                        word, words, wordClasses) {
    isPhonetic = match(tl, /^@/)
    tl = substr(tl, 1 + isPhonetic)

    if (!getCode(tl)) {
        # Check if target language is supported
        w("[WARNING] Unknown target language code: " tl)
    } else if (rtl = Locale[getCode(tl)]["rtl"]) {
        # Check if target language is RTL
        if (!FriBidi)
            w("[WARNING] " Locale[getCode(tl)]["name"] " is a right-to-left language, but GNU FriBidi is not found on your system.\nText might be displayed incorrectly.")
    }

    content = getResponse(text, sl, tl, hl)

    plTokenize(tokens, content)
    plParse(ast, tokens)

    if (!anything(ast)) {
        e("[ERROR] Oops! Something went wrong and I can't translate it for you :(")
        ExitCode = 1
    }

    # Debug mode
    if (Option["debug"]) {
        d(sprintf("content='%s'", content))
        da(tokens, "tokens[%s]='%s'")
        da(ast, "ast[%s]='%s'")
    }

    saveSortedIn = PROCINFO["sorted_in"]
    PROCINFO["sorted_in"] = "@ind_num_asc"
    for (i in ast) {
        if (i ~ "^0" SUBSEP "0" SUBSEP "[[:digit:]]+" SUBSEP "0$")
            append(translations, postprocess(literal(ast[i])))
        if (i ~ "^0" SUBSEP "0" SUBSEP "[[:digit:]]+" SUBSEP "1$")
            append(original, literal(ast[i]))
        if (i ~ "^0" SUBSEP "0" SUBSEP "[[:digit:]]+" SUBSEP "2$")
            append(phonetics, literal(ast[i]))

        if (match(i, "^0" SUBSEP "1" SUBSEP "([[:digit:]]+)" SUBSEP "0$", group))
            wordClasses[group[1]] = literal(ast[i])

        if (match(i, "^0" SUBSEP "1" SUBSEP "([[:digit:]]+)" SUBSEP "2" SUBSEP "([[:digit:]]+)" SUBSEP "([[:digit:]]+)$", group))
            words[group[1]][group[2]][group[3]] = literal(ast[i])
        if (match(i, "^0" SUBSEP "1" SUBSEP "([[:digit:]]+)" SUBSEP "2" SUBSEP "([[:digit:]]+)" SUBSEP "1" SUBSEP "([[:digit:]]+)$", group))
            words[group[1]][group[2]]["1"][group[3]] = literal(ast[i])

        if (match(i, "^0" SUBSEP "5" SUBSEP "([[:digit:]]+)" SUBSEP "0$", group))
            segments[group[1]] = literal(ast[i])

        if (match(i, "^0" SUBSEP "5" SUBSEP "([[:digit:]]+)" SUBSEP "2" SUBSEP "([[:digit:]]+)" SUBSEP "0$", group))
            altTranslations[group[1]][group[2]] = postprocess(literal(ast[i]))

        # Identified source languages
        if (i ~ "^0" SUBSEP "8" SUBSEP "0" SUBSEP "[[:digit:]]+$")
            append(il, literal(ast[i]))
    }
    PROCINFO["sorted_in"] = saveSortedIn

    translation = join(translations)

    if (!anything(il)) il[0] = sl

    # Generate output
    if (!isVerbose) {
        # Brief mode

        r = isPhonetic && anything(phonetics) ?
            join(phonetics) :  # phonetic transcription
            s(translation, tl) # target language

        if (toSpeech) {
            returnPlaylist[0]["text"] = translation
            returnPlaylist[0]["tl"] = tl
        }

    } else {
        # Verbose mode

        r = AnsiCode["bold"] s(translation, tl) AnsiCode["no bold"] # target language
        if (anything(phonetics))
            r = r "\n" AnsiCode["bold"] join(phonetics) AnsiCode["no bold"] # phonetic transcription

        if (anything(altTranslations[0])) {
            # List alternative translations

            if (Locale[getCode(hl)]["rtl"] || Locale[getCode(il[0])]["rtl"])
                r = r "\n\n" s(sprintf(Locale[getCode(hl)]["message"], join(original))) # caution: mixed languages, BiDi invoked must be implemented correctly (i.e. FriBidi is required)
            else
                r = r "\n\n" sprintf(Locale[getCode(hl)]["message"], join(original))
            if (Locale[getCode(il[0])]["rtl"] || Locale[getCode(tl)]["rtl"])
                r = r "\n" s("(" Locale[getCode(il[0])]["endonym"] " ➔ " Locale[getCode(tl)]["endonym"] ")") # caution: mixed languages
            else
                r = r "\n" "(" Locale[getCode(il[0])]["endonym"] " ➔ " Locale[getCode(tl)]["endonym"] ")"

            temp = segments[0] "(" join(altTranslations[0], "/") ")"
            for (i = 1; i < length(altTranslations); i++)
                temp = temp " " segments[i] "(" join(altTranslations[i], "/") ")"
            if (Locale[getCode(il[0])]["rtl"] || Locale[getCode(tl)]["rtl"])
                r = r "\n" AnsiCode["bold"] s(temp) AnsiCode["no bold"] # caution: mixed languages
            else
                r = r "\n" AnsiCode["bold"] temp AnsiCode["no bold"]
        }

        if (anything(wordClasses)) {
            # List dictionary entries

            for (i = 0; i < length(words); i++) {
                r = r "\n\n" s("[" wordClasses[i] "]", hl) # home language
                for (j = 0; j < length(words[i]); j++) {
                    word = words[i][j][0]
                    explanation = join(words[i][j][1], ", ")
                    article = words[i][j][4]

                    if (rtl) {
                        r = r "\n" AnsiCode["bold"] sprintf("%" Option["width"] - 4 "s", s((article ?
                                                                                            "(" article ")" :
                                                                                            "") " " word, tl, Option["width"] - 4)) AnsiCode["no bold"] # target language
                        r = r "\n" s(explanation, il[0], Option["width"] - 8) # identified source language
                    } else {
                        r = r "\n" "    " AnsiCode["bold"] show((article ?
                                                                 "(" article ") " :
                                                                 "") word, tl) AnsiCode["no bold"] # target language
                        r = r "\n" "        " s(explanation, il[0], Option["width"] - 8) # identified source language
                    }
                }
            }
        }

        if (toSpeech) {
            if (index(Locale[getCode(hl)]["message"], "%s") > 2) {
                returnPlaylist[0]["text"] = sprintf(Locale[getCode(hl)]["message"], "")
                returnPlaylist[0]["tl"] = hl
                returnPlaylist[1]["text"] = join(original)
                returnPlaylist[1]["tl"] = il[0]
            } else {
                returnPlaylist[0]["text"] = join(original)
                returnPlaylist[0]["tl"] = il[0]
                returnPlaylist[1]["text"] = sprintf(Locale[getCode(hl)]["message"], "")
                returnPlaylist[1]["tl"] = hl
            }
            returnPlaylist[2]["text"] = translation
            returnPlaylist[2]["tl"] = tl
        }
    }

    return r
}
