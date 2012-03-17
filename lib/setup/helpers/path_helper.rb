class PathHelper
  def self.generate_random_hash
    Digest::SHA1.new.hexdigest(Time.now.to_s)
  end

  # Generates unique random file path under base_path
  def self.get_random_file(base_path)
    random_part = generate_random_hash
    while File.exists?(base_path + random_part)
      random_part = generate_random_hash
    end

    base_path + random_part
  end

  # Generates unique random directory path under base_path
  def self.get_random_dir(base_path)
    self.get_random_file(base_path + "/")
  end

  # Creates random directory under base_path and returns path to this directory
  def self.create_random_dir(base_path)
    path = self.get_random_dir(base_path)
    Dir.mkdir(path)
    path
  end
end
