require File.join(File.dirname(__FILE__), 'phpextension')

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class PhpXdebug < PHPExtension
  homepage ''
  url 'http://pecl.php.net/get/xdebug-2.2.3.tgz'
  version '2.2.3'
  #sha1 '045dee86f69051d7944da594db648b337a97f48a'
  
  depends_on 'autoconf' => :build
  depends_on 'php'
  
  def extension
    'xdebug'
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
  
  def kind
    'zend_extension'
  end
  
  def config_file
    super + <<-EOS.undent
      xdebug.profiler_enable = 1
      xdebug.profiler_output_dir = /tmp
      xdebug.file_link_format="txmt://open?url=file://%f&line=%l"
    EOS
  end
  
end