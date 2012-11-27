require File.join(File.dirname(__FILE__), 'phpextension')

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class PhpMongo < PHPExtension
  homepage ''
  url 'http://pecl.php.net/get/mongo-1.3.0.tgz'
  version '1.3.0'
  sha1 'cf998f166a4deeb35eedf2d288f93402d4b89a1b'
  
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
