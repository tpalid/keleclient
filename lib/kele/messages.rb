module Messages
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
end