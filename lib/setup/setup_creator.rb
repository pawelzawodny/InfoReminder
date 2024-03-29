require 'fileutils'

class SetupCreator
  attr_accessor :config
  attr_accessor :builder
  attr_accessor :configurator
  attr_accessor :temp_path

  # Creates individual temporary path for this particular setup
  def create_temp_path
   if(!File.directory?(config['temp_path']))
      Dir.mkdir(config['temp_path'])
    end

    @temp_path = PathHelper.create_random_dir(config['temp_path'])
  end 
  
  def copy_template()
    if(!File.directory?(config['template_path']))
      throw "Setup template doesn't exist"
    end
 
    create_temp_path

    Dir.foreach(config['template_path']) do |entry|
      if(entry != '.' && entry != '..')
        FileUtils.cp_r("#{config['template_path']}/#{entry}", @temp_path) 
      end
    end
  end

  def configure_setup(options)
    configurator.configure(@temp_path, options)
  end

  def build_setup
    setup_path = generate_setup_path
    builder.build(@temp_path, setup_path);

    if File::exists?(setup_path)
      setup_path
    else
      nil
    end
  end

  # Removes temporary directory
  def clean
    FileUtils.remove_entry_secure(@temp_path)
  end

  private
  # Generates random setup path 
  def generate_setup_path
    PathHelper.get_random_file "#{config['destination_path']}/setup"
  end 
end
