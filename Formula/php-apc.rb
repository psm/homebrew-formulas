require File.join(File.dirname(__FILE__), 'phpextension')

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class PhpApc < PHPExtension
  homepage ''
  url 'http://pecl.php.net/get/APC-3.1.13.tgz'
  version '3.1.13'
  sha1 'cafd6ba92ac1c9f500a6c1e300bbe8819daddfae'
  
  depends_on 'autoconf' => :build
  depends_on 'php'
  
  def extension
    'apc'
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
  
  def config_file
    super + <<-EOS.undent
      apc.enabled=1
      apc.shm_segments=1
      apc.shm_size=64M
      apc.ttl=7200
      apc.user_ttl=7200
      apc.num_files_hint=1024
      apc.mmap_file_mask=/tmp/apc.XXXXXX
      apc.enable_cli=0
    EOS
  end
  
end