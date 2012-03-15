require 'fileutils'

class SetupCreator
  attr_accessor :config
  attr_accessor :builder
  attr_accessor :configurator

  def copy_template()
    if(!File.directory?(config['template_path']))
      throw "Setup template doesn't exist"
    end

    if(!File.directory?(config['temp_path']))
      Dir.mkdir(config['temp_path'])
    end

    Dir.foreach(config['template_path']) do |entry|
      if(entry != '.' && entry != '..')
        FileUtils.cp_r("#{config['template_path']}/#{entry}", config['temp_path']) 
      end
    end
  end

  def configure_setup(options)
    configurator.configure(config['temp_path'], options)
  end

  def build_setup
    setup_path = generate_setup_path
    builder.build(config['temp_path'], setup_path);

    setup_path
  end

  private
  # Generates random setup path 
  def generate_setup_path
    random_hash = Digest::SHA1.new.hexdigest(Time.now.to_s)
    filename = "#{config['destination_path']}/setup#{random_hash}.exe"
    if(File.exists?(filename))
      generate_setup_path
    else
      filename
    end
  end 
end
