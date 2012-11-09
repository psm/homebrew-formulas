require File.join(File.dirname(__FILE__), 'phpextension')

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class PhpImagick < PHPExtension
  homepage ''
  url 'http://pecl.php.net/get/imagick-3.1.0RC2.tgz'
  version '3.1.0RC2'
  sha1 '29b6dcd534cde6b37ebe3ee5077b71a9eed685c2'
  
  depends_on 'autoconf' => :build
  depends_on 'php'
  depends_on 'imagemagick'
  
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