# frozen_string_literal: true

require 'whirly'
require 'paint'
require 'date'

Whirly.configure spinner: 'dots'
Whirly.configure stop: '✅'

class Utils
  def initialize
    @@time = DateTime.now
    @@pwd = Dir.pwd
    @@init = false
    @@log_file = "#{@@pwd}/logs/logs_#{@@time}.txt"
  end

  def apt_install(packages)
    system("sudo apt-get install -y --quiet #{packages}")
  end

  def system(command)
    puts ("Writing logs to #{@@log_file}") and @@init = true unless @@init

    Kernel.system('mkdir -p logs', exception: true, %i[out err] => [@@log_file, 'a'])

    begin
      Kernel.system("sudo echo 'acquired sudo' > /dev/null", exception: true, %i[out err] => [@@log_file, 'a'])
      Whirly.start do
        Whirly.status = "Running #{command}"
        Kernel.system(command, exception: true, %i[out err] => [@@log_file, 'a'])
      end
    rescue RuntimeError => e
      abort("Error running script: #{e} - see #{@@log_file} for details")
    end
  end

  def rbenv_home
    return '' if `which rbenv`.empty?

    `echo $(rbenv root)`.delete!("\n")
  end
end
