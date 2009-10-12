require 'sinatra/base'

class OnBoard::Controller

  get "/contact.html" do
    format(
      :path     => '/contact',
      :format   => 'html'
    )
  end

end
