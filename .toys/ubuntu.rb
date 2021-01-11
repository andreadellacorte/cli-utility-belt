# frozen_string_literal: true

require_relative '../lib/helpers'
require 'date'

desc "Helps you setup a new Ubuntu machines consistently and swiftly"

long_desc "Contains tools that setup, configure and update Ubuntu. Tested on 20.04."

include :terminal

tool "setup" do
  desc "Print the current Toys version"

  def run
    Helpers.my_runner("sudo add-apt-repository -y ppa:aacebedo/fasd")

    Helpers.my_runner("sudo apt --quiet update")
    Helpers.my_runner("sudo apt-get --quiet install rbenv")

    if File.exist?("#{Helpers::rbenv_home}/plugins/ruby-build")
      Helpers.my_runner("git -C $(rbenv root)/plugins/ruby-build pull")
    else
      Helpers.my_runner("mkdir -p $(rbenv root)/plugins")
      Helpers.my_runner("git clone https://github.com/rbenv/ruby-build.git $(rbenv root)/plugins/ruby-build")
    end

    Helpers.my_runner('sudo apt-get -y install zsh')
    unless File.exist?("#{Dir.home}/.oh-my-zsh")
      Helpers.my_runner('sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"')
    end

    Helpers.my_runner('curl -sL https://deb.nodesource.com/setup_15.x | sudo -E bash -')
    Helpers.my_runner('sudo apt-get install -y nodejs')

    Helpers.my_runner('sudo apt-get install -y gcc g++ make')

    Helpers.my_runner('sudo apt-get install -y git')
    Helpers.my_runner('git config --global user.email "andrea@dellacorte.me"')
    Helpers.my_runner('git config --global user.name "Andrea Della Corte"')

    unless File.exist?("#{Dir.home}/.ssh/id_rsa")
      Helpers.my_runner('ssh-keygen -t rsa -b 4096 -C "andrea@dellacorte.me"')
    end
    Helpers.my_runner("eval \$(ssh-agent)")
    Helpers.my_runner('ssh-add ~/.ssh/id_rsa')

    Helpers.my_runner("rbenv rehash")

    Helpers.my_runner("rbenv install --skip-existing 3.0.0")
    Helpers.my_runner("rbenv global 3.0.0")

    Helpers.my_runner("sudo apt-get install -y fasd")

    Helpers.my_runner("sudo apt-get autoremove")
    Helpers.my_runner("sudo apt-get clean")

    Helpers.my_runner("mkdir -p ~/.dotfiles_backup_#{DateTime.now}")
    Helpers.my_runner("mv ~/.zshrc ~/.dotfiles_backup_#{DateTime.now}")

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