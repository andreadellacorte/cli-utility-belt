# frozen_string_literal: true

require_relative '../lib/helpers'

desc "A set of system commands for Toys"

long_desc "Contains tools that inspect, configure, and update Toys itself."

include :terminal

tool "setup" do
  desc "Print the current Toys version"

  def run
    Helpers.my_runner("echo 'export PATH=\"#{Helpers.rbenv_home}/bin:$PATH\"' >> ~/.bashrc")
    Helpers.my_runner("echo 'eval \"$(rbenv init -)\"' >> ~/.bashrc")
    Helpers.my_runner("echo 'eval \"$(fasd --init auto)\"' >> ~/.bashrc")
  end
end