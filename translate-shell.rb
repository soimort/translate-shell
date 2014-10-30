require "formula"

class TranslateShell < Formula
  homepage "http://www.soimort.org/translate-shell"
  url "http://www.soimort.org/translate-shell/trans"
  sha1 "064ff00bbf00975668c5cc758583aea5c838090d"
  version "0.8.22"

  depends_on 'fribidi'
  depends_on 'gawk'
  depends_on 'mplayer'
  depends_on 'rlwrap'

  def install
    bin.install "trans"
  end
end
