require 'formula'

class PHPExtension < Formula

  def module_path
    prefix / "#{extension}.so"
  end
  
  def config_path
    etc / "php"
  end

  def config_scandir_path
    config_path / "config.d"
  end

  def config_filename
    extension + ".ini"
  end

  def config_filepath
    config_scandir_path / config_filename
  end
  
  def config_file
    begin
      <<-EOS.undent
      [#{extension}]
      #{kind}="#{module_path}"
      EOS
    rescue Exception => e
      nil
    end
  end
  
  def kind
    'extension'
  end
  
  def write_config_file
    if config_filepath.file?
      inreplace config_filepath do |s|
        s.gsub!(/^(zend_)?extension=.$/, "#{kind}=\"#{module_path}\"")
      end
    elsif config_file
      config_scandir_path.mkpath
      config_filepath.write(config_file)
    end
  end
  

  def test
  end

end