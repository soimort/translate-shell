require "formula"

class TranslateShell < Formula
  homepage "http://www.soimort.org/translate-shell"
  url "http://www.soimort.org/translate-shell/translate-shell.tar.gz"
  sha1 "0f74f41c696291651a0c15211ec70de5194109f8"
  version "0.9.2"

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
