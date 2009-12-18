require 'sinatra/base'

class OnBoard::Controller

  get "/downloads.html" do
    redirect 'http://github.com/gderosa/onboard/downloads'
  end

end
