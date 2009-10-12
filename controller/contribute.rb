require 'sinatra/base'

class OnBoard::Controller

  get "/contribute.html" do
    format(
      :path     => '/contribute',
      :format   => 'html'
    )
  end

end
