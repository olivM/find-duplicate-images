require 'rubygems'
require 'mongoid'
require 'forkmanager'
require 'anemone'
require 'uri'
require 'cgi'
require 'RMagick'

require './functions.rb'

require './option.rb'

require './project.rb'
require './image.rb'

Mongoid.load!("mongoid.yml", :development)

module Anemone
    class Core
        def kill_threads
            @tentacles.each { |thread|
                Thread.kill(thread)  if thread.alive?
            }
        end
    end
end

