# frozen_string_literal: true

require_relative '../lib/utils'

desc "Helps you setup a new Ubuntu machines consistently and swiftly"

long_desc "Contains tools that setup, configure and update Ubuntu. Tested on 20.04."

include :terminal

tool "setup" do
  desc "Sets up Ubuntu to a known state"

  def run

    puts "Writing logs to #{Utils.log_folder}"

    # https://github.com/cli/cli
    Utils.system('sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C99B11DEB97541F0')
    Utils.system('sudo apt-add-repository https://cli.github.com/packages')

    # yarn
    Utils.system('curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -')
    Utils.system('echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list')

    # https://github.com/clvv/fasd
    Utils.system("sudo add-apt-repository -y ppa:aacebedo/fasd") #fasd

    # oh-my-zsh
    Utils.system('sudo apt-get -y --quiet install zsh')
    unless File.exist?("#{Dir.home}/.oh-my-zsh")
      Utils.system('sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"')
    end

    # NodeJS
    Utils.system('curl -sL https://deb.nodesource.com/setup_15.x | sudo -E bash -')
    Utils.system('sudo apt-get install --quiet -y nodejs')

    # yarn
    Utils.system('sudo apt install yarn')

    # C++ tools
    Utils.system('sudo apt-get install --quiet -y gcc g++ make')

    # github cli
    Utils.system('sudo apt install gh')

    Utils.system('sudo apt-get install --quiet -y git')
    Utils.system('git config --global user.email "andrea@dellacorte.me"')
    Utils.system('git config --global user.name "Andrea Della Corte"')
    Utils.system('git config --global github.user andreadellacorte')

    # rbenv
    Utils.system("sudo apt --quiet update")
    Utils.system("sudo apt-get --quiet install rbenv")

    # ruby-build plugin for rbenv
    if File.exist?("#{Utils::rbenv_home}/plugins/ruby-build")
      Utils.system("git -C $(rbenv root)/plugins/ruby-build pull")
    else
      Utils.system("mkdir -p $(rbenv root)/plugins")
      Utils.system("git clone https://github.com/rbenv/ruby-build.git $(rbenv root)/plugins/ruby-build")
    end

    Utils.system("rbenv rehash")

    # ruby
    Utils.system("rbenv install --skip-existing 2.6.6") # compatible with suspenders
    Utils.system("rbenv global 2.6.6")

    # gems
    Utils.system('gem update')
    Utils.system('gem update --system')
    Utils.system('gem install bundler')
    Utils.system('gem install jekyll')

    # rails
    Utils.system('gem install rails')
    Utils.system('sudo apt-get install -y --quiet postgresql postgresql-contrib libpq-dev')
    Utils.system('sudo apt-get install -y --quiet ruby-dev libsqlite3-dev sqlite3')
    Utils.system('sudo gem install sqlite3-ruby')

    # suspenders for rails
    Utils.system('sudo apt-get install -y --quiet libpq-dev')
    Utils.system('gem install suspenders')

    # imagemagick
    Utils.system('sudo apt-get install -y --quiet build-essential')
    Utils.system('sudo apt-get install -y --quiet imagemagick')

    # https://github.com/clvv/fasd
    Utils.system('sudo apt-get install -y --quiet fasd')

    # https://github.com/ytdl-org/youtube-dl
    Utils.system('sudo apt-get install -y --quiet youtube-dl')

    # https://github.com/sindresorhus/fkill-cli
    Utils.system("sudo npm install --global fkill-cli")

    # dotfiles
    Utils.system("mkdir -p ~/.dotfiles_backup_#{$time}")
    Utils.system("mv ~/.zshrc ~/.dotfiles_backup_#{$time}")
    Utils.system('cp -r .dotfiles ~')
    Utils.system('ln -s ~/.dotfiles/.zshrc ~/.zshrc')

    # cleanup
    Utils.system("sudo apt-get autoremove")
    Utils.system("sudo apt-get clean")
  end
end

tool "update" do
  desc "Update the tools installed above"

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