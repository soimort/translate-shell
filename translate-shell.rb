require "formula"

class TranslateShell < Formula
  homepage "http://www.soimort.org/translate-shell"
  url "http://www.soimort.org/translate-shell/translate-shell.tar.gz"
  sha1 "9a2951ed60ae448a3ef9d9275751fa209e4db175"
  version "0.8.22.5"

  depends_on 'fribidi' => :optional
  depends_on 'gawk'
  depends_on 'mplayer'
  depends_on 'rlwrap'

  def install
    bin.install "trans"
    man1.install "trans.1"
  end
end
