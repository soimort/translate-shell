#!/usr/bin/gawk -f

@include "metainfo.awk"

@include "include/Commons.awk"
@include "include/Utils.awk"

@include "include/Languages.awk"
@include "include/Help.awk"
@include "include/Parser.awk"
@include "include/Theme.awk"

@include "include/Translate.awk"
@include "include/TranslatorInterface.awk"
@include "include/Translators/*"

@include "include/Script.awk"
@include "include/REPL.awk"

@include "include/Main.awk"
