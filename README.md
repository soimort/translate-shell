# Translate Shell

[![Icon](https://raw.githubusercontent.com/soimort/translate-shell/gh-pages/images/icon.png)](https://www.soimort.org/translate-shell)
[![CircleCI](https://circleci.com/gh/soimort/translate-shell.svg?style=svg)](https://circleci.com/gh/soimort/translate-shell)
[![Actions](https://github.com/soimort/translate-shell/workflows/CI/badge.svg)](https://github.com/soimort/translate-shell/actions)
[![Version](https://raw.githubusercontent.com/soimort/translate-shell/gh-pages/images/badge-release.png)](https://github.com/soimort/translate-shell/releases)
[![Download](https://raw.githubusercontent.com/soimort/translate-shell/gh-pages/images/badge-download.png)](https://www.soimort.org/translate-shell/trans)
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/soimort/translate-shell?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

**[Translate Shell](https://www.soimort.org/translate-shell)** (formerly _Google Translate CLI_) is a command-line translator powered by **[Google Translate](https://translate.google.com/)** (default), **[Bing Translator](https://www.bing.com/translator)**, **[Yandex.Translate](https://translate.yandex.com/)**, and **[Apertium](https://www.apertium.org/)**. It gives you easy access to one of these translation engines in your terminal:

```
$ trans 'Saluton, Mondo!'
Saluton, Mondo!

Hello, World!

Translations of Saluton, Mondo!
[ Esperanto -> English ]
Saluton ,
    Hello,
Mondo !
    World!
```

By default, translations with detailed explanations are shown. You can also translate the text briefly: (only the most relevant translation will be shown)

```
$ trans -brief 'Saluton, Mondo!'
Hello, World!
```

**Translate Shell** can also be used like an interactive shell; input the text to be translated line by line:

```
$ trans -shell -brief
> Rien ne réussit comme le succès.
Nothing succeeds like success.
> Was mich nicht umbringt, macht mich stärker.
What does not kill me makes me stronger.
> Юмор есть остроумие глубокого чувства.
Humor has a deep sense of wit.
> 學而不思則罔，思而不學則殆。
Learning without thought is labor lost, thought without learning is perilous.
> 幸福になるためには、人から愛されるのが一番の近道。
In order to be happy, the best way is to be loved by people.
```

## Prerequisites

### System Requirements

**Translate Shell** is known to work on many POSIX-compliant systems, including but not limited to:

* GNU/Linux
* macOS
* *BSD
* Android (through Termux)
* Windows (through WSL, Cygwin, or MSYS2)

### Dependencies

* **[GNU Awk](https://www.gnu.org/software/gawk/)** (**gawk**) **4.0 or later**
    * This program relies heavily on GNU extensions of the [AWK language](http://en.wikipedia.org/wiki/AWK), which are non-portable for other AWK implementations (e.g. nawk).
    * How to get gawk:
      * gawk comes with all GNU/Linux distributions.
      * On FreeBSD, gawk is available in the ports.
      * On macOS, gawk is available in MacPorts and Homebrew.
    * Please note that gawk 5.2.0 has a [known bug](https://github.com/soimort/translate-shell/issues/463) -- update to gawk 5.2.1 instead.
* **[GNU Bash](http://www.gnu.org/software/bash/)** or **[Zsh](http://www.zsh.org/)**
    * You may use Translate Shell from any Unix shell of your choice (bash, zsh, ksh, tcsh, fish, etc.); however, the wrapper script requires either **bash** or **zsh** installed.

### Recommended Dependencies

These dependencies are optional, but strongly recommended for full functionality:

* **[curl](http://curl.haxx.se/)** with **OpenSSL** support
* **[GNU FriBidi](http://fribidi.org/)**: _an implementation of the Unicode Bidirectional Algorithm (bidi)_
    * required for displaying text in Right-to-Left scripts (e.g. Arabic, Hebrew)
* **[mplayer](http://www.mplayerhq.hu/)**, **[mpv](http://mpv.io/)**, **[mpg123](http://mpg123.org/)**, or **[eSpeak](http://espeak.sourceforge.net/)**
    * required for the Text-to-Speech functionality
* **[less](http://www.greenwoodsoftware.com/less/)**, **[more](http://pubs.opengroup.org/onlinepubs/9699919799/utilities/more.html)** or **[most](http://www.jedsoft.org/most/)**
    * required for terminal paging
* **[rlwrap](http://utopia.knoware.nl/~hlub/uck/rlwrap/#rlwrap)**: *a GNU readline wrapper*
    * required for readline-style editing and history in the interactive shell
* **[aspell](http://aspell.net/)** or **[hunspell](http://hunspell.github.io/)**
    * required for spell checking

### Environment and Fonts

It is a must to have corresponding fonts for the language(s) / script(s) you wish to display in your terminal. See **[wiki: Writing Systems and Fonts](https://github.com/soimort/translate-shell/wiki/Writing-Systems-and-Fonts#unicode-fonts)** for more details on scripts and recommended Unicode fonts.

## Try It Out!

Start an interactive shell and translate anything you input into your native language: (in **bash** or **zsh**)

    $ gawk -f <(curl -Ls --compressed https://git.io/translate) -- -shell

(in **fish**)

    $ gawk -f (curl -Ls --compressed https://git.io/translate | psub) -- -shell

### Using Docker

To try out via [Docker](https://www.docker.com/), run:

    $ docker pull soimort/translate-shell

Then you may start an interactive shell from the Docker image for translating:

    $ docker run -it soimort/translate-shell -shell

## Installation

### Option #1. Direct Download

Download [the self-contained executable](http://git.io/trans) and place it into your path. It's everything you need.

    $ wget git.io/trans
    $ chmod +x ./trans

There is a [GPG signature](https://www.soimort.org/translate-shell/trans.sig).

### Option #2. From A Package Manager

#### Using your favorite package manager

See **[wiki: Distros](https://github.com/soimort/translate-shell/wiki/Distros)** on how to install from a specific package manager on your distro.

#### Using [Antigen](https://github.com/zsh-users/antigen) (for Zsh users)

Add the following line to your `.zshrc`:

    antigen bundle soimort/translate-shell@develop

### Option #3. From Git

    $ git clone https://github.com/soimort/translate-shell
    $ cd translate-shell/
    $ make
    $ [sudo] make install

In case you have only zsh but not bash in your system, build with:

    $ make TARGET=zsh

The default `PREFIX` of installation is `/usr/local`. To install the program to somewhere else (e.g. `/usr`, `~/.local`), use:

    $ [sudo] make PREFIX=/usr install

## Getting Started by Examples

### Translate a Word

#### From any language to your language

Google Translate can identify the language of the source text automatically, and Translate Shell by default translates the source text into the language of your `locale`.

    $ trans vorto

#### From any language to one or more specific languages

Translate a word into French:

    $ trans :fr word

Translate a word into Chinese and Japanese: (use a plus sign "`+`" as the delimiter)

    $ trans :zh+ja word

Alternatively, equals sign ("`=`") can be used in place of the colon ("`:`"). Note that in some shells (e.g. zsh), equals signs may be interpreted differently, therefore the argument specifying languages needs to be protected:

    $ trans {=zh+ja} word
    $ trans '=zh+ja' word

You can also use the `-target` (`-t`) option to specify the target language(s):

    $ trans -t zh+ja word

With the `-t` option, the name of the language may also be used instead of the language code:

    $ trans -t japanese word
    $ trans -t 日本語 word

#### From a specific language

Google Translate may wrongly identify the source text as some other language than you expected:

    $ trans 手紙

In that case, you need to specify its language explicitly:

    $ trans ja: 手紙
    $ trans zh: 手紙

You can also use the `-source` (`-s`) option to specify the source language:

    $ trans -s ja 手紙

### Translate Multiple Words or a Phrase

Translate each word alone:

    $ trans en:zh word processor

Put words into one argument, and translate them as a whole:

    $ trans en:zh "word processor"

### Translate a Sentence

Translating a sentence is much the same like translating a phrase; you can just quote the sentence into one argument:

    $ trans :zh "To-morrow, and to-morrow, and to-morrow,"
    $ trans :zh 'To-morrow, and to-morrow, and to-morrow,'

It is also possible to translate multi-line sentences:

    $ trans :zh "Creeps in this petty pace from day to day,
    > To the last syllable of recorded time;
    > And all our yesterdays have lighted fools
    > The way to dusty death."

To avoid punctuation marks (e.g. "`!`") or other special characters being interpreted by the shell, use *single quotes*:

    $ trans :zh 'Out, out, brief candle!'

There are some cases though, you may still want to use *double quotes*: (e.g. the sentence contains a single quotation mark "`'`")

    $ trans :zh "Life's but a walking shadow, a poor player"

Alternatively, use the `-join-sentence` (`-j`) option to treat all arguments as one sentence so that quotes can be omitted:

    $ trans -j :zh Life\'s but a walking shadow, a poor player

### Brief Mode

By default, Translate Shell displays translations in a verbose manner. If you prefer to see only the most relevant translation, there is a brief mode available using the `-brief` (`-b`) option:

    $ trans -b :fr "Saluton, Mondo"

In brief mode, phonetic notation (if any) is not shown by default. To enable this, put an at sign "`@`" in front of the language code:

    $ trans -b :@ja "Saluton, Mondo"

### Dictionary Mode

Google Translate can be used as a dictionary. When translating a word and the target language is the same as the source language, the dictionary entry of the word is shown:

    $ trans :en word

To enable dictionary mode no matter whether the source language and the target language are identical, use the `-dictionary` (`-d`) option.

    $ trans -d fr: mot

**Note:** Not every language supported by Google Translate has provided dictionary data. See **[wiki: Languages](https://github.com/soimort/translate-shell/wiki/Languages)** to find out which language(s) has dictionary support.

### Language Identification

Use the `-identify` (`-id`) option to identify the language of the text:

    $ trans -id 言葉

### Text-to-Speech

Use the `-play` (`-p`) option to listen to the translation:

    $ trans -b -p :ja "Saluton, Mondo"

Use the `-speak` (`-sp`) option to listen to the original text:

    $ trans -sp "你好，世界"

### Terminal Paging

Sometimes the content of translation can be too much for display in one screen. Use the `-view` (`-v`) option to view the translation in a terminal pager such as `less` or `more`:

    $ trans -d -v word

### Right-to-Left (RTL) Languages

[Right-to-Left (RTL) languages](http://en.wikipedia.org/wiki/Right-to-left) are well supported via [GNU FriBidi](http://fribidi.org/).

The program will automatically adjust the screen width for padding when displaying right-to-left languages. Alternatively, you may use the `-width` (`-w`) option to specify the screen width:

    $ trans -b -w 40 :he "Saluton, Mondo"

See **[wiki: Languages](https://github.com/soimort/translate-shell/wiki/Languages)** to find out which language(s) uses a Right-to-Left writing system.

### Pipeline, Input and Output

If no source text is given in command-line arguments, the program will read from standard input, or from the file specified by the `-input` (`-i`) option:

    $ echo "Saluton, Mondo" | trans -b :fr
    $ trans -b -i input.txt :fr

Translations are written to standard output, or to the file specified by the `-output` (`-o`) option:

    $ echo "Saluton, Mondo" | trans -b -o output.txt :fr

### Translate a File

Instead of using the `-input` option, a [file URI scheme](http://en.wikipedia.org/wiki/File_URI_scheme) (`file://` followed by the file name) can be used as a command-line argument:

    $ trans :fr file://input.txt

**Note**: Brief mode is used when translating from file URI schemes.

### Translate a Web Page

To translate a web page, an http(s) URI scheme can be used as an argument:

    $ trans :fr http://www.w3.org/

A browser session will open for viewing the translation (via Google Translate's web interface). To specify your web browser of choice, use the `-browser` option:

    $ trans -browser firefox :fr http://www.w3.org/

### Language Details

Use the `-linguist` (`-L`) option to view details of one or more languages:

    $ trans -L fr
    $ trans -L de+en

Some basic information of the language will be displayed: its English name and endonym (language name in the language itself), language family, writing system, canonical Google Translate code and ISO 639-3 code.

### Interactive Translate Shell (REPL)

Start an interactive shell using the `-shell` (or `-interactive`, `-I`) option:

    $ trans -shell

You may specify the source language and the target language(s) before starting an interactive shell:

    $ trans -shell en:fr

You may also change these settings during an interactive session. See **[wiki: REPL](https://github.com/soimort/translate-shell/wiki/REPL)** for more advanced usage of the interactive Translate Shell.

## Usage

For more details on command-line options, see the man page **[trans(1)](https://www.soimort.org/translate-shell/trans.1.html)** or use `trans -M` in a terminal.

```
Usage:  trans [OPTIONS] [SOURCES]:[TARGETS] [TEXT]...

Information options:
    -V, -version
        Print version and exit.
    -H, -help
        Print help message and exit.
    -M, -man
        Show man page and exit.
    -T, -reference
        Print reference table of languages (in endonyms) and codes, and exit.
    -R, -reference-english
        Print reference table of languages (in English names) and codes, and exit.
    -S, -list-engines
        List available translation engines and exit.
    -list-languages
        List all languages (in endonyms) and exit.
    -list-languages-english
        List all languages (in English names) and exit.
    -list-codes
        List all codes and exit.
    -list-all
        List all languages (endonyms and English names) and codes, and exit.
    -L CODES, -linguist CODES
        Print details of languages and exit.
    -U, -upgrade
        Check for upgrade of this program.

Translator options:
    -e ENGINE, -engine ENGINE
        Specify the translation engine to use.

Display options:
    -verbose
        Verbose mode. (default)
    -b, -brief
        Brief mode.
    -d, -dictionary
        Dictionary mode.
    -identify
        Language identification.
    -show-original Y/n
        Show original text or not.
    -show-original-phonetics Y/n
        Show phonetic notation of original text or not.
    -show-translation Y/n
        Show translation or not.
    -show-translation-phonetics Y/n
        Show phonetic notation of translation or not.
    -show-prompt-message Y/n
        Show prompt message or not.
    -show-languages Y/n
        Show source and target languages or not.
    -show-original-dictionary y/N
        Show dictionary entry of original text or not.
    -show-dictionary Y/n
        Show dictionary entry of translation or not.
    -show-alternatives Y/n
        Show alternative translations or not.
    -w NUM, -width NUM
        Specify the screen width for padding.
    -indent NUM
        Specify the size of indent (number of spaces).
    -theme FILENAME
        Specify the theme to use.
    -no-theme
        Do not use any other theme than default.
    -no-ansi
        Do not use ANSI escape codes.
    -no-autocorrect
        Do not autocorrect. (if defaulted by the translation engine)
    -no-bidi
        Do not convert bidirectional texts.
    -bidi
        Always convert bidirectional texts.
    -no-warn
        Do not write warning messages to stderr.
    -dump
        Print raw API response instead.

Audio options:
    -p, -play
        Listen to the translation.
    -speak
        Listen to the original text.
    -n VOICE, -narrator VOICE
        Specify the narrator, and listen to the translation.
    -player PROGRAM
        Specify the audio player to use, and listen to the translation.
    -no-play
        Do not listen to the translation.
    -no-translate
        Do not translate anything when using -speak.
    -download-audio
        Download the audio to the current directory.
    -download-audio-as FILENAME
        Download the audio to the specified file.

Terminal paging and browsing options:
    -v, -view
        View the translation in a terminal pager.
    -pager PROGRAM
        Specify the terminal pager to use, and view the translation.
    -no-view, -no-pager
        Do not view the translation in a terminal pager.
    -browser PROGRAM
        Specify the web browser to use.
    -no-browser
        Do not open the web browser.

Networking options:
    -x HOST:PORT, -proxy HOST:PORT
        Use HTTP proxy on given port.
    -u STRING, -user-agent STRING
        Specify the User-Agent to identify as.
    -4, -ipv4, -inet4-only
        Connect only to IPv4 addresses.
    -6, -ipv6, -inet6-only
        Connect only to IPv6 addresses.

Interactive shell options:
    -I, -interactive, -shell
        Start an interactive shell.
    -E, -emacs
        Start the GNU Emacs front-end for an interactive shell.
    -no-rlwrap
        Do not invoke rlwrap when starting an interactive shell.

I/O options:
    -i FILENAME, -input FILENAME
        Specify the input file.
    -o FILENAME, -output FILENAME
        Specify the output file.

Language preference options:
    -hl CODE, -host CODE
        Specify the host (interface) language.
    -s CODES, -sl CODES, -source CODES, -from CODES
        Specify the source language(s), joined by '+'.
    -t CODES, -tl CODES, -target CODES, -to CODES
        Specify the target language(s), joined by '+'.

Text preprocessing options:
    -j, -join-sentence
        Treat all arguments as one single sentence.

Other options:
    -no-init
        Do not load any initialization script.

See the man page trans(1) for more information.
```

## Code List

Use `trans -R` or `trans -T` to view the reference table in a terminal.

For more details on languages and corresponding codes, see **[wiki: Languages](https://github.com/soimort/translate-shell/wiki/Languages)**.

| Language | Code | Language | Code | Language | Code |
| :------: | :--: | :------: | :--: | :------: | :--: |
| **[Afrikaans](http://en.wikipedia.org/wiki/ISO_639:afr)** <br/> **Afrikaans** | **`af`** | **[Hebrew](http://en.wikipedia.org/wiki/ISO_639:heb)** <br/> **עִבְרִית** | **`he`** | **[Portuguese (Brazilian)](http://en.wikipedia.org/wiki/ISO_639:por)** <br/> **Português Brasileiro** | **`pt-BR`** | 
| **[Albanian](http://en.wikipedia.org/wiki/ISO_639:sqi)** <br/> **Shqip** | **`sq`** | **[Hill Mari](http://en.wikipedia.org/wiki/ISO_639:mrj)** <br/> **Кырык мары** | **`mrj`** | **[Portuguese (European)](http://en.wikipedia.org/wiki/ISO_639:por)** <br/> **Português Europeu** | **`pt-PT`** | 
| **[Amharic](http://en.wikipedia.org/wiki/ISO_639:amh)** <br/> **አማርኛ** | **`am`** | **[Hindi](http://en.wikipedia.org/wiki/ISO_639:hin)** <br/> **हिन्दी** | **`hi`** | **[Punjabi](http://en.wikipedia.org/wiki/ISO_639:pan)** <br/> **ਪੰਜਾਬੀ** | **`pa`** | 
| **[Arabic](http://en.wikipedia.org/wiki/ISO_639:ara)** <br/> **العربية** | **`ar`** | **[Hmong](http://en.wikipedia.org/wiki/ISO_639:hmn)** <br/> **Hmoob** | **`hmn`** | **[Quechua](http://en.wikipedia.org/wiki/ISO_639:que)** <br/> **Runasimi** | **`qu`** | 
| **[Armenian](http://en.wikipedia.org/wiki/ISO_639:hye)** <br/> **Հայերեն** | **`hy`** | **[Hungarian](http://en.wikipedia.org/wiki/ISO_639:hun)** <br/> **Magyar** | **`hu`** | **[Querétaro Otomi](http://en.wikipedia.org/wiki/ISO_639:otq)** <br/> **Hñąñho** | **`otq`** | 
| **[Assamese](http://en.wikipedia.org/wiki/ISO_639:asm)** <br/> **অসমীয়া** | **`as`** | **[Icelandic](http://en.wikipedia.org/wiki/ISO_639:isl)** <br/> **Íslenska** | **`is`** | **[Romanian](http://en.wikipedia.org/wiki/ISO_639:ron)** <br/> **Română** | **`ro`** | 
| **[Aymara](http://en.wikipedia.org/wiki/ISO_639:aym)** <br/> **Aymar aru** | **`ay`** | **[Igbo](http://en.wikipedia.org/wiki/ISO_639:ibo)** <br/> **Igbo** | **`ig`** | **[Romansh](http://en.wikipedia.org/wiki/ISO_639:roh)** <br/> **Rumantsch** | **`rm`** | 
| **[Azerbaijani](http://en.wikipedia.org/wiki/ISO_639:aze)** <br/> **Azərbaycanca** | **`az`** | **[Ilocano](http://en.wikipedia.org/wiki/ISO_639:ilo)** <br/> **Ilokano** | **`ilo`** | **[Russian](http://en.wikipedia.org/wiki/ISO_639:rus)** <br/> **Русский** | **`ru`** | 
| **[Bambara](http://en.wikipedia.org/wiki/ISO_639:bam)** <br/> **Bamanankan** | **`bm`** | **[Indonesian](http://en.wikipedia.org/wiki/ISO_639:ind)** <br/> **Bahasa Indonesia** | **`id`** | **[Samoan](http://en.wikipedia.org/wiki/ISO_639:smo)** <br/> **Gagana Sāmoa** | **`sm`** | 
| **[Bashkir](http://en.wikipedia.org/wiki/ISO_639:bak)** <br/> **Башҡортса** | **`ba`** | **[Interlingue](http://en.wikipedia.org/wiki/ISO_639:ile)** <br/> **Interlingue** | **`ie`** | **[Sanskrit](http://en.wikipedia.org/wiki/ISO_639:san)** <br/> **संस्कृतम्** | **`sa`** | 
| **[Basque](http://en.wikipedia.org/wiki/ISO_639:eus)** <br/> **Euskara** | **`eu`** | **[Inuinnaqtun](http://en.wikipedia.org/wiki/ISO_639:ikt)** <br/> **Inuinnaqtun** | **`ikt`** | **[Scots Gaelic](http://en.wikipedia.org/wiki/ISO_639:gla)** <br/> **Gàidhlig** | **`gd`** | 
| **[Belarusian](http://en.wikipedia.org/wiki/ISO_639:bel)** <br/> **беларуская** | **`be`** | **[Inuktitut](http://en.wikipedia.org/wiki/ISO_639:iku)** <br/> **ᐃᓄᒃᑎᑐᑦ** | **`iu`** | **[Sepedi](http://en.wikipedia.org/wiki/ISO_639:nso)** <br/> **Sepedi** | **`nso`** | 
| **[Bengali](http://en.wikipedia.org/wiki/ISO_639:ben)** <br/> **বাংলা** | **`bn`** | **[Inuktitut (Latin)](http://en.wikipedia.org/wiki/ISO_639:iku)** <br/> **Inuktitut** | **`iu-Latn`** | **[Serbian (Cyrillic)](http://en.wikipedia.org/wiki/ISO_639:srp)** <br/> **Српски** | **`sr-Cyrl`** | 
| **[Bhojpuri](http://en.wikipedia.org/wiki/ISO_639:bho)** <br/> **भोजपुरी** | **`bho`** | **[Irish](http://en.wikipedia.org/wiki/ISO_639:gle)** <br/> **Gaeilge** | **`ga`** | **[Serbian (Latin)](http://en.wikipedia.org/wiki/ISO_639:srp)** <br/> **Srpski** | **`sr-Latn`** | 
| **[Bosnian](http://en.wikipedia.org/wiki/ISO_639:bos)** <br/> **Bosanski** | **`bs`** | **[Italian](http://en.wikipedia.org/wiki/ISO_639:ita)** <br/> **Italiano** | **`it`** | **[Sesotho](http://en.wikipedia.org/wiki/ISO_639:sot)** <br/> **Sesotho** | **`st`** | 
| **[Breton](http://en.wikipedia.org/wiki/ISO_639:bre)** <br/> **Brezhoneg** | **`br`** | **[Japanese](http://en.wikipedia.org/wiki/ISO_639:jpn)** <br/> **日本語** | **`ja`** | **[Setswana](http://en.wikipedia.org/wiki/ISO_639:tsn)** <br/> **Setswana** | **`tn`** | 
| **[Bulgarian](http://en.wikipedia.org/wiki/ISO_639:bul)** <br/> **български** | **`bg`** | **[Javanese](http://en.wikipedia.org/wiki/ISO_639:jav)** <br/> **Basa Jawa** | **`jv`** | **[Shona](http://en.wikipedia.org/wiki/ISO_639:sna)** <br/> **chiShona** | **`sn`** | 
| **[Cantonese](http://en.wikipedia.org/wiki/ISO_639:yue)** <br/> **粵語** | **`yue`** | **[Kannada](http://en.wikipedia.org/wiki/ISO_639:kan)** <br/> **ಕನ್ನಡ** | **`kn`** | **[Sindhi](http://en.wikipedia.org/wiki/ISO_639:snd)** <br/> **سنڌي** | **`sd`** | 
| **[Catalan](http://en.wikipedia.org/wiki/ISO_639:cat)** <br/> **Català** | **`ca`** | **[Kazakh](http://en.wikipedia.org/wiki/ISO_639:kaz)** <br/> **Қазақ тілі** | **`kk`** | **[Sinhala](http://en.wikipedia.org/wiki/ISO_639:sin)** <br/> **සිංහල** | **`si`** | 
| **[Cebuano](http://en.wikipedia.org/wiki/ISO_639:ceb)** <br/> **Cebuano** | **`ceb`** | **[Khmer](http://en.wikipedia.org/wiki/ISO_639:khm)** <br/> **ភាសាខ្មែរ** | **`km`** | **[Slovak](http://en.wikipedia.org/wiki/ISO_639:slk)** <br/> **Slovenčina** | **`sk`** | 
| **[Cherokee](http://en.wikipedia.org/wiki/ISO_639:chr)** <br/> **ᏣᎳᎩ** | **`chr`** | **[Kinyarwanda](http://en.wikipedia.org/wiki/ISO_639:kin)** <br/> **Ikinyarwanda** | **`rw`** | **[Slovenian](http://en.wikipedia.org/wiki/ISO_639:slv)** <br/> **Slovenščina** | **`sl`** | 
| **[Chichewa](http://en.wikipedia.org/wiki/ISO_639:nya)** <br/> **Nyanja** | **`ny`** | **[Klingon](http://en.wikipedia.org/wiki/ISO_639:tlh)** <br/> **tlhIngan Hol** | **`tlh-Latn`** | **[Somali](http://en.wikipedia.org/wiki/ISO_639:som)** <br/> **Soomaali** | **`so`** | 
| **[Chinese (Literary)](http://en.wikipedia.org/wiki/ISO_639:lzh)** <br/> **文言** | **`lzh`** | **[Konkani](http://en.wikipedia.org/wiki/ISO_639:gom)** <br/> **कोंकणी** | **`gom`** | **[Spanish](http://en.wikipedia.org/wiki/ISO_639:spa)** <br/> **Español** | **`es`** | 
| **[Chinese (Simplified)](http://en.wikipedia.org/wiki/ISO_639:zho)** <br/> **简体中文** | **`zh-CN`** | **[Korean](http://en.wikipedia.org/wiki/ISO_639:kor)** <br/> **한국어** | **`ko`** | **[Sundanese](http://en.wikipedia.org/wiki/ISO_639:sun)** <br/> **Basa Sunda** | **`su`** | 
| **[Chinese (Traditional)](http://en.wikipedia.org/wiki/ISO_639:zho)** <br/> **繁體中文** | **`zh-TW`** | **[Krio](http://en.wikipedia.org/wiki/ISO_639:kri)** <br/> **Krio** | **`kri`** | **[Swahili](http://en.wikipedia.org/wiki/ISO_639:swa)** <br/> **Kiswahili** | **`sw`** | 
| **[Chuvash](http://en.wikipedia.org/wiki/ISO_639:chv)** <br/> **Чӑвашла** | **`cv`** | **[Kurdish (Central)](http://en.wikipedia.org/wiki/ISO_639:ckb)** <br/> **سۆرانی** | **`ckb`** | **[Swedish](http://en.wikipedia.org/wiki/ISO_639:swe)** <br/> **Svenska** | **`sv`** | 
| **[Corsican](http://en.wikipedia.org/wiki/ISO_639:cos)** <br/> **Corsu** | **`co`** | **[Kurdish (Northern)](http://en.wikipedia.org/wiki/ISO_639:kmr)** <br/> **Kurmancî** | **`ku`** | **[Tahitian](http://en.wikipedia.org/wiki/ISO_639:tah)** <br/> **Reo Tahiti** | **`ty`** | 
| **[Croatian](http://en.wikipedia.org/wiki/ISO_639:hrv)** <br/> **Hrvatski** | **`hr`** | **[Kyrgyz](http://en.wikipedia.org/wiki/ISO_639:kir)** <br/> **Кыргызча** | **`ky`** | **[Tajik](http://en.wikipedia.org/wiki/ISO_639:tgk)** <br/> **Тоҷикӣ** | **`tg`** | 
| **[Czech](http://en.wikipedia.org/wiki/ISO_639:ces)** <br/> **Čeština** | **`cs`** | **[Lao](http://en.wikipedia.org/wiki/ISO_639:lao)** <br/> **ລາວ** | **`lo`** | **[Tamil](http://en.wikipedia.org/wiki/ISO_639:tam)** <br/> **தமிழ்** | **`ta`** | 
| **[Danish](http://en.wikipedia.org/wiki/ISO_639:dan)** <br/> **Dansk** | **`da`** | **[Latin](http://en.wikipedia.org/wiki/ISO_639:lat)** <br/> **Latina** | **`la`** | **[Tatar](http://en.wikipedia.org/wiki/ISO_639:tat)** <br/> **татарча** | **`tt`** | 
| **[Dari](http://en.wikipedia.org/wiki/ISO_639:prs)** <br/> **دری** | **`prs`** | **[Latvian](http://en.wikipedia.org/wiki/ISO_639:lav)** <br/> **Latviešu** | **`lv`** | **[Telugu](http://en.wikipedia.org/wiki/ISO_639:tel)** <br/> **తెలుగు** | **`te`** | 
| **[Dhivehi](http://en.wikipedia.org/wiki/ISO_639:div)** <br/> **ދިވެހި** | **`dv`** | **[Lingala](http://en.wikipedia.org/wiki/ISO_639:lin)** <br/> **Lingála** | **`ln`** | **[Thai](http://en.wikipedia.org/wiki/ISO_639:tha)** <br/> **ไทย** | **`th`** | 
| **[Dogri](http://en.wikipedia.org/wiki/ISO_639:doi)** <br/> **डोगरी** | **`doi`** | **[Lithuanian](http://en.wikipedia.org/wiki/ISO_639:lit)** <br/> **Lietuvių** | **`lt`** | **[Tibetan](http://en.wikipedia.org/wiki/ISO_639:bod)** <br/> **བོད་ཡིག** | **`bo`** | 
| **[Dutch](http://en.wikipedia.org/wiki/ISO_639:nld)** <br/> **Nederlands** | **`nl`** | **[Luganda](http://en.wikipedia.org/wiki/ISO_639:lug)** <br/> **Luganda** | **`lg`** | **[Tigrinya](http://en.wikipedia.org/wiki/ISO_639:tir)** <br/> **ትግርኛ** | **`ti`** | 
| **[Dzongkha](http://en.wikipedia.org/wiki/ISO_639:dzo)** <br/> **རྫོང་ཁ** | **`dz`** | **[Luxembourgish](http://en.wikipedia.org/wiki/ISO_639:ltz)** <br/> **Lëtzebuergesch** | **`lb`** | **[Tongan](http://en.wikipedia.org/wiki/ISO_639:ton)** <br/> **Lea faka-Tonga** | **`to`** | 
| **[Eastern Mari](http://en.wikipedia.org/wiki/ISO_639:mhr)** <br/> **Олык марий** | **`mhr`** | **[Macedonian](http://en.wikipedia.org/wiki/ISO_639:mkd)** <br/> **Македонски** | **`mk`** | **[Tsonga](http://en.wikipedia.org/wiki/ISO_639:tso)** <br/> **Xitsonga** | **`ts`** | 
| **[English](http://en.wikipedia.org/wiki/ISO_639:eng)** <br/> **English** | **`en`** | **[Maithili](http://en.wikipedia.org/wiki/ISO_639:mai)** <br/> **मैथिली** | **`mai`** | **[Turkish](http://en.wikipedia.org/wiki/ISO_639:tur)** <br/> **Türkçe** | **`tr`** | 
| **[Esperanto](http://en.wikipedia.org/wiki/ISO_639:epo)** <br/> **Esperanto** | **`eo`** | **[Malagasy](http://en.wikipedia.org/wiki/ISO_639:mlg)** <br/> **Malagasy** | **`mg`** | **[Turkmen](http://en.wikipedia.org/wiki/ISO_639:tuk)** <br/> **Türkmen** | **`tk`** | 
| **[Estonian](http://en.wikipedia.org/wiki/ISO_639:est)** <br/> **Eesti** | **`et`** | **[Malay](http://en.wikipedia.org/wiki/ISO_639:msa)** <br/> **Bahasa Melayu** | **`ms`** | **[Twi](http://en.wikipedia.org/wiki/ISO_639:twi)** <br/> **Twi** | **`tw`** | 
| **[Ewe](http://en.wikipedia.org/wiki/ISO_639:ewe)** <br/> **Eʋegbe** | **`ee`** | **[Malayalam](http://en.wikipedia.org/wiki/ISO_639:mal)** <br/> **മലയാളം** | **`ml`** | **[Udmurt](http://en.wikipedia.org/wiki/ISO_639:udm)** <br/> **Удмурт** | **`udm`** | 
| **[Faroese](http://en.wikipedia.org/wiki/ISO_639:fao)** <br/> **Føroyskt** | **`fo`** | **[Maltese](http://en.wikipedia.org/wiki/ISO_639:mlt)** <br/> **Malti** | **`mt`** | **[Ukrainian](http://en.wikipedia.org/wiki/ISO_639:ukr)** <br/> **Українська** | **`uk`** | 
| **[Fijian](http://en.wikipedia.org/wiki/ISO_639:fij)** <br/> **Vosa Vakaviti** | **`fj`** | **[Maori](http://en.wikipedia.org/wiki/ISO_639:mri)** <br/> **Māori** | **`mi`** | **[Upper Sorbian](http://en.wikipedia.org/wiki/ISO_639:hsb)** <br/> **Hornjoserbšćina** | **`hsb`** | 
| **[Filipino](http://en.wikipedia.org/wiki/ISO_639:fil)** <br/> **Filipino** | **`tl`** | **[Marathi](http://en.wikipedia.org/wiki/ISO_639:mar)** <br/> **मराठी** | **`mr`** | **[Urdu](http://en.wikipedia.org/wiki/ISO_639:urd)** <br/> **اُردُو** | **`ur`** | 
| **[Finnish](http://en.wikipedia.org/wiki/ISO_639:fin)** <br/> **Suomi** | **`fi`** | **[Meiteilon](http://en.wikipedia.org/wiki/ISO_639:mni)** <br/> **ꯃꯤꯇꯩꯂꯣꯟ** | **`mni-Mtei`** | **[Uyghur](http://en.wikipedia.org/wiki/ISO_639:uig)** <br/> **ئۇيغۇر تىلى** | **`ug`** | 
| **[French](http://en.wikipedia.org/wiki/ISO_639:fra)** <br/> **Français** | **`fr`** | **[Mizo](http://en.wikipedia.org/wiki/ISO_639:lus)** <br/> **Mizo ṭawng** | **`lus`** | **[Uzbek](http://en.wikipedia.org/wiki/ISO_639:uzb)** <br/> **Oʻzbek tili** | **`uz`** | 
| **[French (Canadian)](http://en.wikipedia.org/wiki/ISO_639:fra)** <br/> **Français canadien** | **`fr-CA`** | **[Mongolian](http://en.wikipedia.org/wiki/ISO_639:mon)** <br/> **Монгол** | **`mn`** | **[Vietnamese](http://en.wikipedia.org/wiki/ISO_639:vie)** <br/> **Tiếng Việt** | **`vi`** | 
| **[Frisian](http://en.wikipedia.org/wiki/ISO_639:fry)** <br/> **Frysk** | **`fy`** | **[Mongolian (Traditional)](http://en.wikipedia.org/wiki/ISO_639:mon)** <br/> **ᠮᠣᠩᠭᠣᠯ** | **`mn-Mong`** | **[Volapük](http://en.wikipedia.org/wiki/ISO_639:vol)** <br/> **Volapük** | **`vo`** | 
| **[Galician](http://en.wikipedia.org/wiki/ISO_639:glg)** <br/> **Galego** | **`gl`** | **[Myanmar](http://en.wikipedia.org/wiki/ISO_639:mya)** <br/> **မြန်မာစာ** | **`my`** | **[Welsh](http://en.wikipedia.org/wiki/ISO_639:cym)** <br/> **Cymraeg** | **`cy`** | 
| **[Georgian](http://en.wikipedia.org/wiki/ISO_639:kat)** <br/> **ქართული** | **`ka`** | **[Nepali](http://en.wikipedia.org/wiki/ISO_639:nep)** <br/> **नेपाली** | **`ne`** | **[Wolof](http://en.wikipedia.org/wiki/ISO_639:wol)** <br/> **Wollof** | **`wo`** | 
| **[German](http://en.wikipedia.org/wiki/ISO_639:deu)** <br/> **Deutsch** | **`de`** | **[Norwegian](http://en.wikipedia.org/wiki/ISO_639:nor)** <br/> **Norsk** | **`no`** | **[Xhosa](http://en.wikipedia.org/wiki/ISO_639:xho)** <br/> **isiXhosa** | **`xh`** | 
| **[Greek](http://en.wikipedia.org/wiki/ISO_639:ell)** <br/> **Ελληνικά** | **`el`** | **[Occitan](http://en.wikipedia.org/wiki/ISO_639:oci)** <br/> **Occitan** | **`oc`** | **[Yakut](http://en.wikipedia.org/wiki/ISO_639:sah)** <br/> **Sakha** | **`sah`** | 
| **[Greenlandic](http://en.wikipedia.org/wiki/ISO_639:kal)** <br/> **Kalaallisut** | **`kl`** | **[Odia](http://en.wikipedia.org/wiki/ISO_639:ori)** <br/> **ଓଡ଼ିଆ** | **`or`** | **[Yiddish](http://en.wikipedia.org/wiki/ISO_639:yid)** <br/> **ייִדיש** | **`yi`** | 
| **[Guarani](http://en.wikipedia.org/wiki/ISO_639:gug)** <br/> **Avañe'ẽ** | **`gn`** | **[Oromo](http://en.wikipedia.org/wiki/ISO_639:orm)** <br/> **Afaan Oromoo** | **`om`** | **[Yoruba](http://en.wikipedia.org/wiki/ISO_639:yor)** <br/> **Yorùbá** | **`yo`** | 
| **[Gujarati](http://en.wikipedia.org/wiki/ISO_639:guj)** <br/> **ગુજરાતી** | **`gu`** | **[Papiamento](http://en.wikipedia.org/wiki/ISO_639:pap)** <br/> **Papiamentu** | **`pap`** | **[Yucatec Maya](http://en.wikipedia.org/wiki/ISO_639:yua)** <br/> **Màaya T'àan** | **`yua`** | 
| **[Haitian Creole](http://en.wikipedia.org/wiki/ISO_639:hat)** <br/> **Kreyòl Ayisyen** | **`ht`** | **[Pashto](http://en.wikipedia.org/wiki/ISO_639:pus)** <br/> **پښتو** | **`ps`** | **[Zulu](http://en.wikipedia.org/wiki/ISO_639:zul)** <br/> **isiZulu** | **`zu`** | 
| **[Hausa](http://en.wikipedia.org/wiki/ISO_639:hau)** <br/> **Hausa** | **`ha`** | **[Persian](http://en.wikipedia.org/wiki/ISO_639:fas)** <br/> **فارسی** | **`fa`** | 
| **[Hawaiian](http://en.wikipedia.org/wiki/ISO_639:haw)** <br/> **ʻŌlelo Hawaiʻi** | **`haw`** | **[Polish](http://en.wikipedia.org/wiki/ISO_639:pol)** <br/> **Polski** | **`pl`** | 


## Wiki

Lists of all languages, writing systems and fonts for reference:

* **[Languages](https://github.com/soimort/translate-shell/wiki/Languages)**
* **[Writing Systems and Fonts](https://github.com/soimort/translate-shell/wiki/Writing-Systems-and-Fonts)**

The following pages demonstrate the advanced usage of **Translate Shell**:

* **[REPL](https://github.com/soimort/translate-shell/wiki/REPL)**
* **[Text Editor Integration](https://github.com/soimort/translate-shell/wiki/Text-Editor-Integration)**
* **[Narrator Selection](https://github.com/soimort/translate-shell/wiki/Narrator-Selection)**
* **[Configuration](https://github.com/soimort/translate-shell/wiki/Configuration)**
* **[Themes](https://github.com/soimort/translate-shell/wiki/Themes)**
* **[AppleScript](https://github.com/soimort/translate-shell/wiki/AppleScript)**

Find out whether your Linux distribution has included **Translate Shell** in its official repository. If not, contribute one:

* **[Distros](https://github.com/soimort/translate-shell/wiki/Distros)**

Frequently Asked Questions, historical stuff, AWK coding style, etc.:

* **[FAQ](https://github.com/soimort/translate-shell/wiki/FAQ)**
* **[History](https://github.com/soimort/translate-shell/wiki/History)**
* **[AWK Style Guide](https://github.com/soimort/translate-shell/wiki/AWK-Style-Guide)**

## Reporting Bugs / Contributing

Please review the [guidelines for contributing](https://github.com/soimort/translate-shell/blob/stable/CONTRIBUTING.md) before reporting an issue or sending a pull request.

## Licensing

This is free and unencumbered software released into the public domain. See **[LICENSE](https://github.com/soimort/translate-shell/blob/stable/LICENSE)** and **[WAIVER](https://github.com/soimort/translate-shell/blob/stable/WAIVER)** for details.
