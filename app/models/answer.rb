class Answer < ApplicationRecord
    self.table_name = "answers"
    include ProgressHelper
    after_save :progress_calculation

    #Progress
    def progress_calculation
        if self.role == "Student"
            student_progress(self)
        else
            company_progress(self)
        end
    end
end