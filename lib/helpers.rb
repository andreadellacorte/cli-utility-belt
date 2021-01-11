module Helpers

  def self.my_runner(command)
    puts "Running #{command}"
    begin
      system(command, exception: true)
    rescue RuntimeError => exception
      abort("Error running script: #{exception}")
    end
  end

  def self.rbenv_home
    `echo $(rbenv root)`.delete!("\n")
  end
end