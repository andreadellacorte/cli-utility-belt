# frozen_string_literal: true

require_relative '../lib/utils'

desc "Contains tools that help run commands on Unix"

long_desc "Contains tools that help run commands on Unix"

include :terminal

tool "dirdos2unix" do
  desc "Convert a folder to unix; usage dirdox2unix <folder>"

  required_arg :folder

  def run
    bookmark = Dir.pwd
    Dir.chdir folder
    Utils.system('find . -type f -print0 | xargs -0 dos2unix')
    Dir.chdir bookmark
  end
end

tool "pdf_scanned" do
  desc "Makes a file look scanned"

  required_arg :file

  def run
    filename = File.basename file
    utils = Utils.new

    utils.system("convert -density 150 #{file} -colorspace 'gray' +noise Gaussian -rotate 0.5 -depth 2 scanned_#{filename}")
end
end

tool "clean_whiteboard" do
  desc "Cleans up a whiteboard photo"

  required_arg :file

  def run
    filename = File.basename file
    utils = Utils.new

    utils.system("convert #{file} -morphology Convolve DoG:15,100,0 -negate -normalize -blur 0x1 -channel RBG -level 60%,91%,0.1 cleaned_#{filename}")
  end
end