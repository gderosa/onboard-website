require 'sinatra/base'

class OnBoard::Controller

  get "/about.html" do
    format(
      :path     => 'about',
      :format   => 'html'
    )
  end

end
