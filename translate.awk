#!/usr/bin/gawk -f

@include "metainfo"

@include "include/Commons"
@include "include/Utils"

@include "include/Languages"
@include "include/Help"
@include "include/Parser"
@include "include/Theme"
@include "include/Translate"
@include "include/Script"
@include "include/REPL"

@include "include/Translators/GoogleTranslate"
@include "include/Translators/BingTranslator"

@include "include/Main"
