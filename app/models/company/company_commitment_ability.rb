class Company::CompanyCommitmentAbility < ApplicationRecord
    after_save :progress_calculation
    include ProgressHelper
    def progress_calculation
        company_progress(self)
    end
end
