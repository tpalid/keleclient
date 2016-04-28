require 'httparty'
require 'json'
require_relative 'kele/roadmap.rb'
require_relative 'kele/messages.rb'
require_relative 'kele/mentor.rb'
require_relative 'kele/submission.rb'

class Kele
    include Roadmap
    include Messages
    include Mentor
    include HTTParty
    include Submission
    base_uri "https://www.bloc.io/api/v1"
    include JSON
    #debug_output
    
    attr_accessor :url, :authtoken

    def initialize(email, password)
        @url = 'https://www.bloc.io/api/v1'
        @authtoken = self.sign_in(email, password)
    end
    
    def sign_in(email, password)
        @authtoken = self.class.post('/sessions', :query => {email: email, password: password})["auth_token"]
        raise NotAuthedError if @authtoken.nil?
        @authtoken
    end
    
    def get_me!
        self.class.get('/users/me', headers: {"authorization" => @authtoken})
    end
    
    def get_me
        @user_data ||= get_me!
    end
    
end
