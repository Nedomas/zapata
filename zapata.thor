require 'thor'

class Generator < Thor
  desc: "Say Hello"
  method_option :name, :aliases => "-n", :desc => "Specify a name"
  def hello
    puts "Hello #{options[:name]}"
  end
end
