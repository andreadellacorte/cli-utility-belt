# frozen_string_literal: true

require_relative '../lib/utils'

desc "Helps you setup a new Ubuntu machines consistently and swiftly"

long_desc "Contains tools that setup, configure and update Ubuntu. Tested on 20.04."

include :terminal

tool "setup" do
  desc "Sets up Ubuntu to a known state"

  def run 
    utils = Utils.new
    
    # dotfiles
    dotfiles = ['.zshrc', '.aliases.zsh']

    utils.system("mkdir -p ~/.dotfiles_backup_#{utils.time}")
    dotfiles.each do |dotfile|
      utils.system("rm ~/#{dotfile}") if File.symlink?("#{Dir.home}/#{dotfile}")
      utils.system("mv ~/#{dotfile} ~/.dotfiles_backup_#{utils.time}") if File.exist?("#{Dir.home}/#{dotfile}")
    end

    utils.system("mkdir -p ~/.dotfiles")
    utils.system('cp -r .dotfiles/ ~')
    dotfiles.each do |dotfile|
      utils.system("ln -s ~/.dotfiles/#{dotfile} ~/#{dotfile}")
    end

    # https://github.com/cli/cli
    utils.sudo('apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C99B11DEB97541F0')
    utils.sudo('apt-add-repository https://cli.github.com/packages')

    # https://github.com/clvv/fasd
    utils.sudo("add-apt-repository -y ppa:aacebedo/fasd")

    # yarn
    utils.system('curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -')
    utils.system('echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list')

    # update repos after adding new ones
    utils.apt("update")

    # curl libraries
    utils.sudo("update-ca-certificates")
    utils.apt_install("libcurl4-openssl-dev")

    # oh-my-zsh
    utils.apt_install('zsh')

    unless File.exist?("#{Dir.home}/.oh-my-zsh")
      utils.system('sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) -yes"')
    end
    
    utils.sudo("chsh $USER -s /usr/bin/zsh")

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
    
    utils.system('eval "$(rbenv init -)')

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
    utils.sudo('gem install sqlite3-ruby')

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
    utils.apt('remove youtube-dl')
    utils.apt_install('python3-pip')
    utils.system('python3 -m pip install youtube-dl')

    # python2 also needed
    utils.apt_install('python2')

    # https://github.com/sindresorhus/fkill-cli
    utils.npm_install('fkill-cli')

    # https://github.com/sindresorhus/emoj
    utils.npm_install('emoj')

    # https://github.com/stedolan/jq
    utils.apt_install('jq')

    # asciinema.org
    utils.apt_install("asciinema")

    # cleanup
    utils.apt("autoremove")
    utils.apt("clean")
    utils.system('gem cleanup')
  end
end

tool "update" do
  desc "Update the tools installed above"

  def run
    utils = Utils.new

    if utils.rbenv_installed && File.exist?("#{utils.rbenv_home}/plugins/ruby-build")
      utils.system("git -C $(rbenv root)/plugins/ruby-build pull")
    end

    utils.npm_install("npm@latest")
    utils.system('gem update --system')

    utils.apt("update")
    utils.apt("upgrade")

    utils.apt("full-upgrade --fix-missing")
  end
end
