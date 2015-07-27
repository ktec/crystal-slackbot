require "amethyst"
require "option_parser"

class WorldController < Base::Controller
  actions :hello

  view "hello", "#{__DIR__}/views"
  def hello
    @name = "Slack Crystal"
    respond_to do |format|
      format.html { render "hello" }
    end
  end
end

class HelloWorldApp < Base::App
  routes.draw do
    all "/",      "world#hello"
    get "/hello", "world#hello"
    register WorldController
  end
end

server_port = 8080
OptionParser.parse! do |opts|
  opts.on("-p PORT", "--port PORT", "define port to run server") do |port|
    server_port = port.to_i
  end
end
app = HelloWorldApp.new
app.serve(server_port)
