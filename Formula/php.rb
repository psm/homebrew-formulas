require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Php < Formula
  homepage ''
  url 'http://www.php.net/distributions/php-5.4.8.tar.bz2'
  version '5.4.8'
  sha1 'ed9c4e31da827af8a4d4b1adf3dfde17d11c0b34'

  # depends_on 'cmake' => :build
  depends_on :x11
  depends_on 'curl'
  depends_on 'gettext'
  depends_on 'icu4c'
  #depends_on 'jpeg'
  #depends_on 'libpng'
  #depends_on 'mcrypt'
  #depends_on 'readline'

  def config_path
    etc+"php/"
  end


  def install
    
    readline = `/usr/local/bin/brew list --versions readline`.split(/\s/).last
    
    args = "--prefix=#{prefix}",
            "--enable-fpm",
            "--sysconfdir=#{etc}/php/",
            "--with-config-file-scan-dir=#{etc}/php/config.d",
            "--enable-cli",
            "--with-config-file-path=#{etc}php/",
            "--with-libxml-dir=/usr",
            "--with-openssl=/usr",
            "--with-kerberos=/usr",
            "--with-zlib=/usr",
            "--enable-bcmath",
            "--with-bz2=/usr",
            "--enable-calendar",
            "--with-curl=/usr",
            "--enable-exif",
            "--enable-ftp",
            "--with-gd",
            "--with-jpeg-dir=/usr/local/lib",
            "--with-png-dir=/usr/X11R6",
            "--enable-gd-native-ttf",
            "--with-ldap=/usr",
            "--with-ldap-sasl=/usr",
            "--enable-mbstring",
            "--enable-mbregex",
            "--with-mysql=mysqlnd",
            "--with-mysqli=mysqlnd",
            "--with-pdo-mysql=mysqlnd",
            "--with-mysql-sock=/var/mysql/mysql.sock",
            "--with-iodbc=/usr",
            "--enable-shmop",
            "--with-snmp=/usr",
            "--enable-soap",
            "--enable-sockets",
            "--enable-sysvmsg",
            "--enable-sysvsem",
            "--enable-sysvshm",
            "--enable-wddx",
            "--with-xmlrpc",
            "--with-iconv-dir=/usr",
            "--with-xsl=/usr",
            "--enable-zip",
            "--enable-exif",
            "--enable-intl",
            "--with-icu-dir=#{Formula.factory('icu4c').prefix}",
            "--with-readline=/usr/local/Cellar/readline/#{readline}",
            "--with-gettext=#{Formula.factory('gettext').prefix}"
            "--mandir=#{man}"
    
    system "./configure", *args
    
    inreplace 'Makefile' do |s|
      s.change_make_var! "EXTRA_LIBS", "\\1 -lstdc++"
    end
    # system "cmake", ".", *std_cmake_args
    system "make"
    #ENV.deparallelize
    system "make install" # if this fails, try separate make/make install steps
    
    config_path.install "./php.ini-development" => "php.ini" unless File.exists? config_path+"php.ini"
    inreplace config_path+"php.ini" do |s|
      s.sub! /^\;date\.timezone =/, 'date.timezone = America/Mexico_City'
      s.sub! /^short_open_tag = Off/, 'short_open_tag = On'
      s.sub! /^error_reporting = E_ALL/, 'error_reporting = E_ALL & ~E_NOTICE & ~E_STRICT'
      s.sub! /^;error_log = php_errors.log/, 'error_log = /var/log/php.log'
      s.sub! ';default_charset = "UTF-8"', 'default_charset = "UTF-8"'
      s.sub! 'upload_max_filesize = 2M', 'upload_max_filesize = 20M'
    end
    
    
    
    config_path.install "sapi/fpm/php-fpm.conf"
    inreplace config_path+"php-fpm.conf" do |s|
      s.sub!(/^;?daemonize\s*=.+$/,'daemonize = no')
      s.sub!(/^;include\s*=.+$/,";include=#{config_path}/fpm.d/*.conf")
      s.sub!(/^;?pm\.max_children\s*=.+$/,'pm.max_children = 20')
      s.sub!(/^;?pm\.start_servers\s*=.+$/,'pm.start_servers = 5')
      s.sub!(/^;?pm\.min_spare_servers\s*=.+$/,'pm.min_spare_servers = 5')
      s.sub!(/^;?pm\.max_spare_servers\s*=.+$/,'pm.max_spare_servers = 20')
      s.sub! /^user\s*=.+/, "user = #{`whoami`.chomp}"
      s.sub! /^group\s*=.+/, "group = staff"
      s.sub! /^listen\s*=.+/, 'listen = /private/var/tmp/php.sock'
      s.sub! /^;?pm\.max_requests\s*=.+/, 'pm.max_requests = 500'
    end
    
    system "#{prefix}/bin/pecl config-set php_bin #{prefix}/bin/php"
    system "#{prefix}/bin/pecl config-set bin_dir #{prefix}/bin"
    system "#{prefix}/bin/pecl config-set doc_dir #{prefix}/lib/php/doc"
    system "#{prefix}/bin/pecl config-set php_dir #{prefix}/lib/php"
    system "#{prefix}/bin/pecl config-set php_ini #{config_path}php.ini"
    
  end
  
  
  def setup_launchctl
    file = plist
  end
  
  def plist; <<-EOPLIST.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-/Apple/DTD PLIST 1.0/EN" "http:/www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
    	<key>Label</key>
    	<string>net.php</string>
    	<key>KeepAlive</key>
    	<true/>
    	<key>RunAtLoad</key>
    	<false/>
    	<key>LaunchOnlyOnce</key>
    	<true/>
    	<key>ProgramArguments</key>
    	<array>
    		<string>#{sbin}/php-fpm</string>
    	</array>
    	<key>StandardErrorPath</key>
    	<string>/dev/null</string>
    	<key>StandardOutPath</key>
    	<string>/dev/null</string>
    </dict>
    </plist>
    EOPLIST
  end
    

  def test
    system "#{sbin}/php-fpm -y #{config_path}/php-fpm.conf -t"
  end
end