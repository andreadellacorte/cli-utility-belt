# frozen_string_literal: true

require_relative '../lib/utils'
require 'date'

desc "Helps you setup a new Ubuntu machines consistently and swiftly"

long_desc "Contains tools that setup, configure and update Ubuntu. Tested on 20.04."

include :terminal

tool "setup" do
  desc "Print the current Toys version"

  def run
    Utils.system("sudo add-apt-repository -y ppa:aacebedo/fasd")

    Utils.system("sudo apt --quiet update")
    Utils.system("sudo apt-get --quiet install rbenv")

    if File.exist?("#{Utils::rbenv_home}/plugins/ruby-build")
      Utils.system("git -C $(rbenv root)/plugins/ruby-build pull")
    else
      Utils.system("mkdir -p $(rbenv root)/plugins")
      Utils.system("git clone https://github.com/rbenv/ruby-build.git $(rbenv root)/plugins/ruby-build")
    end

    Utils.system('sudo apt-get -y --quiet install zsh')
    unless File.exist?("#{Dir.home}/.oh-my-zsh")
      Utils.system('sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"')
    end

    Utils.system('curl -sL https://deb.nodesource.com/setup_15.x | sudo -E bash -')
    Utils.system('sudo apt-get install --quiet -y nodejs')

    Utils.system('sudo apt-get install --quiet -y gcc g++ make')

    Utils.system('sudo apt-get install --quiet -y git')
    Utils.system('git config --global user.email "andrea@dellacorte.me"')
    Utils.system('git config --global user.name "Andrea Della Corte"')
    Utils.system('git config --global github.user andreadellacorte')

    unless File.exist?("#{Dir.home}/.ssh/id_rsa")
      Utils.system('ssh-keygen -t rsa -b 4096 -C "andrea@dellacorte.me"')
    end
    Utils.system("eval \$(ssh-agent)")
    Utils.system('ssh-add ~/.ssh/id_rsa')

    Utils.system("rbenv rehash")

    Utils.system("rbenv install --skip-existing 3.0.0")
    Utils.system("rbenv global 3.0.0")

    Utils.system('gem update')
    Utils.system('gem update --system')
    Utils.system('gem install bundler')
    Utils.system('gem install jekyll')
    Utils.system('gem install rails')
    Utils.system('sudo apt-get install -y ruby-dev libsqlite3-dev sqlite3')
    Utils.system('sudo gem install sqlite3-ruby')
    Utils.system('sudo apt-get install build-essential')
    Utils.system('sudo apt-get install imagemagick')

    Utils.system("sudo apt-get install -y fasd")

    Utils.system("sudo apt-get autoremove")
    Utils.system("sudo apt-get clean")

    Utils.system("mkdir -p ~/.dotfiles_backup_#{DateTime.now}")
    Utils.system("mv ~/.zshrc ~/.dotfiles_backup_#{DateTime.now}")

    Utils.system('cp -r .dotfiles ~')
    Utils.system('ln -s ~/.dotfiles/.zshrc ~/.zshrc')
  end
end

tool "update" do
  desc "Update tools"

  def run
    if File.exist?("#{Utils::rbenv_home}/plugins/ruby-build")
      Utils.system("git -C $(rbenv root)/plugins/ruby-build pull")
    end

    Utils.system("sudo apt -y update")
    Utils.system("sudo apt -y upgrade")

    Utils.system("sudo apt-get autoremove")
    Utils.system("sudo apt-get clean")
  end
end