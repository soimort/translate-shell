require "formula"

class TranslateShell < Formula
  homepage "http://www.soimort.org/translate-shell"
  url "http://www.soimort.org/translate-shell/trans"
  sha1 "bccc5d9dc8407aa91e40edf372005e69095cafa4"
  version "0.8.19"

  depends_on 'fribidi'
  depends_on 'gawk'
  depends_on 'mplayer'
  depends_on 'rlwrap'

  def install
    bin.install "trans"
  end
end
