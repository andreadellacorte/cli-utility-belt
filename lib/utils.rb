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
    Kernel.system("sudo echo 'acquired sudo' > /dev/null 2>&1", exception: true, %i[out err] => [@log_file, 'a'])

    system("sudo " + command)
  end

  def system(command)
    puts("Writing logs to #{@log_file}") unless @init
    @init = true

    Kernel.system('mkdir -p logs', exception: true, %i[out err] => [@log_file, 'a'])

    begin
      Whirly.start do
        Whirly.status = "Running #{command}"
        Kernel.system(command, exception: true, %i[out err] => [@log_file, 'a'])
      end
    rescue RuntimeError => e
      abort("Error running script: #{e} - see #{@log_file} for details")
    end
  end

  def rbenv_installed?
    `which rbenv`
  end

  def rbenv_home
    raise RuntimeError.new "rbenv is not installed" unless rbenv_installed?
    `echo $(rbenv root)`.delete!("\n")
  end
end
