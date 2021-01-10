# frozen_string_literal: true

desc "A set of system commands for Toys"

long_desc "Contains tools that inspect, configure, and update Toys itself."

tool "setup" do
  desc "Print the current Toys version"

  def my_runner(command)
    puts "Running #{command}"
    system(command, exception: true)
  end

  def run
    my_runner("sudo add-apt-repository -y ppa:aacebedo/fasd")
    my_runner("sudo apt-get update")
    my_runner("sudo apt-get install -y fasd")
    my_runner("echo 'eval \"$(fasd --init auto)\"' >> ~/.bashrc")
  end
end