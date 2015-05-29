require "formula"

class TranslateShell < Formula
  homepage "http://www.soimort.org/translate-shell"
  url "http://www.soimort.org/translate-shell/translate-shell.tar.gz"
  sha1 "32e35704c5d6f1f6ce2bc130967a574ac220d767"
  version "0.9.0.6"

  depends_on 'curl' => :optional
  depends_on 'fribidi' => :optional
  depends_on 'gawk'
  depends_on 'mplayer'
  depends_on 'rlwrap'

  def install
    bin.install "trans"
    man1.install "trans.1"
  end
end
