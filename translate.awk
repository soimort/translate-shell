#!/usr/bin/gawk -f

# This is free and unencumbered software released into the
# public domain.
#
# This software is provided for the purpose of personal, reasonable
# and convenient human use of the Google Translate Service, i.e.,
# only for those who feel that their terminal is more accessible
# than a web browser. For other purposes, please use the official
# Google Translate API <https://developers.google.com/translate/>.
#
# By using this software, you ("the user") agree that:
#
# 1. Neither this software nor its author is affiliated with
# Google Inc. ("Google").
#
# 2. By using this software, the user is de facto using web
# services provided by Google, therefore they are obliged to
# follow the Google Terms of Service.
#
# 3. This software is provided "as is". The user of this software
# shall be fully liable for any possible infringement of, including
# but not limited to, the Google Terms of Service; per contra,
# the user must be aware that their data might be collected by
# Google, therefore they shall be liable for their own privacy
# concern, including but not limited to, possible disclosure of
# personal information. See the (un)LICENSE file for more details.

@include "metainfo"

@include "include/Commons"
@include "include/Utils"

@include "include/Languages"
@include "include/Help"
@include "include/Tokenizer"
@include "include/Parser"
@include "include/Theme"
@include "include/Translate"
@include "include/Script"
@include "include/REPL"

@include "include/Main"
