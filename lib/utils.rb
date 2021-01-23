require 'whirly'
require 'paint'
require 'date'

Whirly.configure spinner: 'dots'
Whirly.configure stop: '✅'

module Utils

  $time = DateTime.now
  $pwd = Dir.pwd
  $init = false

  def self.apt_install(packages)
    system("sudo apt-get install -y --quiet " + packages)
  end

  def self.system(command)
    puts "Writing logs to #{Utils.log_file}" unless $init
    $init = true

    puts Kernel.system('mkdir -p logs', exception: true, [:out, :err] => [self.log_file, 'a'])

    begin
      Kernel.system("sudo echo 'acquired sudo' > /dev/null", exception: true)
      Whirly.start do
        Whirly.status = "Running #{command}"
        Kernel.system(command, exception: true, [:out, :err] => [self.log_file, 'a'])
        sleep 0.1
      end
    rescue RuntimeError => exception
      abort("Error running script: #{exception} - see #{self.log_file} for details")
    end
  end

  def self.log_file
    "#{$pwd}/logs/logs_#{$time}.txt"
  end

  def self.rbenv_home
    return '' if `which rbenv`.empty?

    `echo $(rbenv root)`.delete!("\n")
  end
end