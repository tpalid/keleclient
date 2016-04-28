module Submission   
    def create_submission(assignment_branch, assignment_commit_link, checkpoint_id, comment)
        @enrollment_id = self.get_me["current_enrollment"]["id"]
        self.class.post("/checkpoint_submissions", :query => {assignment_branch: assignment_branch, assignment_commit_link: assignment_commit_link, checkpoint_id: checkpoint_id, comment: comment, enrollment_id: @enrollment_id}, headers: {"authorization" => @authtoken})
    end
end