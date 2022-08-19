% TRANS(1) 0.9.6.12
% Mort Yao <soi@mort.ninja>
% 2020-05-11

# NAME

trans - Command-line translator using Google Translate, Bing Translator, Yandex.Translate, etc.

# SYNOPSIS

**trans** [*OPTIONS*] [*SOURCE*]:[*TARGETS*] [*TEXT*]...

# DESCRIPTION

This tool translates text into any language from the command-line, using a translation engine such as Google Translate, Bing Translator and Yandex.Translate.

Each argument which is not a valid option is treated as *TEXT* to be translated.

If neither *TEXT* nor the input file is specified by command-line arguments, the program will read and translate from standard input.

# OPTIONS

## Information options

**-V**, **-version**
:   Print version and exit.

**-H**, **-help**
:   Print help message and exit.

**-M**, **-man**
:   Show man page and exit.

**-T**, **-reference**
:   Print reference table of all supported languages and codes, and exit. Names of languages are displayed in their endonyms (language name in the language itself).

**-R**, **-reference-english**
:   Print reference table of all supported languages and codes, and exit. Names of languages are displayed in English.

**-S**, **-list-engines**
:   List available translation engines and exit.

**-list-languages**
:   List all supported languages (in endonyms) and exit.

**-list-languages-english**
:   List all supported languages (in English names) and exit.

**-list-codes**
:   List all supported codes and exit.

**-list-all**
:   List all supported languages (endonyms and English names) and codes, and exit.

**-L** *CODES*, **-linguist** *CODES*
:   Print details of languages and exit. When specifying two or more language codes, concatenate them by plus sign "+".

**-U**, **-upgrade**
:   Check for upgrade of this program.

## Translator options

**-e** *ENGINE*, **-engine** *ENGINE*
:   Specify the translation engine to use. (default: auto)

## Display options

**-verbose**
:   Verbose mode.

    Show the original text and its most relevant translation, then its phonetic notation (if any), then its alternative translations (if any) or its definition in the dictionary (if it is a word).

    This option is unnecessary in most cases since verbose mode is enabled by default.

**-b**, **-brief**
:   Brief mode.

    Show the most relevant translation or its phonetic notation only.

**-d**, **-dictionary**
:   Dictionary mode.

    Show the definition of the original word in the dictionary.

**-identify**
:   Language identification.

    Show the identified language of the original text.

**-show-original** *Y/n*
:   Show original text or not. (default: yes)

**-show-original-phonetics** *Y/n*
:   Show phonetic notation of original text or not. (default: yes)

**-show-translation** *Y/n*
:   Show translation or not. (default: yes)

**-show-translation-phonetics** *Y/n*
:   Show phonetic notation of translation or not. (default: yes)

**-show-prompt-message** *Y/n*
:   Show prompt message or not. (default: yes)

**-show-languages** *Y/n*
:   Show source and target languages or not. (default: yes)

**-show-original-dictionary** *y/N*
:   Show dictionary entry of original text or not. (default: no)

    This option is enabled in dictionary mode.

**-show-dictionary** *Y/n*
:   Show dictionary entry of translation or not. (default: yes)

**-show-alternatives** *Y/n*
:   Show alternative translations or not. (default: yes)

**-w** *NUM*, **-width** *NUM*
:   Specify the screen width for padding.

    This option overrides the setting of environment variable $**COLUMNS**.

**-indent** *NUM*
:   Specify the size of indent (number of spaces). (default: 4)

**-theme** *FILENAME*
:   Specify the theme to use. (default: default)

**-no-theme**
:   Do not use any other theme than default.

**-no-ansi**
:   Do not use ANSI escape codes.

**-no-autocorrect**
:   Do not autocorrect. (if defaulted by the translation engine)

**-no-bidi**
:   Do not convert bidirectional texts.

**-bidi**
:   Always convert bidirectional texts.

**-no-warn**
:   Do not write warning messages to stderr.

**-dump**
:   Print raw API response instead.

## Audio options

**-p**, **-play**
:   Listen to the translation.

    You must have at least one of the supported audio players (**mplayer**, **mpv** or **mpg123**) installed to stream from Google Text-to-Speech engine. Otherwise, a local speech synthesizer may be used instead (**say** on macOS, **espeak** on Linux or other platforms).

**-speak**
:   Listen to the original text.

**-n** *VOICE*, **-narrator** *VOICE*
:   Specify the narrator, and listen to the translation.

    Common values for this option are **male** and **female**.

**-player** *PROGRAM*
:   Specify the audio player to use, and listen to the translation.

    Option **-play** will try to use **mplayer**, **mpv** or **mpg123** by default, since these players are known to work for streaming URLs. Not all command-line audio players can work this way. Use this option only when you have your own preference.

    This option overrides the setting of environment variable $**PLAYER**.

**-no-play**
:   Do not listen to the translation.

**-no-translate**
:   Do not translate anything when using -speak.

**-download-audio**
:   Download the audio to the current directory.

**-download-audio-as** *FILENAME*
:   Download the audio to the specified file.

## Terminal paging and browsing options

**-v**, **-view**
:   View the translation in a terminal pager (**less**, **more** or **most**).

