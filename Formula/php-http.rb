require File.join(File.dirname(__FILE__), 'phpextension')

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class PhpHttp < PHPExtension
  homepage ''
  url 'http://pecl.php.net/get/pecl_http-1.7.4.tgz'
  version '1.7.4'
  sha1 '3a2276c765fccb58ae0a96e71bde26657952d139'
  
  depends_on 'autoconf' => :build
  depends_on 'php'
  
  def extension
    'http'
  end
  
  def install
    # ENV.j1  # if your formula's build system can't parallelize
    Dir.chdir "pecl_#{extension}-#{version}"
    system "#{(Formula.factory 'php').bin}/phpize"
    system "./configure"
    system "make"
    prefix.install "modules/#{extension}.so"
    write_config_file
  end

end