class Student::StudentCommitmentAbility < ApplicationRecord
    after_save :progress_calculation
    include ProgressHelper
    def progress_calculation
        student_progress(self)
    end
end
