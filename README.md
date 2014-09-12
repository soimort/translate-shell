# Translate Shell

[![Build Status](https://travis-ci.org/soimort/translate-shell.png)](https://travis-ci.org/soimort/translate-shell)

[Translate Shell](http://www.soimort.org/translate-shell) is a command-line interface and interactive shell for [Google Translate](https://translate.google.com/). It works just the way you want it to be.

```
$ trans "Saluton, Mondo"
Hello, World

Translations of Saluton, Mondo
(Esperanto -> English)
Saluton(Hello/Hail/Hi/A greeting/Saluton) , Mondo(, World)
```

Translations with detailed explanations are shown by default. You can also translate the text briefly, i.e., only the most relevant translation is shown: (this will give you the same result as in [Google Translate CLI Legacy](https://github.com/soimort/translate-shell/tree/legacy))

```
$ trans -b "Saluton, Mondo"
Hello, World
```

Translations can be done interactively; input your text line by line:

```
$ trans -b -I
> Was mich nicht umbringt, macht mich stärker.
What does not kill me makes me stronger.
> Юмор есть остроумие глубокого чувства.
Humor is a deep sense of wit.
> 學而不思則罔，思而不學則殆。
Learning without thought is labor lost, thought without learning is perilous.
> 幸福になるためには、人から愛されるのが一番の近道。
In order to be happy, the shortest way is from being loved by the people.
```

**Translate Shell** is a complete rewrite of [Google Translate CLI Legacy](https://github.com/soimort/translate-shell/tree/legacy), which is a tiny script written in 100 lines of AWK code. Translate Shell is backward compatible with Google Translate CLI Legacy in its command-line usage; furthermore, it provides more functionality including verbose translation, Text-to-Speech and interactive mode, etc.

## Prerequisites

### System Requirements

Any POSIX-compliant system should work, including but not limited to:

* GNU/Linux
* BSD family, including OS X
* illumos family, including SmartOS
* Cygwin on Windows

### Dependencies

* [GNU Awk](https://www.gnu.org/software/gawk/) (gawk) `>=4.0`
    * This program relies heavily on GNU-only extensions of the AWK language, which are not possible with POSIX AWK or other AWK implementations.
    * gawk comes with (almost) all GNU/Linux distributions. On BSD systems, it is available in ports. On OS X, it is available in MacPorts and Homebrew.
    * If you have an older version of gawk (`>=3.1`), you may still want to use [Google Translate CLI Legacy](https://github.com/soimort/translate-shell/tree/legacy).
    * Be aware that msys-gawk shipped with MinGW is outdated; however, you may still use Google Translate CLI Legacy as well.

### Optional Dependencies

* [GNU Bash](http://www.gnu.org/software/bash/) or [Zsh](http://www.zsh.org/)
    * You can use Translate Shell from any modern Unix shell of your choice (bash, zsh, ksh, tcsh, fish, etc.); however, it requires either bash or zsh installed for interpreting the wrapper script.
* [GNU FriBidi](http://fribidi.org/): an implementation of the Unicode Bidirectional Algorithm (bidi)
    * needed for displaying right-to-left (RTL) languages
* [MPlayer](http://www.mplayerhq.hu/), [mpg123](http://mpg123.org/), or [eSpeak](http://espeak.sourceforge.net/)
    * needed for the Text-to-Speech functionality
* [rlwrap](http://utopia.knoware.nl/~hlub/uck/rlwrap/#rlwrap): a GNU readline wrapper
    * needed for readline-style editing and history in the interactive mode
* [groff](http://www.gnu.org/software/groff/): GNU troff (pre-installed on most systems)
    * needed for formatting man pages
* [GNU Emacs](http://www.gnu.org/software/emacs/)
    * for using the Emacs interface

### Environment and Encoding

It is strongly recommended that you use UTF-8 codeset for your default locale, as it potentially supports all languages. You can check if your codeset is UTF-8 using:

    $ echo $LANG
    en_US.UTF-8

And you need to have necessary Unicode fonts installed for the languages you want to display.

## Try It Out

As long as you have `gawk` already, you're good to go!

    $ gawk "$(curl -Ls git.io/translate)" -I

## Installation

### Direct Download

Download [this executable](http://git.io/trans) and place it into your path.

    $ wget git.io/trans
    $ chmod +x ./trans

### From Homebrew

    $ brew install http://www.soimort.org/translate-shell/translate-shell.rb

### From Git

    $ git clone https://github.com/soimort/translate-shell
    $ cd translate-shell/
    $ make install

By default, a bash script `trans` will be installed to your `/usr/bin`. If you prefer to use zsh, you can specify zsh as the build target:

    $ make TARGET=zsh install

You can specify the installation path too:

    $ make INSTDIR=~/bin install

## Examples

### Translate a Word

#### From any language to your language

Google Translate will detect the language of the source text automatically, and Translate Shell will translate it into the language of your locale.

    $ trans vorto

#### From any language to one or more specific languages

Translate a word into French:

    $ trans :fr word

Translate a word into Chinese and Japanese: (use a plus sign "`+`" as the delimiter)

    $ trans :zh+ja word

You can use an equals sign ("`=`") in place of "`:`". The traditional way of using a pair of curly brackets in Google Translate CLI Legacy is still supported: (depending on your shell)

    $ trans {=zh+ja} word

You can also use the `-target` option to specify this:

    $ trans -t zh+ja word

#### From a specific language

Google Translate could identify the language of the source text incorrectly; in that case, you will need to specify the language yourself:

    $ trans :en 手紙
    $ trans ja:en 手紙
    $ trans zh:en 手紙

You can also use the `-source` option to specify this:

    $ trans -s ja -t en 手紙

### Translate Multiple Words or a Phrase

Translate each word alone:

    $ trans en:zh freedom of speech

Put words into one argument and translate them as a whole:

    $ trans en:zh "freedom of speech"

### Translate a Sentence

Translating a sentence is much the same like translating a phrase; you can quote words into one argument:

    $ trans :zh "Words will always retain their power."
    $ trans :zh 'Words will always retain their power.'

To avoid punctuation marks and other special characters (e.g. "`!`") being interpreted by the shell, use *single quotes*:

    $ trans :zh 'Yes we can!'

There are some cases though, you may still want to use *double quotes*: (i.e. the sentence contains a single quotation mark "`'`")

    $ trans :zh "I'm lovin' it! McDonald's"

### Brief Mode

By default, Translate Shell displays translations in a verbose manner. If you prefer to see only the most relevant translation, you can fallback to brief mode using the `-brief` option:

    $ trans :fr -b "Saluton, Mondo"

In brief mode, phonetic notation (for some languages) is not shown by default. To enable this, put an at sign "`@`" in front of the language code:

    $ trans :@ja -b "Saluton, Mondo"

### Text-to-Speech

Use the `-play` option to listen to the translation:

    $ trans :ja -b -p "Saluton, Mondo"

### Right-to-Left (RTL) Languages

You can use the `-width` option to specify the screen width for padding when displaying right-to-left languages, if you want:

    $ trans :he -b -w 40 "Saluton, Mondo"

### Input and Output

When no non-option argument is given, Translate Shell will read from standard input, or from the file specified by the `-input` option:

    $ echo "Saluton, Mondo" | trans :fr -b
    $ trans :fr -b -i input.txt

Translations will be written to standard output, or to the file specified by the `-output` option:

    $ echo "Saluton, Mondo" | trans :fr -b -o output.txt

### Interactive Mode

Start an interactive shell, using the `-interactive` option:

    $ trans -I

## Text Editors

`trans` is just a command-line program which you can easily integrate with your favorite text editor. Any way you want.

Below are some might-be-useful tips. Feel free to roll your own Emacs mode or Vim script!

### Emacs

#### Interactive shell

You can, of course, use Emacs as a front-end of Translate Shell, in the same way you emulate your favorite shell with `M-x shell`. There is a shortcut for starting Emacs with Translate Shell, using the `-emacs` option:

    $ trans -E

#### Text translation

When editing a text file, viewing the translation of a region is just one single command: (translating any language to Japanese, for example)

`M-| trans :ja`

### Vim

#### Text translation

Add one line to your `~/.vimrc`:

    set keywordprg=trans\ :ja

Use `Shift-K` to view the translation of the word under the cursor.

## Usage

Use `$ trans -H` to view the [detailed man page](http://www.soimort.org/translate-shell/trans.1.html).

```
Usage: trans [options] [source]:[target] [text] ...
       trans [options] [source]:[target1]+[target2]+... [text] ...

Options:
  -V, -version
    Print version and exit.
  -H, -h, -help
    Show this manual, or print this help message and exit.
  -r, -reference
    Print a list of languages (displayed in endonyms) and their ISO 639 codes for reference, and exit.
  -R, -reference-english
    Print a list of languages (displayed in English names) and their ISO 639 codes for reference, and exit.
  -v, -verbose
    Verbose mode. (default)
  -b, -brief
    Brief mode.
  -w [num], -width [num]
    Specify the screen width for padding when displaying right-to-left languages.
  -p, -play
    Listen to the translation.
  -player [program]
    Specify the command-line audio player to use, and listen to the translation.
  -I, -interactive
    Start an interactive shell, invoking `rlwrap` whenever possible (unless `-no-rlwrap` is specified).
  -no-rlwrap
    Don't invoke `rlwrap` when starting an interactive shell with `-I`.
  -E, -emacs
    Start an interactive shell within GNU Emacs, invoking `emacs`.
  -prompt [prompt_string]
    Customize your prompt string in the interactive shell.
  -prompt-color [color_code]
    Customize your prompt color in the interactive shell.
  -i [file], -input [file]
    Specify the input file name.
  -o [file], -output [file]
    Specify the output file name.
  -l [code], -lang [code]
    Specify your own, native language ("home/host language").
  -s [code], -source [code]
    Specify the source language (language of the original text).
  -t [codes], -target [codes]
    Specify the target language(s) (language(s) of the translated text).

See the man page trans(1) for more information.
```

## Environment Variables

You can export some environment variables as your default configuration. This will save you from typing the same command-line options each time.

* `BROWSER`: for option `-browser`
* `PLAYER`: for option `-player`
* `HTTP_PROXY` and `http_proxy`: for option `-proxy`
* `TRANS_PS`: for option `-prompt`
* `TRANS_PS_COLOR`: for option `-prompt-color`
* `HOME_LANG`: for option `-l`
* `SOURCE_LANG`: for option `-s`
* `TARGET_LANG`: for option `-t`

Example:

    $ export TARGET_LANG=zh
    $ trans text
    $ trans word

## Language Codes

Use `$ trans -R` to view the list of language codes.

```
┌───────────────────────┬──────────────────────┬─────────────────┐
│ Afrikaans     - af    │ Greek          - el  │ Mongolian  - mn │
│ Albanian      - sq    │ Gujarati       - gu  │ Nepali     - ne │
│ Arabic        - ar    │ Haitian Creole - ht  │ Norwegian  - no │
│ Armenian      - hy    │ Hausa          - ha  │ Persian    - fa │
│ Azerbaijani   - az    │ Hebrew         - he  │ Polish     - pl │
│ Basque        - eu    │ Hindi          - hi  │ Portuguese - pt │
│ Belarusian    - be    │ Hmong          - hmn │ Punjabi    - pa │
│ Bengali       - bn    │ Hungarian      - hu  │ Romanian   - ro │
│ Bosnian       - bs    │ Icelandic      - is  │ Russian    - ru │
│ Bulgarian     - bg    │ Igbo           - ig  │ Serbian    - sr │
│ Catalan       - ca    │ Indonesian     - id  │ Slovak     - sk │
│ Cebuano       - ceb   │ Irish          - ga  │ Slovenian  - sl │
│ Chinese Simp. - zh-CN │ Italian        - it  │ Somali     - so │
│ Chinese Trad. - zh-TW │ Japanese       - ja  │ Spanish    - es │
│ Croatian      - hr    │ Javanese       - jv  │ Swahili    - sw │
│ Czech         - cs    │ Kannada        - kn  │ Swedish    - sv │
│ Danish        - da    │ Khmer          - km  │ Tamil      - ta │
│ Dutch         - nl    │ Korean         - ko  │ Telugu     - te │
│ English       - en    │ Lao            - lo  │ Thai       - th │
│ Esperanto     - eo    │ Latin          - la  │ Turkish    - tr │
│ Estonian      - et    │ Latvian        - lv  │ Ukrainian  - uk │
│ Filipino      - tl    │ Lithuanian     - lt  │ Urdu       - ur │
│ Finnish       - fi    │ Macedonian     - mk  │ Vietnamese - vi │
│ French        - fr    │ Malay          - ms  │ Welsh      - cy │
│ Galician      - gl    │ Maltese        - mt  │ Yiddish    - yi │
│ Georgian      - ka    │ Maori          - mi  │ Yoruba     - yo │
│ German        - de    │ Marathi        - mr  │ Zulu       - zu │
└───────────────────────┴──────────────────────┴─────────────────┘
```

## FAQ

* **Q**: *How many languages does Google Translate support?*

* **A**: 80 languages, as far as we know. There are 81 distinct language codes in total (including two codes for the Chinese language). A few aliases of these codes exist.

* **Q**: *What are these language codes?*

* **A**: A language code is used to identify a language. Most of these codes are ISO 639-1 codes (alpha-2), consisted of two alphabet letters; very few languages supported by Google Translate use the ISO 639-2 code (alpha-3), e.g., Hmong (`hmn`); the Chinese language has two language codes, distinguished by the uppercase region code after its ISO 639-1 code.

* **Q**: *Why are there two codes for Chinese? When to use them?*

* **A**: Two writing systems exist for the Chinese language: Simplified Chinese (`zh-CN`), used in China and Singapore; and Traditional Chinese (`zh-TW`), used in Taiwan and Hong Kong. Language code "`zh`" is an alias of "`zh-CN`".

* **Q**: *What about writing systems? What is the writing system of my language?*

* **A**: Some languages other than Chinese, also have multiple writing systems. Unfortunately, Google Translate seems to support only one of them:
    * Belarusian (`be`): Cyrillic alphabet
    * Bosnian (`bs`): Latin alphabet
    * Hausa (`ha`): Latin / Boko alphabet
    * Javanese (`jv` or `jw`): Latin alphabet
    * Mongolian (`mn`): Cyrillic alphabet
    * Punjabi (`pa`): Brahmic / Gurmukhī alphabet
    * Serbian (`sr`): Cyrillic alphabet

* **Q**: *What are right-to-left (RTL) languages, and why do I need GNU FriBidi for them?*

* **A**: 5 languages supported by Google Translate are written from right to left. In order to display bi-directional text correctly for these languages, GNU FriBidi, which implements Unicode bidirectional algorithm, will be used:
    * Arabic (`ar`)
    * Persian (`fa`)
    * Hebrew (`he` or `iw`)
    * Urdu (`ur`)
    * Yiddish (`yi` or `ji`)

* **Q**: *What is my "home" language?*

* **A**: By default, home language is set to the language of your current locale (i.e. environment variable `LANG`). It will affect the display in verbose mode. If you are comfortable with your current locale (e.g. `en_US.UTF-8`), just leave it alone.

* **Q**: *What is the target language, if I don't specify one?*

* **A**: If no target language is specified, text will be translated into the language of your locale, i.e., your most preferable language.

* **Q**: *I tried to translate some very long text but failed to get the complete translation.*

* **A**: There is a limit of length for each translation. As a general suggestion, don't try to do everything in one hit. Split your text into sentences or lines and translate one at a time.

* **Q**: *My terminal does not support ANSI escape sequences and the display looks like a mess. How do I disable them?*

* **A**: Translate Shell uses ANSI escape sequences to display colors and other effects. You can disable them by telling Translate Shell that your terminal type is dumb: `$ TERM=dumb trans ...`

## Licensing

This is free and unencumbered software released into the public domain.
