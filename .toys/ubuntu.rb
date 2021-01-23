# frozen_string_literal: true

require_relative '../lib/utils'

desc "Helps you setup a new Ubuntu machines consistently and swiftly"

long_desc "Contains tools that setup, configure and update Ubuntu. Tested on 20.04."

include :terminal

tool "setup" do
  desc "Sets up Ubuntu to a known state"

  def run
    utils = Utils.new
    # https://github.com/cli/cli
    utils.system('sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C99B11DEB97541F0')
    utils.system('sudo apt-add-repository https://cli.github.com/packages')

    # yarn
    utils.system('curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -')
    utils.system('echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list')

    # https://github.com/clvv/fasd
    utils.system("sudo add-apt-repository -y ppa:aacebedo/fasd") #fasd

    # update repos after adding new ones
    utils.system("sudo apt --quiet update")

    # oh-my-zsh
    utils.apt_install('zsh')

    unless File.exist?("#{Dir.home}/.oh-my-zsh")
      utils.system('sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"')
    end

    # NodeJS
    utils.system('curl -sL https://deb.nodesource.com/setup_15.x | sudo -E bash -')
    utils.apt_install('nodejs')

    # yarn
    utils.apt_install('yarn')

    # C++ tools
    utils.apt_install('gcc g++ make')

    # git + github cli
    utils.apt_install('git')
    utils.apt_install('gh')
    utils.system('git config --global user.email "andrea@dellacorte.me"')
    utils.system('git config --global user.name "Andrea Della Corte"')
    utils.system('git config --global github.user andreadellacorte')

    # rbenv
    utils.apt_install('rbenv')

    # ruby-build plugin for rbenv
    if File.exist?("#{utils::rbenv_home}/plugins/ruby-build")
      utils.system("git -C $(rbenv root)/plugins/ruby-build pull")
    else
      utils.system("mkdir -p $(rbenv root)/plugins")
      utils.system("git clone https://github.com/rbenv/ruby-build.git $(rbenv root)/plugins/ruby-build")
    end

    utils.system("rbenv rehash")

    # ruby
    utils.system("rbenv install --skip-existing 2.6.6") # compatible with suspenders
    utils.system("rbenv global 2.6.6")

    # gems
    utils.system('gem update')
    utils.system('gem update --system')
    utils.system('gem install bundler')
    utils.system('gem install jekyll')

    # rails
    utils.system('gem install rails')
    utils.apt_install('postgresql postgresql-contrib libpq-dev')
    utils.apt_install('ruby-dev libsqlite3-dev sqlite3')
    utils.system('sudo gem install sqlite3-ruby')

    # suspenders for rails
    utils.apt_install('libpq-dev')
    utils.system('gem install suspenders')

    # imagemagick
    utils.apt_install('build-essential')
    utils.apt_install('imagemagick')
    utils.apt_install('ghostscript')

    # https://github.com/clvv/fasd
    utils.apt_install('fasd')

    # https://github.com/ytdl-org/youtube-dl
    utils.apt_install('youtube-dl')

    # https://github.com/sindresorhus/fkill-cli
    utils.system("sudo npm install --global fkill-cli")

    # dotfiles
    utils.system("mkdir -p ~/.dotfiles_backup_#{$time}")
    utils.system("mv ~/.zshrc ~/.dotfiles_backup_#{$time}")
    utils.system('cp -r .dotfiles ~')
    utils.system('ln -s ~/.dotfiles/.zshrc ~/.zshrc')

    # cleanup
    utils.system("sudo apt-get autoremove")
    utils.system("sudo apt-get clean")
  end
end

tool "update" do
  desc "Update the tools installed above"

  def run
    utils = Utils.new
    
    if File.exist?("#{utils::rbenv_home}/plugins/ruby-build")
      utils.system("git -C $(rbenv root)/plugins/ruby-build pull")
    end

    utils.system("sudo apt -y update")
    utils.system("sudo apt -y upgrade")

    utils.system("sudo apt-get autoremove")
    utils.system("sudo apt-get clean")
  end
end