require File.join(File.dirname(__FILE__), 'phpextension')

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class PhpMongo < PHPExtension
  homepage ''
  url 'http://pecl.php.net/get/mongo-1.4.0.tgz'
  version '1.4.0'
  sha1 'f92e5d5becc48c508fe80ac54700099517066c8e'
  
  depends_on 'autoconf' => :build
  depends_on 'php'
  
  def extension
    'mongo'
  end
  
  def install
    # ENV.j1  # if your formula's build system can't parallelize
    Dir.chdir "mongo-#{version}"
    system "#{(Formula.factory 'php').bin}/phpize"
    system "./configure"
    system "make"
    prefix.install "modules/mongo.so"
    write_config_file
  end
  
end
