require File.join(File.dirname(__FILE__), 'phpextension')

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class PhpImagick < PHPExtension
  homepage ''
  url 'http://pecl.php.net/get/imagick-3.1.0RC2.tgz'
  version '3.1.0RC2'
  sha1 'cafd6ba92ac1c9f500a6c1e300bbe8819daddfae'
  
  depends_on 'autoconf' => :build
  depends_on 'php'
  
  def extension
    'imagick'
  end
  
  def install
    # ENV.j1  # if your formula's build system can't parallelize
    Dir.chdir "#{extension}-#{version}"
    system "#{(Formula.factory 'php').bin}/phpize"
    system "./configure"
    system "make"
    prefix.install "modules/#{extension}.so"
    write_config_file
  end

end