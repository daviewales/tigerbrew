require 'formula'

class Curl < Formula
  homepage 'http://curl.haxx.se/'
  url 'http://curl.haxx.se/download/curl-7.36.0.tar.gz'
  mirror 'ftp://ftp.sunet.se/pub/www/utilities/curl/curl-7.36.0.tar.gz'
  sha256 '33015795d5650a2bfdd9a4a28ce4317cef944722a5cfca0d1563db8479840e90'

  bottle do
    root_url "https://dl.dropboxusercontent.com/u/79581979/tigerbrew"
    revision 1

    sha1 "26d3daf62ff3fa45bd70c1d9a109345ad2c84d8e" => :tiger_g3
    sha1 "4a4b4d763281c388da1b8d3ac5c769cba0735da1" => :tiger_altivec
    sha1 "8a1b1b423dedceb0f4d97759dbdf46432b67f9aa" => :leopard_g3
    sha1 "cb373615f050e52723ef943f26470adcfa77f372" => :leopard_altivec
  end

  keg_only :provided_by_osx

  option 'with-ssh', 'Build with scp and sftp support'
  option 'with-ares', 'Build with C-Ares async DNS support'
  option 'with-gssapi', 'Build with GSSAPI/Kerberos authentication support.'

  if MacOS.version >= :mountain_lion
    option 'with-openssl', 'Build with OpenSSL instead of Secure Transport'
    depends_on 'openssl' => :optional
  else
    depends_on 'openssl'
  end

  depends_on 'pkg-config' => :build

  depends_on 'libmetalink' => :optional
  depends_on 'libssh2' if build.with? 'ssh'
  depends_on 'c-ares' if build.with? 'ares'
  depends_on 'curl-ca-bundle' if MacOS.version < :snow_leopard

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if MacOS.version < :mountain_lion or build.with? "openssl"
      args << "--with-ssl=#{Formula["openssl"].opt_prefix}"
    else
      args << "--with-darwinssl"
    end

    args << "--with-libssh2" if build.with? 'ssh'
    args << "--with-libmetalink" if build.with? 'libmetalink'
    args << "--enable-ares=#{Formula["c-ares"].opt_prefix}" if build.with? 'ares'
    args << "--with-gssapi" if build.with? 'gssapi'

    # Tiger/Leopard ship with a horrendously outdated set of certs,
    # breaking any software that relies on curl, e.g. git
    args << "--with-ca-bundle=#{HOMEBREW_PREFIX}/share/ca-bundle.crt" if MacOS.version < :snow_leopard

    system "./configure", *args
    system "make install"
  end
end
