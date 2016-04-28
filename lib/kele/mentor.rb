module Mentor
    def get_mentor_availability
        @mentor_id = self.get_me["current_enrollment"]["mentor_id"]
        @mentor_availability = JSON.parse((self.class.get("/mentors/#{@mentor_id}/student_availability", headers: {"authorization" => @authtoken})).body)
    end
end