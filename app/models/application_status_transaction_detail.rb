class ApplicationStatusTransactionDetail < ApplicationRecord
    enum type_id: { apply: 1, scouted: 2 }
    enum status: { 
                    waiting_for_connection: 1, 
                    waiting_for_interview_arrangement: 2, 
                    interview_scheduled: 3,
                    waiting_for_interview_result: 4,
                    recruited: 5,
                    rejected: 6 
                }
    enum updated_user_role: { student: 1, company: 2, partner: 3, admin: 4 }
end
