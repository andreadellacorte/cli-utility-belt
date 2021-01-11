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

    Helpers.my_runner('sudo apt-get -y install zsh')
    Helpers.my_runner('sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"')

    Helpers.my_runner("rbenv rehash")

    Helpers.my_runner("sudo apt-get install -y fasd")

    Helpers.my_runner("sudo apt-get autoremove")
    Helpers.my_runner("sudo apt-get clean")

    Helpers.my_runner('mkdir -p ~/.dotfiles_backup')
    Helpers.my_runner('mv ~/.zshrc ~/.dotfiles_backup')

    Helpers.my_runner('cp -r .dotfiles ~')
    Helpers.my_runner('ln -s ~/.dotfiles/.zshrc ~/.zshrc')
  end
end

tool "update" do
  desc "Update tools"

  def run
    if File.exist?("#{Helpers::rbenv_home}/plugins/ruby-build")
      Helpers.my_runner("git -C $(rbenv root)/plugins/ruby-build pull")
    end

    Helpers.my_runner("sudo apt -y update")
    Helpers.my_runner("sudo apt -y upgrade")

    Helpers.my_runner("sudo apt-get autoremove")
    Helpers.my_runner("sudo apt-get clean")
  end
end