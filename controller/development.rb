require 'sinatra/base'

class OnBoard::Controller

  get "/development.html" do
    #format(
    #  :path     => '/development',
    #  :format   => 'html'
    #)
    redirect 'http://github.com/gderosa/onboard'
  end

end
