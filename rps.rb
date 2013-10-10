require 'rack/request'
require 'rack/response'
require 'haml'


module RockPaperScissors

   class App
               
      def initialize(app = nil) 
         @app = app
         @content_type = :html
         @defeat = {'rock' => 'scissors', 'paper' => 'rock', 'scissors' => 'paper'}
         @throws = @defeat.keys
      end
      
      def call(env)
         req = Rack::Request.new(env)
         
         req.env.keys.sort.each { |x| puts "{x} => #{req.env[x]}" }
  
         
         computer_throw = @throws.sample
         player_throw = req.GET["choice"]
         answer = 
            if !@throws.include?(player_throw)
               "Choose one"
            elsif player_throw == computer_throw
               "There is a tie"
            elsif computer_throw == @defeat[player_throw]
               "Well done. You win; #{player_throw} beats #{computer_throw}"               
            else
               "Computer wins; #{computer_throw} defeats #{player_throw}"
            end

         
         engine = Haml::Engine.new File.open("views/index.haml").read
         res = Rack::Response.new
         res.write engine.render({},
            :answer => answer,
            :throws => @throws,
            :computer_throw => computer_throw,
            :player_throw => player_throw)         
         res.finish
         
      end # call
   end # App
end # RockPaperScissors



if $0 == __FILE__
   require 'rack'
   require 'rack/showexceptions'
   Rack::Server.start(
      #:app => RockPaperScissors::App.new,
     :app => Rack::ShowExceptions.new(
               Rack::Lint.new(
                  RockPaperScissors::App.new)
               ),
      :Port => 9292,
      :server => 'thin'
   )
end   