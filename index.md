---
title: Translate Shell
project-name: Translate Shell
project-version: 0.9.0.4
project-logo: images/logo.jpg
background: images/background.png
github: soimort/translate-shell
url: http://www.soimort.org/translate-shell/
download-url: http://www.soimort.org/translate-shell/trans
download-checksum-type: SHA1SUM
download-checksum-data: f91cc2aac493bfb184fc5aeb94761c3dffb09798
download-signature: http://www.soimort.org/translate-shell/trans.sig

---
# Translate Shell

[![Icon](https://raw.githubusercontent.com/soimort/translate-shell/gh-pages/images/icon.png)](http://www.soimort.org/translate-shell)
[![Build Status](https://travis-ci.org/soimort/translate-shell.png)](https://travis-ci.org/soimort/translate-shell)
[![Version](https://raw.githubusercontent.com/soimort/translate-shell/gh-pages/images/badge-release.png)](https://github.com/soimort/translate-shell/releases)
[![Download](https://raw.githubusercontent.com/soimort/translate-shell/gh-pages/images/badge-download.png)](http://www.soimort.org/translate-shell/trans)
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/soimort/translate-shell?utm_source=badge$readme$utm_medium=badge$readme$utm_campaign=pr-badge$readme$utm_content=badge)

**[Translate Shell](http://www.soimort.org/translate-shell)** (formerly _Google Translate CLI_) is a command-line translator powered by **[Google Translate](https://translate.google.com/)**. It gives you easy access to Google Translate in your terminal:

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
* OS X
* FreeBSD
* Cygwin

### Dependencies

* **[GNU Awk](https://www.gnu.org/software/gawk/)** (**gawk**) **4.0 or later**
    * This program relies heavily on GNU extensions of the [AWK language](http://en.wikipedia.org/wiki/AWK), which are non-portable for other AWK implementations (e.g. nawk).
    * How to get gawk:
      * gawk comes with all GNU/Linux distributions.
      * On FreeBSD, gawk is available in the ports.
      * On OS X, gawk is available in MacPorts and Homebrew.
* **[GNU Bash](http://www.gnu.org/software/bash/)** or **[Zsh](http://www.zsh.org/)**
    * You may use Translate Shell from any Unix shell of your choice (bash, zsh, ksh, tcsh, fish, etc.); however, the wrapper script requires either **bash** or **zsh** installed.

### Optional Dependencies

* **[GNU FriBidi](http://fribidi.org/)**: _an implementation of the Unicode Bidirectional Algorithm (bidi)_
    * required for displaying text in Right-to-Left scripts (e.g. Arabic, Hebrew)
* **[mplayer](http://www.mplayerhq.hu/)**, **[mplayer2](http://www.mplayer2.org/)**, **[mpv](http://mpv.io/)**, **[mpg123](http://mpg123.org/)**, or **[eSpeak](http://espeak.sourceforge.net/)**
    * required for the Text-to-Speech functionality
* **[less](http://www.greenwoodsoftware.com/less/)**, **[more](http://pubs.opengroup.org/onlinepubs/9699919799/utilities/more.html)** or **[most](http://www.jedsoft.org/most/)**
    * required for terminal paging
* **[rlwrap](http://utopia.knoware.nl/~hlub/uck/rlwrap/#rlwrap)**: *a GNU readline wrapper*
    * required for readline-style editing and history in the interactive shell
* **[curl](http://curl.haxx.se/)** with **OpenSSL** support
    * required for secured URL fetching (checking for upgrade, etc.)

### Environment and Fonts

It is strongly recommended to use a UTF-8 codeset in your default [locale](http://en.wikipedia.org/wiki/Locale), as it has potential support for all languages. You can check whether your codeset is UTF-8 using the `locale` command.

In addition, you must have corresponding fonts for the language(s) / script(s) you wish to display in your terminal. See **[wiki: Writing Systems and Fonts](https://github.com/soimort/translate-shell/wiki/Writing-Systems-and-Fonts#unicode-fonts)** for more details on scripts and recommended Unicode fonts.

## Try It Out!

Start an interactive shell and translate anything you input into your native language: (in **bash** or **zsh**)

    $ gawk -f <(curl -Ls git.io/translate) -shell

(in **fish**)

    $ gawk -f (curl -Ls git.io/translate | psub) -shell

**Please make sure to read [the disclaimer](#disclaimer) before using.**

## Installation

### Option #1. Direct Download

Download [the self-contained executable](http://git.io/trans) and place it into your path. It's everything you need.

    $ wget git.io/trans
    $ chmod +x ./trans

There is a [GPG signature](http://www.soimort.org/translate-shell/trans.sig).

### Option #2. From Git

    $ git clone https://github.com/soimort/translate-shell
    $ cd translate-shell/
    $ make
    $ [sudo] make install

In case you have only zsh but not bash in your system, build with:

    $ make TARGET=zsh

The default `PREFIX` of installation is `/usr/local`. To install the program to somewhere else (e.g. `/usr`, `~/.local`), use:

    $ [sudo] make PREFIX=/usr install

### Option #3. From A Package Manager

On OS X with Homebrew:

    $ brew install http://www.soimort.org/translate-shell/translate-shell.rb

On Linux, you may ignore its dependencies (e.g. gawk) if you already have them in your system:

    $ brew install --ignore-dependencies http://www.soimort.org/translate-shell/translate-shell.rb

See **[wiki: Distros](https://github.com/soimort/translate-shell/wiki/Distros)** on how to install from a specific package manager on your distro.

## Introduction by Examples

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

### Text-to-Speech

Use the `-play` (`-p`) option to listen to the translation:

    $ trans -b -p :ja "Saluton, Mondo"

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

Use the `-list` (`-L`) option to view details of one or more languages:

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

For more details on command-line options, see the man page **[trans(1)](http://www.soimort.org/translate-shell/trans.1.html)** or use `trans -M` in a terminal.

```
Usage:  trans [OPTIONS] [SOURCE]:[TARGETS] [TEXT]...

Information options:
    -V, -version
        Print version and exit.
    -H, -help
        Print help message and exit.
    -M, -man
        Show man page and exit.
    -T, -reference
        Print reference table of languages and exit.
    -R, -reference-english
        Print reference table of languages (in English names) and exit.
    -L CODES, -list CODES
        Print details of languages and exit.
    -U, -upgrade
        Check for upgrade of this program.

Display options:
    -verbose
        Verbose mode. (default)
    -b, -brief
        Brief mode.
    -d, -dictionary
        Dictionary mode.
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

Audio options:
    -p, -play
        Listen to the translation.
    -player PROGRAM
        Specify the audio player to use, and listen to the translation.
    -no-play
        Do not listen to the translation.

Terminal paging and browsing options:
    -v, -view
        View the translation in a terminal pager.
    -pager PROGRAM
        Specify the terminal pager to use, and view the translation.
    -no-view
        Do not view the translation in a terminal pager.
    -browser PROGRAM
        Specify the web browser to use.

Networking options:
    -x HOST:PORT, -proxy HOST:PORT
        Use HTTP proxy on given port.
    -u STRING, -user-agent STRING
        Specify the User-Agent to identify as.

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
    -l CODE, -lang CODE
        Specify your home language.
    -s CODE, -source CODE
        Specify the source language.
    -t CODES, -target CODES
        Specify the target language(s), joined by '+'.

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
| **[Afrikaans](http://en.wikipedia.org/wiki/Afrikaans_language)** <br/> **Afrikaans** | **`af`** | **[Hebrew](http://en.wikipedia.org/wiki/Hebrew_language)** <br/> **עִבְרִית** | **`he`** | **[Punjabi](http://en.wikipedia.org/wiki/Punjabi_language)** <br/> **ਪੰਜਾਬੀ** | **`pa`** | 
| **[Albanian](http://en.wikipedia.org/wiki/Albanian_language)** <br/> **Shqip** | **`sq`** | **[Hindi](http://en.wikipedia.org/wiki/Hindi_language)** <br/> **हिन्दी** | **`hi`** | **[Romanian](http://en.wikipedia.org/wiki/Romanian_language)** <br/> **Română** | **`ro`** | 
| **[Amharic](http://en.wikipedia.org/wiki/Amharic_language)** <br/> **አማርኛ** | **`am`** | **[Hmong](http://en.wikipedia.org/wiki/Hmong_language)** <br/> **Hmoob** | **`hmn`** | **[Romansh](http://en.wikipedia.org/wiki/Romansh_language)** <br/> **Rumantsch** | **`rm`** | 
| **[Arabic](http://en.wikipedia.org/wiki/Arabic_language)** <br/> **العربية** | **`ar`** | **[Hungarian](http://en.wikipedia.org/wiki/Hungarian_language)** <br/> **Magyar** | **`hu`** | **[Russian](http://en.wikipedia.org/wiki/Russian_language)** <br/> **Русский** | **`ru`** | 
| **[Armenian](http://en.wikipedia.org/wiki/Armenian_language)** <br/> **Հայերեն** | **`hy`** | **[Icelandic](http://en.wikipedia.org/wiki/Icelandic_language)** <br/> **Íslenska** | **`is`** | **[Samoan](http://en.wikipedia.org/wiki/Samoan_language)** <br/> **Gagana Sāmoa** | **`sm`** | 
| **[Assamese](http://en.wikipedia.org/wiki/Assamese_language)** <br/> **অসমীয়া** | **`as`** | **[Igbo](http://en.wikipedia.org/wiki/Igbo_language)** <br/> **Igbo** | **`ig`** | **[Scottish Gaelic](http://en.wikipedia.org/wiki/Scottish_language)** <br/> **Gàidhlig** | **`gd`** | 
| **[Azerbaijani](http://en.wikipedia.org/wiki/Azerbaijani_language)** <br/> **Azərbaycanca** | **`az`** | **[Indonesian](http://en.wikipedia.org/wiki/Indonesian_language)** <br/> **Bahasa Indonesia** | **`id`** | **[Serbian](http://en.wikipedia.org/wiki/Serbian_language)** <br/> **српски** | **`sr`** | 
| **[Bashkir](http://en.wikipedia.org/wiki/Bashkir_language)** <br/> **башҡорт теле** | **`ba`** | **[Interlingue](http://en.wikipedia.org/wiki/Interlingue_language)** <br/> **Interlingue** | **`ie`** | **[Sesotho](http://en.wikipedia.org/wiki/Sesotho_language)** <br/> **Sesotho** | **`st`** | 
| **[Basque](http://en.wikipedia.org/wiki/Basque_language)** <br/> **Euskara** | **`eu`** | **[Irish](http://en.wikipedia.org/wiki/Irish_language)** <br/> **Gaeilge** | **`ga`** | **[Shona](http://en.wikipedia.org/wiki/Shona_language)** <br/> **chiShona** | **`sn`** | 
| **[Belarusian](http://en.wikipedia.org/wiki/Belarusian_language)** <br/> **беларуская** | **`be`** | **[Italian](http://en.wikipedia.org/wiki/Italian_language)** <br/> **Italiano** | **`it`** | **[Sindhi](http://en.wikipedia.org/wiki/Sindhi_language)** <br/> **سنڌي** | **`sd`** | 
| **[Bengali](http://en.wikipedia.org/wiki/Bengali_language)** <br/> **বাংলা** | **`bn`** | **[Japanese](http://en.wikipedia.org/wiki/Japanese_language)** <br/> **日本語** | **`ja`** | **[Sinhala](http://en.wikipedia.org/wiki/Sinhala_language)** <br/> **සිංහල** | **`si`** | 
| **[Bosnian](http://en.wikipedia.org/wiki/Bosnian_language)** <br/> **Bosanski** | **`bs`** | **[Javanese](http://en.wikipedia.org/wiki/Javanese_language)** <br/> **Basa Jawa** | **`jv`** | **[Slovak](http://en.wikipedia.org/wiki/Slovak_language)** <br/> **Slovenčina** | **`sk`** | 
| **[Breton](http://en.wikipedia.org/wiki/Breton_language)** <br/> **Brezhoneg** | **`br`** | **[Kannada](http://en.wikipedia.org/wiki/Kannada_language)** <br/> **ಕನ್ನಡ** | **`kn`** | **[Slovenian](http://en.wikipedia.org/wiki/Slovenian_language)** <br/> **Slovenščina** | **`sl`** | 
| **[Bulgarian](http://en.wikipedia.org/wiki/Bulgarian_language)** <br/> **български** | **`bg`** | **[Kazakh](http://en.wikipedia.org/wiki/Kazakh_language)** <br/> **Қазақ тілі** | **`kk`** | **[Somali](http://en.wikipedia.org/wiki/Somali_language)** <br/> **Soomaali** | **`so`** | 
| **[Catalan](http://en.wikipedia.org/wiki/Catalan_language)** <br/> **Català** | **`ca`** | **[Khmer](http://en.wikipedia.org/wiki/Khmer_language)** <br/> **ភាសាខ្មែរ** | **`km`** | **[Spanish](http://en.wikipedia.org/wiki/Spanish_language)** <br/> **Español** | **`es`** | 
| **[Cebuano](http://en.wikipedia.org/wiki/Cebuano_language)** <br/> **Cebuano** | **`ceb`** | **[Kinyarwanda](http://en.wikipedia.org/wiki/Kinyarwanda_language)** <br/> **Ikinyarwanda** | **`rw`** | **[Sundanese](http://en.wikipedia.org/wiki/Sundanese_language)** <br/> **Basa Sunda** | **`su`** | 
| **[Cherokee](http://en.wikipedia.org/wiki/Cherokee_language)** <br/> **ᏣᎳᎩ** | **`chr`** | **[Korean](http://en.wikipedia.org/wiki/Korean_language)** <br/> **한국어** | **`ko`** | **[Swahili](http://en.wikipedia.org/wiki/Swahili_language)** <br/> **Kiswahili** | **`sw`** | 
| **[Chichewa](http://en.wikipedia.org/wiki/Chichewa_language)** <br/> **Nyanja** | **`ny`** | **[Kurdish](http://en.wikipedia.org/wiki/Kurdish_language)** <br/> **Kurdî** | **`ku`** | **[Swedish](http://en.wikipedia.org/wiki/Swedish_language)** <br/> **Svenska** | **`sv`** | 
| **[Chinese Simplified](http://en.wikipedia.org/wiki/Chinese_language)** <br/> **简体中文** | **`zh-CN`** | **[Kyrgyz](http://en.wikipedia.org/wiki/Kyrgyz_language)** <br/> **Кыргызча** | **`ky`** | **[Tajik](http://en.wikipedia.org/wiki/Tajik_language)** <br/> **Тоҷикӣ** | **`tg`** | 
| **[Chinese Traditional](http://en.wikipedia.org/wiki/Chinese_language)** <br/> **正體中文** | **`zh-TW`** | **[Lao](http://en.wikipedia.org/wiki/Lao_language)** <br/> **ລາວ** | **`lo`** | **[Tamil](http://en.wikipedia.org/wiki/Tamil_language)** <br/> **தமிழ்** | **`ta`** | 
| **[Corsican](http://en.wikipedia.org/wiki/Corsican_language)** <br/> **Corsu** | **`co`** | **[Latin](http://en.wikipedia.org/wiki/Latin_language)** <br/> **Latina** | **`la`** | **[Tatar](http://en.wikipedia.org/wiki/Tatar_language)** <br/> **татарча** | **`tt`** | 
| **[Croatian](http://en.wikipedia.org/wiki/Croatian_language)** <br/> **Hrvatski** | **`hr`** | **[Latvian](http://en.wikipedia.org/wiki/Latvian_language)** <br/> **Latviešu** | **`lv`** | **[Telugu](http://en.wikipedia.org/wiki/Telugu_language)** <br/> **తెలుగు** | **`te`** | 
| **[Czech](http://en.wikipedia.org/wiki/Czech_language)** <br/> **Čeština** | **`cs`** | **[Lithuanian](http://en.wikipedia.org/wiki/Lithuanian_language)** <br/> **Lietuvių** | **`lt`** | **[Thai](http://en.wikipedia.org/wiki/Thai_language)** <br/> **ไทย** | **`th`** | 
| **[Danish](http://en.wikipedia.org/wiki/Danish_language)** <br/> **Dansk** | **`da`** | **[Luxembourgish](http://en.wikipedia.org/wiki/Luxembourgish_language)** <br/> **Lëtzebuergesch** | **`lb`** | **[Tibetan](http://en.wikipedia.org/wiki/Tibetan_language)** <br/> **བོད་ཡིག** | **`bo`** | 
| **[Dutch](http://en.wikipedia.org/wiki/Dutch_language)** <br/> **Nederlands** | **`nl`** | **[Macedonian](http://en.wikipedia.org/wiki/Macedonian_language)** <br/> **Македонски** | **`mk`** | **[Tigrinya](http://en.wikipedia.org/wiki/Tigrinya_language)** <br/> **ትግርኛ** | **`ti`** | 
| **[Dzongkha](http://en.wikipedia.org/wiki/Dzongkha_language)** <br/> **རྫོང་ཁ** | **`dz`** | **[Malagasy](http://en.wikipedia.org/wiki/Malagasy_language)** <br/> **Malagasy** | **`mg`** | **[Turkish](http://en.wikipedia.org/wiki/Turkish_language)** <br/> **Türkçe** | **`tr`** | 
| **[English](http://en.wikipedia.org/wiki/English_language)** <br/> **English** | **`en`** | **[Malay](http://en.wikipedia.org/wiki/Malay_language)** <br/> **Bahasa Melayu** | **`ms`** | **[Turkmen](http://en.wikipedia.org/wiki/Turkmen_language)** <br/> **Türkmen** | **`tk`** | 
| **[Esperanto](http://en.wikipedia.org/wiki/Esperanto_language)** <br/> **Esperanto** | **`eo`** | **[Malayalam](http://en.wikipedia.org/wiki/Malayalam_language)** <br/> **മലയാളം** | **`ml`** | **[Ukrainian](http://en.wikipedia.org/wiki/Ukrainian_language)** <br/> **Українська** | **`uk`** | 
| **[Estonian](http://en.wikipedia.org/wiki/Estonian_language)** <br/> **Eesti** | **`et`** | **[Maltese](http://en.wikipedia.org/wiki/Maltese_language)** <br/> **Malti** | **`mt`** | **[Urdu](http://en.wikipedia.org/wiki/Urdu_language)** <br/> **اُردُو** | **`ur`** | 
| **[Faroese](http://en.wikipedia.org/wiki/Faroese_language)** <br/> **Føroyskt** | **`fo`** | **[Maori](http://en.wikipedia.org/wiki/Maori_language)** <br/> **Māori** | **`mi`** | **[Uyghur](http://en.wikipedia.org/wiki/Uyghur_language)** <br/> **ئۇيغۇر تىلى** | **`ug`** | 
| **[Fijian](http://en.wikipedia.org/wiki/Fijian_language)** <br/> **Vosa Vakaviti** | **`fj`** | **[Marathi](http://en.wikipedia.org/wiki/Marathi_language)** <br/> **मराठी** | **`mr`** | **[Uzbek](http://en.wikipedia.org/wiki/Uzbek_language)** <br/> **Oʻzbek tili** | **`uz`** | 
| **[Filipino](http://en.wikipedia.org/wiki/Filipino_language)** <br/> **Tagalog** | **`tl`** | **[Mongolian](http://en.wikipedia.org/wiki/Mongolian_language)** <br/> **Монгол** | **`mn`** | **[Vietnamese](http://en.wikipedia.org/wiki/Vietnamese_language)** <br/> **Tiếng Việt** | **`vi`** | 
| **[Finnish](http://en.wikipedia.org/wiki/Finnish_language)** <br/> **Suomi** | **`fi`** | **[Myanmar](http://en.wikipedia.org/wiki/Myanmar_language)** <br/> **မြန်မာစာ** | **`my`** | **[Volapük](http://en.wikipedia.org/wiki/Volapük_language)** <br/> **Volapük** | **`vo`** | 
| **[French](http://en.wikipedia.org/wiki/French_language)** <br/> **Français** | **`fr`** | **[Nepali](http://en.wikipedia.org/wiki/Nepali_language)** <br/> **नेपाली** | **`ne`** | **[Welsh](http://en.wikipedia.org/wiki/Welsh_language)** <br/> **Cymraeg** | **`cy`** | 
| **[Galician](http://en.wikipedia.org/wiki/Galician_language)** <br/> **Galego** | **`gl`** | **[Norwegian](http://en.wikipedia.org/wiki/Norwegian_language)** <br/> **Norsk** | **`no`** | **[Western Frisian](http://en.wikipedia.org/wiki/Western_language)** <br/> **Frysk** | **`fy`** | 
| **[Georgian](http://en.wikipedia.org/wiki/Georgian_language)** <br/> **ქართული** | **`ka`** | **[Occitan](http://en.wikipedia.org/wiki/Occitan_language)** <br/> **Occitan** | **`oc`** | **[Wolof](http://en.wikipedia.org/wiki/Wolof_language)** <br/> **Wollof** | **`wo`** | 
| **[German](http://en.wikipedia.org/wiki/German_language)** <br/> **Deutsch** | **`de`** | **[Oriya](http://en.wikipedia.org/wiki/Oriya_language)** <br/> **ଓଡ଼ିଆ** | **`or`** | **[Xhosa](http://en.wikipedia.org/wiki/Xhosa_language)** <br/> **isiXhosa** | **`xh`** | 
| **[Greek](http://en.wikipedia.org/wiki/Greek_language)** <br/> **Ελληνικά** | **`el`** | **[Oromo](http://en.wikipedia.org/wiki/Oromo_language)** <br/> **Afaan Oromoo** | **`om`** | **[Yiddish](http://en.wikipedia.org/wiki/Yiddish_language)** <br/> **ייִדיש** | **`yi`** | 
| **[Guarani](http://en.wikipedia.org/wiki/Guarani_language)** <br/> **Avañe'ẽ** | **`gn`** | **[Pashto](http://en.wikipedia.org/wiki/Pashto_language)** <br/> **پښتو** | **`ps`** | **[Yoruba](http://en.wikipedia.org/wiki/Yoruba_language)** <br/> **Yorùbá** | **`yo`** | 
| **[Gujarati](http://en.wikipedia.org/wiki/Gujarati_language)** <br/> **ગુજરાતી** | **`gu`** | **[Persian](http://en.wikipedia.org/wiki/Persian_language)** <br/> **فارسی** | **`fa`** | **[Zulu](http://en.wikipedia.org/wiki/Zulu_language)** <br/> **isiZulu** | **`zu`** | 
| **[Haitian Creole](http://en.wikipedia.org/wiki/Haitian_language)** <br/> **Kreyòl Ayisyen** | **`ht`** | **[Polish](http://en.wikipedia.org/wiki/Polish_language)** <br/> **Polski** | **`pl`** | 
| **[Hausa](http://en.wikipedia.org/wiki/Hausa_language)** <br/> **Hausa** | **`ha`** | **[Portuguese](http://en.wikipedia.org/wiki/Portuguese_language)** <br/> **Português** | **`pt`** | 


## Wiki

Lists of all languages, writing systems and fonts for reference:

* **[Languages](https://github.com/soimort/translate-shell/wiki/Languages)**
* **[Writing Systems and Fonts](https://github.com/soimort/translate-shell/wiki/Writing-Systems-and-Fonts)**

The following pages demonstrate the advanced usage of **Translate Shell**:

* **[REPL](https://github.com/soimort/translate-shell/wiki/REPL)**
* **[Text Editor Integration](https://github.com/soimort/translate-shell/wiki/Text-Editor-Integration)**
* **[Configuration](https://github.com/soimort/translate-shell/wiki/Configuration)**
* **[Themes](https://github.com/soimort/translate-shell/wiki/Themes)**

Find out whether your Linux distribution has included **Translate Shell** in its official repository. If not, contribute one:

* **[Distros](https://github.com/soimort/translate-shell/wiki/Distros)**

Frequently Asked Questions, historical stuff, AWK coding style, etc.:

* **[FAQ](https://github.com/soimort/translate-shell/wiki/FAQ)**
* **[History](https://github.com/soimort/translate-shell/wiki/History)**
* **[AWK Style Guide](https://github.com/soimort/translate-shell/wiki/AWK-Style-Guide)**

## How to Report Bugs / Contribute

**Please review the [guidelines for contributing](https://github.com/soimort/translate-shell/blob/stable/CONTRIBUTING.md) before reporting an issue or sending a pull request.**

## Disclaimer

This software is provided for the purpose of **reasonable personal use** of the Google Translate service, i.e., for those who prefer command line to web interface. For other purposes, please refer to the official [Google Translate API](https://developers.google.com/translate/).

By using this software, you ("the user") are aware that:

1. **Google Translate** is a proprietary service provided and owned by Google Inc.
2. **Translate Shell** is **NOT** a Google product. Neither this software nor its author is affiliated with Google Inc.
3. The software is provided "**AS IS**", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the software.

## Copyright Waiver

This is free and unencumbered software released into the public domain. See **[LICENSE](https://github.com/soimort/translate-shell/blob/stable/LICENSE)** and **[WAIVER](https://github.com/soimort/translate-shell/blob/stable/WAIVER)** for details.
