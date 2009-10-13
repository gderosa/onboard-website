$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'

require 'rubygems'
require 'sinatra/base'
require 'erb'
require 'find'
require 'json'
require 'yaml'
require 'logger'
require 'pp' 

require 'onboard/suburi'
require 'onboard/extensions/object'
require 'onboard/menu/node'

class OnBoard
  LONGNAME = 'Ruby OnBoard'
 
  ROOTDIR = File.dirname File.expand_path(__FILE__)
  CONFDIR = ROOTDIR + '/etc/config'

  LOGGER = Logger.new(ROOTDIR + '/' + 'onboard.log')

  MENU_ROOT = Menu::MenuNode.new('ROOT', {
    :href => '/',
    :name => 'Home',
    :desc => 'Home page',
    :n    => 0
  })

  #LOGGER.datetime_format = "%Y-%m-%d %H:%M:%S"
  LOGGER.formatter = proc { |severity, datetime, progname, msg|
    "#{datetime} #{severity}: #{msg}\n"
  }

  LOGGER.info "Ruby on OnBoard started."

  def self.find_n_load(dir)
    # sort to resamble /etc/rc*.d/* or run-parts behavior
    Find.find(dir).sort.each do |file|
      if file =~ /\.rb$/
        if load file
          puts "loaded: #{file}"
        end
      end
    end
  end

  def self.prepare

    unless ARGV.include? '--restore-only'
      # modular menu
      find_n_load ROOTDIR + '/etc/menu/'
    end

  end

  def self.save!
    LOGGER.info 'Saving configuration...'
    find_n_load ROOTDIR + '/etc/save/'
  end

end

OnBoard.prepare
exit if ARGV.include? '--restore-only'
load OnBoard::ROOTDIR + '/controller.rb'

if $0 == __FILE__
  OnBoard::Controller.run!(:port => 4568)
end


