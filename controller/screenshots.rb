require 'sinatra/base'

class OnBoard::Controller

  get "/screenshots.html" do
    format(
      :path     => '/screenshots',
      :format   => 'html'
    )
  end

end
