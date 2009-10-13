require 'rubygems'
require 'sinatra/base'
require 'erb'
require 'find'
require 'json'
require 'yaml'
require 'logger'

require 'onboard/extensions/object'
require 'onboard/menu/node'

class OnBoard::Controller < Sinatra::Base
  SUBURI = OnBoard::SUBURI
  SUBURIRE = OnBoard::SUBURIRE

  # Several options are not enabled by default if you inherit from 
  # Sinatra::Base .
  enable :methodoverride, :static, :show_exceptions
  set :public, OnBoard::ROOTDIR + '/public'
  set :views, OnBoard::ROOTDIR + '/views'
  # TODO: set :root, OnBoard::ROOTDIR # better ?

  # TODO: do not hardcode, make it themable :-)
  IconDir = '/icons/gnome/gnome-icon-theme-2.18.0'
  IconSize = '16x16'
  
  include ERB::Util

  @@formats = %w{html json yaml} # order matters

  not_found do
    format(:path=>'404', :format=>'html') 
  end

  before do
    request.path_info.sub!(SUBURIRE, '/')
  end

  helpers do

    # This method should be called PROVIDED that the resource exists.
    def format(h)
      case h[:format]
      when 'html', 'xhtml'
        return erb(
          (h[:path] + '.' + h[:format]).to_sym,
          :layout => ("layout." + h[:format]).to_sym,
          :locals => {
            :objects => h[:objects], 
            :icondir => IconDir, 
            :iconsize => IconSize,
            :msg => h[:msg] 
          } 
        )
      when 'json', 'yaml'
        content_type 'application/json' if h[:format] == 'json'
        content_type 'text/x-yaml'      if h[:format] == 'yaml'
        if h[:objects].class == Array and h[:objects][0].respond_to? :data
          # we assume that array is made up of objects of the same class
          return (h[:objects].map {|obj| obj.data}).to_(h[:format]) 
        elsif h[:objects].respond_to? :data
          return h[:objects].data.to_(h[:format])
        else
          return h[:objects].to_(h[:format])
        end
      else
        status(300)
        paths = []
        @@formats.each do |fmt|
          paths << request.path_info.sub(/\.[^\.]*$/, '.' + fmt) 
        end
        @@formats.each do |fmt|
          if request.env["HTTP_ACCEPT"] [fmt] # "contains"
            return format(
              :path => '300',
              :format => fmt,
              :objects => {
                :paths => paths, 
              }
            )
          end
          format(
            :path => '300',
            :format => 'html',
            :objects => {
                :paths => paths, 
            }          
          )
        end
      end  
    end

  end

  # just to have "CSS variables"
  get '/css/:stylesheet' do
    content_type 'text/css'
    erb ('css/' + params[:stylesheet]).to_sym
  end

  put '*' do 
    not_found 
  end

  post '*' do 
    not_found 
  end

  delete '*' do 
    not_found 
  end

  # modular controller
  OnBoard.find_n_load OnBoard::ROOTDIR + '/controller/'

end


