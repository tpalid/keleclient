module Roadmap
    def get_roadmap
        @roadmap_id = self.get_me["current_enrollment"]["roadmap_id"]
        @roadmap = JSON.parse((self.class.get("/roadmaps/#{@roadmap_id}", headers: {"authorization" => @authtoken})).body)
    end
    
    def get_checkpoint(id)
        @checkpoint = self.class.get("/checkpoints/#{id}", headers: {"authorization" => @authtoken})
    end
end