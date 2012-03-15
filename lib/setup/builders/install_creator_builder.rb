class InstallCreatorBuilder < AbstractBuilder
  def build(setup_path, exec_path)
    ic_cmd = options['install_creator_exec']
    project_file = options['project_file']
    root_drive = options['root_drive']
    display = options['display']
    system("#{ic_cmd} /b #{root_drive}/#{setup_path}/#{project_file} /o #{root_drive}/#{exec_path}")
  end
end
