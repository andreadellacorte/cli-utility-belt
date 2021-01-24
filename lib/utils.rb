# frozen_string_literal: true

require 'whirly'
require 'paint'
require 'date'

Whirly.configure spinner: 'dots'
Whirly.configure stop: '✅'

class Utils
  def initialize
    @time = DateTime.now.strftime('%Y-%m-%d_%H-%M-%S')
    @pwd = Dir.pwd
    @init = false
    @log_file = "#{@pwd}/logs/logs_#{@time}.txt"
  end

  def time() @time; end

  def apt_install(packages)
    apt("install #{packages}")
  end

  def apt(command)
    sudo("apt-get --yes --quiet " + command)
  end

  def npm_install(package)
    sudo("npm install --global " + package)
  end

  def sudo(command)
    system("sudo " + command)
  end

  def system(command)
    puts("Writing logs to #{@log_file}") unless @init
    @init = true

    Kernel.system('mkdir -p logs', exception: true, %i[out err] => [@log_file, 'a'])

    begin
      Kernel.system("sudo echo 'acquired sudo' > /dev/null", exception: true, %i[out err] => [@log_file, 'a'])

      Whirly.start do
        Whirly.status = "Running #{command}"
        Kernel.system(command, exception: true, %i[out err] => [@log_file, 'a'])
      end
    rescue RuntimeError => e
      abort("Error running script: #{e} - see #{@log_file} for details")
    end
  end

  def rbenv_home
    return '' if `which rbenv`.empty?

    `echo $(rbenv root)`.delete!("\n")
  end
end
