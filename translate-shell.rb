require "formula"

class TranslateShell < Formula
  homepage "http://www.soimort.org/translate-shell"
  url "http://www.soimort.org/translate-shell/trans"
  sha1 "9b1fdd87014c124b0e921d6431af63648cc3fc1c"
  version "0.8.22.4"

  depends_on 'fribidi'
  depends_on 'gawk'
  depends_on 'mplayer'
  depends_on 'rlwrap'

  def install
    bin.install "trans"
  end
end
