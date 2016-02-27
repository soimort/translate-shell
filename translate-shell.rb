require "formula"

class TranslateShell < Formula
  homepage "http://www.soimort.org/translate-shell"
  url "http://www.soimort.org/translate-shell/translate-shell.tar.gz"
  sha1 "1645f392de7ab16d4e2ca112878e8428f9545b6d"
  version "0.9.3.1"

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
