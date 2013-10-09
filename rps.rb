require 'rack/request'
require 'rack/response'
require 'haml'
require 'rack'
require 'thin'

module RockPaperScissors

   class App
               
      def initialize(app = nil) 
         @app = app
         @content_type = :html
         @defeat = {'rock' => 'scissors', 'paper' => 'rock', 'scissors' => 'paper'}
      end
      
      def call(env)
         req = Request.new(env)
         
         req.env.keys.sort.each { |x| puts "{x} => #{req.env[x]}" }
         # ...
         
         engine = Haml::Engine.new File.open("views/index.haml").read
         res = Rack::Response.new
         res.write engine.render({},
            :answer => answer,
            :choose => @choose,
            :throws => @throws)
         res.finish
      end # call
   end # App
end # RockPaperScissors


if $0 == __FILE__
   require 'rack'
   require 'rack/showexceptions'
   Rack::Server.start(
      :app => Rack::ShowExceptions.new(
               Rack::Lint.new(
                  RockPaperScissors::App.new)
               ),
      :Port => 9292,
      :server => 'thin'
   )
end   