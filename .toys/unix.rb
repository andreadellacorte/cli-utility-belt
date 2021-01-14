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

tool "makelookscanned" do
  desc "Makes a file look scanned"

  required_arg :file

  def run
    foldername = File.dirname file
    filename = File.basename file

    bookmark = Dir.pwd
    Dir.chdir foldername

    Utils.system("convert -density 150 #{filename} -colorspace 'gray' +noise Gaussian -rotate 0.5 -depth 2 scanned_#{filename}")

    Dir.chdir bookmark
  end
end