**-pager** *PROGRAM*
:   Specify the terminal pager to use, and view the translation.

    This option overrides the setting of environment variable $**PAGER**.

**-no-view**, **-no-pager**
:   Do not view the translation in a terminal pager.

**-browser** *PROGRAM*
:   Specify the web browser to use.

    This option overrides the setting of environment variable $**BROWSER**.

**-no-browser**
:   Do not open the web browser.

## Networking options

**-x** *HOST:PORT*, **-proxy** *HOST:PORT*
:   Use HTTP proxy on given port.

    This option overrides the setting of environment variables $**HTTP_PROXY** and $**http_proxy**.

**-u** *STRING*, **-user-agent** *STRING*
:   Specify the User-Agent to identify as.

    This option overrides the setting of environment variables $**USER_AGENT**.

**-4**, **-ipv4**, **-inet4-only**
:   Connect only to IPv4 addresses.

**-6**, **-ipv6**, **-inet6-only**
:   Connect only to IPv6 addresses.

## Interactive shell options

**-I**, **-interactive**, **-shell**
:   Start an interactive shell, invoking **rlwrap** whenever possible (unless **-no-rlwrap** is specified).

**-E**, **-emacs**
:   Start the GNU Emacs front-end for an interactive shell.

    This option does not need to, and cannot be used along with **-I** or **-no-rlwrap**.

**-no-rlwrap**
:   Do not invoke **rlwrap** when starting an interactive shell.

    This option is useful when your terminal type is not supported by **rlwrap** (e.g. **emacs**).

## I/O options

**-i** *FILENAME*, **-input** *FILENAME*
:   Specify the input file.

    Source text to be translated will be read from the input file, instead of standard input.

**-o** *FILENAME*, **-output** *FILENAME*
:   Specify the output file.

    Translations will be written to the output file, instead of standard output.

## Language preference options

**-hl** *CODE*, **-host** *CODE*
:   Specify your home language (the language you would like to see for displaying prompt messages in the translation).

    This option affects only the display in verbose mode (anything other than source language and target language will be displayed in your home language). This option has no effect in brief mode.

    This option is optional. When its setting is omitted, English will be used.

    This option overrides the setting of environment variables $**LC_ALL**, $**LANG**, and $**HOST_LANG**.

**-s** *CODES*, **-sl** *CODES*, **-source** *CODES*, **-from** *CODES*
:   Specify the source language(s) (the language(s) of original text). When specifying two or more language codes, concatenate them by plus sign "+".

    This option is optional. When its setting is omitted, the language of original text will be identified automatically (with a possibility of misidentification).

    This option overrides the setting of environment variable $**SOURCE_LANG**.

**-t** *CODES*, **-tl** *CODES*, **-target** *CODES*, **-to** *CODES*
:   Specify the target language(s) (the language(s) of translated text). When specifying two or more language codes, concatenate them by plus sign "+".

    This option is optional. When its setting is omitted, everything will be translated into English.

    This option overrides the setting of environment variables $**LC_ALL**, $**LANG**, and $**TARGET_LANG**.

[*SOURCE*]:[*TARGETS*]
:   A simpler, alternative way to specify the source language and target language(s) is to use a shortcut formatted string:

    * *SOURCE-CODE*:*TARGET-CODE*
    * *SOURCE-CODE*:*TARGET-CODE1*+*TARGET-CODE2*+...
    * *SOURCE-CODE*=*TARGET-CODE*
    * *SOURCE-CODE*=*TARGET-CODE1*+*TARGET-CODE2*+...

    Delimiter ":" and "=" can be used interchangeably.

    Either *SOURCE* or *TARGETS* may be omitted, but the delimiter character must be kept.

## Text preprocessing options

**-j**, **-join-sentence**
:   Treat all arguments as one single sentence.

## Other options

**-no-init**
:   Do not load any initialization script.

**--**
:   End-of-options.

    All arguments after this option are treated as *TEXT* to be translated.

# EXIT STATUS

**0**
:   Successful translation.

**1**
:   Error.

# ENVIRONMENT

**PAGER**
:   Equivalent to option setting **-pager**.

**BROWSER**
:   Equivalent to option setting **-browser**.

**PLAYER**
:   Equivalent to option setting **-player**.

**HTTP_PROXY**
:   Equivalent to option setting **-proxy**.

**USER_AGENT**
:   Equivalent to option setting **-user-agent**.

**HOST_LANG**
:   Equivalent to option setting **-host**.

**SOURCE_LANG**
:   Equivalent to option setting **-source**.

**TARGET_LANG**
:   Equivalent to option setting **-target**.

# FILES

*/etc/translate-shell*
:   Initialization script. (system-wide)

*$HOME/.translate-shell/init.trans*
:   Initialization script. (user-specific)

*$XDG_CONFIG_HOME/translate-shell/init.trans*
:   Initialization script. (user-specific)

*./.trans*
:   Initialization script. (current directory)

# FURTHER DOCUMENTATION

<https://github.com/soimort/translate-shell/wiki>

# REPORTING BUGS

<https://github.com/soimort/translate-shell/issues>
