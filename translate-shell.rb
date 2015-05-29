require "formula"

class TranslateShell < Formula
  homepage "http://www.soimort.org/translate-shell"
  url "http://www.soimort.org/translate-shell/translate-shell.tar.gz"
  sha1 "9608a03c435b1228b9ba8c6ea5e530bd3a415879"
  version "0.9.0.5"

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
