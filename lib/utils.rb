module Utils
  def self.system(command)
    puts "Running #{command}"
    begin
      Kernel.system(command, exception: true)
    rescue RuntimeError => exception
      abort("Error running script: #{exception}")
    end
  end

  def self.rbenv_home
    `echo $(rbenv root)`.delete!("\n")
  end
end