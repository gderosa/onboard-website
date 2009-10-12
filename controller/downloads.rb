require 'sinatra/base'

class OnBoard::Controller

  get "/downloads.html" do
    format(
      :path     => '/downloads',
      :format   => 'html'
    )
  end

end
