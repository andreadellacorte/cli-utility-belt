require 'whirly'
require 'paint'
require 'date'

Whirly.configure spinner: 'dots'
Whirly.configure stop: '✅'

module Utils

  $time = DateTime.now

  def self.system(command)

    Kernel.system('mkdir -p logs')

    begin
      Kernel.system("sudo echo 'acquired sudo' > /dev/null", exception: true)
      Whirly.start do
        Whirly.status = "Running #{command}"
        Kernel.system(command, exception: true, [:out, :err] => [self.log_folder, 'a'])
        sleep 0.1
      end
      rescue RuntimeError => exception
      abort("Error running script: #{exception} - see #{self.log_folder} for details")
    end
  end

  def self.log_folder
    "logs/logs_#{$time}.txt"
  end

  def self.rbenv_home
    `echo $(rbenv root)`.delete!("\n")
  end
end