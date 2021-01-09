tool "greet" do
  desc "My first tool!"
  flag :whom, default: "world"
  def run
    puts "Hello, #{whom}!"
  end
end