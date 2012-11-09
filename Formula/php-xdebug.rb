require File.join(File.dirname(__FILE__), 'phpextension')

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class PhpXdebug < PHPExtension
  homepage ''
  url 'http://xdebug.org/files/xdebug-2.2.1.tgz'
  version '2.2.1'
  sha1 '8b4aec5f68f2193d07bf4839ee46ff547740ed7e'
  
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