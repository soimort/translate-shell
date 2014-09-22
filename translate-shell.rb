require "formula"

class TranslateShell < Formula
  homepage "http://www.soimort.org/translate-shell"
  url "http://www.soimort.org/translate-shell/trans"
  sha1 "1e41de455370d0503fe55c63c53841f15491bf09"
  version "0.8.21"

  depends_on 'fribidi'
  depends_on 'gawk'
  depends_on 'mplayer'
  depends_on 'rlwrap'

  def install
    bin.install "trans"
  end
end
