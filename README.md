# Google Translate to serve as a command line tool

[![Build Status](https://travis-ci.org/soimort/google-translate-cli.png?branch=master)](https://travis-ci.org/soimort/google-translate-cli)

[google-translate-cli](https://github.com/soimort/google-translate-cli) is a 100-line AWK program to let you use Google Translate without a web browser, i.e., from the terminal.

    $ translate {en=zh} "You want me to spoon-feed it to you? This is so f*cking easy to use."
    你要我用汤匙喂到你吗？这是那么他妈的容易使用。

## Dependencies

All you need is [GNU awk](http://www.gnu.org/software/gawk/) (3.1+) to run this program. No Google API Key is required.

## Installation

### Manually

`translate.awk` is a runnable AWK script. Feel free to copy it to anywhere in your `$PATH` and rename it whatever you like.

On Mac OS X and FreeBSD, you may want to change the shebang from:

    #!/usr/bin/gawk -f

to:

    #!/usr/bin/env gawk -f

### Automatically

#### GNU/Linux, Windows (Cygwin)

    $ git clone git://github.com/soimort/google-translate-cli.git
    $ cd google-translate-cli/
    $ make install

#### OS X, FreeBSD

Firstly, install GNU awk (if necessary). The original BSD awk will not work.

    $ git clone git://github.com/soimort/google-translate-cli.git
    $ cd google-translate-cli/
    $ make install

#### Windows (MinGW)

Firstly, install GNU awk (if necessary),

    $ mingw-get install msys-gawk

Then put `translate.awk` into your `$PATH`,

    $ git clone git://github.com/soimort/google-translate-cli.git
    $ cd google-translate-cli/
    $ cp translate.awk /bin/trs

## Usage

    $ trs
    Usage: translate {[SL]=[TL]} TEXT|TEXT_FILENAME
           translate {[SL]=[TL1]+[TL2]+...} TEXT|TEXT_FILENAME
           translate TEXT1 TEXT2 ...

    TEXT: Source text (The text to be translated)
          Can also be the filename of a plain text file.
      SL: Source language (The language of the source text)
      TL: Target language (The language to translate the source text into)
          Language codes as listed here:
        * http://developers.google.com/translate/v2/using_rest#language-params
          Ignore the code where you want the system to identify it for you.
          Prefix the code with an ampersat @ to show the result phonetically.

## Examples

Translate anything of any language into English.

    $ trs Weltschmerz
    world-weariness

    $ trs Weltschmerz コスプレ "Bon appétit." 周星馳
    world-weariness
    Cosplay
    Good appetite.
    Stephen Chow

Translate "Hello, world" into Esperanto.

    $ trs {=eo} "Hello, world"
    Saluton, mondo

Translate "Hello, world" into Chinese, Japanese, Korean and Thai.

    $ trs {=zh+ja+ko+th} "Hello, world"
    您好，世界
    世界よこんにちは
    안녕하세요, 세계
    สวัสดีโลก

Translate a Latin phrase into English.

    $ trs {la=} "Ego sum qui sum."
    I am who I am.

Translate Japanese to French.

    $ trs {ja=fr} "愛してる。"
    Je t'aime!

Show the phonetics of a Japanese quote and translate it into both English and Traditional Chinese.

    $ trs {ja=@ja+en+zh-TW} "あなたは死なないわ、私が守るもの。"
    Anata wa shinanai wa, watashi ga mamoru mono. 
    What you'll not die, I will protect you.
    你會不會死，我會保護你。

Translate an English context text file into Chinese.

e.g. `POETRY.txt`:

    Afternoon Of Circus And Citadel
    by Paul Celan

    In Brest, before the Fire-Hoops burning,
    In the Tent, where Tigers sprang,
    there I heard you, Finite, singing,
    there I saw you, Mandelstam.

    The Sky hung over the Roadstead,
    the Gull, hung over the Crane.
    The Finite sang there, the Constant –
    you, the Gunboat, Baobab.

    I hailed the Tricolor
    with a Russian Word –
    the Lost was Un-Lost,
    the Heart Anchored there.

The translation is streamed to standard output.

    $ trs {=zh} POETRY.txt
    下午，广场和城堡
    由保罗·策兰

    在布雷斯特，消防篮球燃烧前，
    在帐篷里，老虎窜出，
    在那里，我听到你的，有限的，唱歌，
    在那里，我看到你，曼德尔施塔姆。

    挂在天空的锚地，
    沙鸥，挂在起重机上。
    有限唱在那里，恒 - 
    你，的炮舰，猴面包树。

    我欢呼三色旗
    与俄罗斯词 - 
    失落的是联合国忘了，
    心锚。
    

## Language Code Reference

See <https://developers.google.com/translate/v2/using_rest#language-params>.

## Important Notes

* Be careful with shell special characters. In most cases, putting them inside a pair of ___single quotation marks___ is safe.

* You may NOT use exclamation marks `!` ([as well as](http://www.gnu.org/software/bash/manual/html_node/Double-Quotes.html) `$`, <code>&#96;</code> and `\`) inside _double quotes_ without escaping them; the shell will complain.  
Here is an example (non-working):

    `$ trs {=de} "Damn it! I'm not working!"`

  Instead, you use:

    `$ trs {=de} "Bazinga\! I'm working now\!"`

* You should NOT be using `[` nor `]` on any occasions.

* Don't get one source text too long (and when reading from a text file, don't get one line too long). The query string is encoded into URIs and overlength may lead to unexpected lost.

## Additional Tips for Vim Users

Add a line to your `~/.vimrc`: (feel free to use any language codes as you like)

    set keywordprg=trs\ {ja=@ja+en}

Afterwards you could press `Shift-K` to see the translation of the word under the cursor.

![](http://i.imgur.com/OK2UYyn.gif)
