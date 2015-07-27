require "amethyst"
require "option_parser"
require "slack"

class WorldController < Base::Controller
  actions :hello, :command, :webhook

  view "hello", "#{__DIR__}/views"
  def hello
    @name = "Slack Crystal"
    respond_to do |format|
      format.html { render "hello" }
    end
  end

  view "command", "#{__DIR__}/views"
  def command
    request = HTTP::Request.new "POST", "/", body: "token=..."
    command = Slack::SlashCommand.from_request(request)
    respond_to do |format|
      @command = command.text
      format.html { render "command" }
    end
  end

  view "webhook", "#{__DIR__}/views"
  def webhook
    hook = Slack::IncomingWebHook.new("web hook message from crystal", channel: "#general")
    hook.send_to "https://hooks.slack.com/services/..."
    respond_to do |format|
      @message = "Message Sent!"
      format.html { render "webhook" }
    end
  end

end

class HelloWorldApp < Base::App
  routes.draw do
    get "/hello", "world#hello"
    get "/command", "world#command"
    get "/webhook", "world#webhook"
    all "/",      "world#hello"
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
