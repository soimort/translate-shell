# How to Contribute

## Reporting an Issue

Please include:

* Your exact command line
* The output of `trans -version` on your system
* Any other information you think might be helpful

in your bug report.

## Sending a Pull Request

This is a [public domain](https://en.wikipedia.org/wiki/Public_domain) software, which means the author(s) do not retain any and all copyright interest in any piece of code in this software.

You are welcome to fork this repository and use it any way you want. However, if you want to send a pull request to this repository, you must agree that:

```
I dedicate any and all copyright interest in this software to the
public domain. I make this dedication for the benefit of the public at
large and to the detriment of my heirs and successors. I intend this
dedication to be an overt act of relinquishment in perpetuity of all
present and future rights to this software under copyright law.
```

If you wish to contribute any non-trivial patch to the project, you will be asked to sign the above copyright waiver using GnuPG, as follows: (you can find the [WAIVER](https://github.com/soimort/translate-shell/blob/develop/WAIVER) file in the repository)

```sh
$ gpg --no-version --armor --sign WAIVER
```

Rename your signature `WAIVER.asc` to `[Your GitHub handle].asc` and put it into [misc/AUTHORS](https://github.com/soimort/translate-shell/blob/develop/misc/AUTHORS). Include this file in your pull request.
