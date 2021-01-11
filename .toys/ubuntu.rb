# frozen_string_literal: true

require_relative '../lib/helpers'

desc "A set of system commands for Toys"

long_desc "Contains tools that inspect, configure, and update Toys itself."

include :terminal

tool "setup" do
  desc "Print the current Toys version"

  def run
    Helpers.my_runner("sudo add-apt-repository -y ppa:aacebedo/fasd")

    Helpers.my_runner("sudo apt --quiet update")
    Helpers.my_runner("sudo apt --quiet install rbenv")

    if File.exist?("#{Helpers::rbenv_home}/plugins/ruby-build")
      Helpers.my_runner("git -C $(rbenv root)/plugins/ruby-build pull")
    else
      Helpers.my_runner("mkdir -p $(rbenv root)/plugins")
      Helpers.my_runner("git clone https://github.com/rbenv/ruby-build.git $(rbenv root)/plugins/ruby-build")
    end

    Helpers.my_runner("rbenv rehash")

    Helpers.my_runner("sudo apt-get install -y fasd")

    Helpers.my_runner("sudo apt-get autoremove")
    Helpers.my_runner("sudo apt-get clean")
  end
end

tool "update" do
  desc "Update tools"

  def run
    if File.exist?("#{Helpers::rbenv_home}/plugins/ruby-build")
      Helpers.my_runner("git -C $(rbenv root)/plugins/ruby-build pull")
    end
  end
end