require 'formula'

class Expat < Formula
  homepage 'http://expat.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/expat/expat/2.1.0/expat-2.1.0.tar.gz'
  sha1 'b08197d146930a5543a7b99e871cba3da614f6f0'

  bottle do
    root_url "https://dl.dropboxusercontent.com/u/79581979/tigerbrew"
    sha1 "f6ead982ec2d00eec6772cb6cc2c4b246fb11c5e" => :tiger_g3
    sha1 "4e8738f61c4cdb18b9278c3fc9c9e9a5e56371ab" => :tiger_altivec
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end

  def caveats
    "Note that OS X has Expat 1.5 installed in /usr already."
  end
end
