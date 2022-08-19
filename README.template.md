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

    antigen bundle soimort/translate-shell

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
$usage$
```

## Code List

Use `trans -R` or `trans -T` to view the reference table in a terminal.

For more details on languages and corresponding codes, see **[wiki: Languages](https://github.com/soimort/translate-shell/wiki/Languages)**.

$code-list$

## Wiki

$wiki-home$

## Reporting Bugs / Contributing

Please review the [guidelines for contributing](https://github.com/soimort/translate-shell/blob/stable/CONTRIBUTING.md) before reporting an issue or sending a pull request.

## Licensing

This is free and unencumbered software released into the public domain. See **[LICENSE](https://github.com/soimort/translate-shell/blob/stable/LICENSE)** and **[WAIVER](https://github.com/soimort/translate-shell/blob/stable/WAIVER)** for details.
