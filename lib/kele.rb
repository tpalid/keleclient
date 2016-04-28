require 'httparty'
require 'json'
class Kele
    include HTTParty
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
    
    def get_mentor_availability
        @mentor_id = self.get_me["current_enrollment"]["mentor_id"]
        @mentor_availability = JSON.parse((self.class.get("/mentors/#{@mentor_id}/student_availability", headers: {"authorization" => @authtoken})).body)
    end
    
    def get_roadmap
        @roadmap_id = self.get_me["current_enrollment"]["roadmap_id"]
        @roadmap = JSON.parse((self.class.get("/roadmaps/#{@roadmap_id}", headers: {"authorization" => @authtoken})).body)
    end
    
    def get_checkpoint(id)
        @checkpoint = self.class.get("/checkpoints/#{id}", headers: {"authorization" => @authtoken})
    end
    
    def get_messages(first_page=nil,last_page=nil)
        @messages = []
        if last_page
            (first_page..last_page).each do |page|
                messages << JSON.parse(self.class.get("/message_threads", :query => {page: "#{page}"}, headers: {"authorization" => @authtoken}).body)
            end
        elsif first_page
            @messages = JSON.parse(self.class.get("/message_threads", :query => {page: "#{first_page}"}, headers: {"authorization" => @authtoken}).body)
        else
            @count = (JSON.parse(self.class.get("/message_threads", :query => {page: "1"}, headers: {"authorization" => @authtoken}).body)["count"])
            @count%10 == 0 ? @pages = @count/10 : @pages = (@count/10) + 1
             (1..@pages).each do |page|
                @messages << JSON.parse(self.class.get("/message_threads", :query => {page: "#{page}"}, headers: {"authorization" => @authtoken}).body)
            end
        end
        @messages
    end
    
    def create_message(recipient_id, subject, message, token=nil)
        @user_id = self.get_me["id"]
        self.class.post("/messages", :body => {user_id: @user_id, recipient_id: recipient_id, subject: subject, "stripped-text" => message, token: token}, headers: {"authorization" => @authtoken})
    end
    
    def create_submission(assignment_branch, assignment_commit_link, checkpoint_id, comment)
        @enrollment_id = self.get_me["current_enrollment"]["id"]
        self.class.post("/checkpoint_submissions", :query => {assignment_branch: assignment_branch, assignment_commit_link: assignment_commit_link, checkpoint_id: checkpoint_id, comment: comment, enrollment_id: @enrollment_id}, headers: {"authorization" => @authtoken})
    end
end
