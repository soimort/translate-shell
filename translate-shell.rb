require "formula"

class TranslateShell < Formula
  homepage "http://www.soimort.org/translate-shell"
  url "http://www.soimort.org/translate-shell/trans"
  sha1 "5ad43a589c8b1e8373c5b961b62e2510173a65dd"
  version "0.8.22"

  depends_on 'fribidi'
  depends_on 'gawk'
  depends_on 'mplayer'
  depends_on 'rlwrap'

  def install
    bin.install "trans"
  end
end
