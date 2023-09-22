module ProgressHelper
    #*********************************************************************************************
    #                                             Student Progress
    #*********************************************************************************************
    def student_progress(student)     
        total_percent = 0          
        if self.class == Student::Assessment 
            progess_record = Student::Student.find_by(user_id: self.student_id)
        elsif self.class == Student::StudentCommitmentAbility
            user_id = Student::Student.select("user_id").where("id = ?", self.student_id).take.user_id
            progess_record = Student::Student.find_by(user_id: user_id)
        else
            progess_record = Student::Student.find_by(user_id: self.user_id)
        end

        progress_hash = if progess_record.progress_details.nil?
                            KodawariConfig.progress_details.map {
                                |obj| {'id'=> sprintf('%04d',obj['value']),'type'=> obj['name'], 'percent' => 0}
                            }  
                        else
                            progess_record.progress_details
                        end    
        
        if self.class == Student::StudentCommitmentAbility 
            progress_hash[1]['percent'] = student_commitment_ability_progress(student)      
        elsif self.class == Student::Student
            progress_hash[0]['percent'] = student_temporary_registration_progress(student)
            progress_hash[2]['percent'] =  student_main_registration_progress(student)
        elsif self.class == Student::Assessment   
            progress_hash[3]['percent'] = student_assessment1_progress(student)           
            progress_hash[4]['percent'] = student_assessment2_progress(student)            
            progress_hash[5]['percent'] = student_assessment3_progress(student)           
        elsif self.class == Answer
            progress_hash[6]['percent'] = student_questionnaire_answer_progress(student)
        end          
            
        progess_record.update_column(:progress_details, progress_hash)
        unless progress_hash == nil
            total_percent = ( progress_hash[0]['percent']  +  progress_hash[1]['percent']  +  progress_hash[2]['percent'] )
        end        
        
        if progress_hash[0]['percent'] > 0 &&  progress_hash[1]['percent'] > 0 && progress_hash[2]['percent'] > 0 && progress_hash[6]['percent'] > 0
            progess_record.update_column(:progress_complete, true)
        else
            progess_record.update_column(:progress_complete, false)
        end
    end

    #Student Kodawari Profile Progress
    def student_temporary_registration_progress(student)
        not_null_count = 0    
        KodawariConfig.student_kodawari_profile_params.each do |field_name|
            unless student[field_name] == nil || student[field_name] == "" || student[field_name] == [""] 
                if field_name == "preferred_working_area"
                    if student[field_name].length <= 1
                        not_null_count += 0
                    else
                        not_null_count += 1
                    end
                else 
                    not_null_count += 1
                end
            end
        end  
        percent = ((not_null_count.to_f / KodawariConfig.student_kodawari_profile_params.length.to_f) * 100).ceil
    end
    #Student Kodawari assessessment Progress
     def student_commitment_ability_progress(student)
        status_query = Student::StudentCommitmentAbility.where(student_id: student.student_id, status: "active")
        percent = status_query.size > 0 ? 100 : 0
    end
    #Student Basic Information Progress
    def student_main_registration_progress(student)
        not_null_count = 0        
        KodawariConfig.student_profile_params.each do |field_name|
            if field_name == "image"
                if student.image.attached?
                    not_null_count += 1
                end
            end
            if field_name == "email"                
                unless student.email == nil || student.email == "" || student.email == [""] 
                    not_null_count += 1
                end
            end
            unless student[field_name] == nil || student[field_name] == "" || student[field_name] == [""] 
                if field_name == "outside_school_activity" 
                    if student["outside_school_activity"].count { |x| x == 1 } > 0
                        not_null_count += 1
                    else
                        not_null_count += 0
                    end                
                else
                    not_null_count += 1
                end
            end           
        end    
        percent = ((not_null_count.to_f / KodawariConfig.student_profile_params.length.to_f) * 100).ceil
    end

    #Student Assessment Progress
    def student_assessment1_progress(student)        
        not_null_count = 0            
        KodawariConfig.student_assessment1_params.each do |field_name|
            unless student[field_name] == nil || student[field_name] == "" || student[field_name] == [""] 
                not_null_count+=1
            end
        end   
        percent = ((not_null_count.to_f / KodawariConfig.student_assessment1_params.length.to_f) * 100).ceil
    end
    
    def student_assessment2_progress(student)  
        not_null_count = 0
        KodawariConfig.student_assessment2_params.each do |field_name|
            if student[field_name].present?
                if  student[field_name].count { |x| x == 1 } > 0
                    not_null_count += 1
                end
            end
        end 
        percent = ((not_null_count.to_f / KodawariConfig.student_assessment2_params.length.to_f) * 100).ceil
    end
    
    def student_assessment3_progress(student)        
        not_null_count = 0            
        KodawariConfig.student_assessment3_params.each do |field_name|
            unless student[field_name] == nil || student[field_name] == "" || student[field_name] == [""] 
                not_null_count+=1
            end
        end   
        percent = ((not_null_count.to_f / KodawariConfig.student_assessment3_params.length.to_f) * 100).ceil
    end       

    # Student questionnaire answer progress
    def student_questionnaire_answer_progress(student)
        answer_query = Answer.where(user_id: student.user_id, role: "Student")
        percent = answer_query.size > 0 ? 100 : 0
    end

    def student_complete_percentage(data)
        ((data.map{|h| student_complete_form_check(h)? h['percent'].to_i : 0 }.sum).to_f /  (data.length-3).to_f).floor
    end

    def student_complete_form_check(dx)
        dx['id'] === '0001' || dx['id'] === '0002' || dx['id'] === '0003'? true : false
    end
    
    
    #*********************************************************************************************
    #                                             Company Progress
    #*********************************************************************************************
    def company_progress(company)    
        total_percent = 0       
        if self.class == Company::Company
            progess_record = Company::Company.find_by(id: self.id)
        elsif self.class == Answer
            progess_record = Company::Company.find_by(id: self.user_id)
        else
            progess_record = Company::Company.find_by(id: self.company_id)
        end
        progress_hash = if progess_record.progress_details.nil?
                            KodawariConfig.company_progress_details.map {
                                |obj| {'id'=> sprintf('%04d',obj['value']),'type'=> obj['name'], 'percent' => 0}
                            }  
                        else
                            progess_record.progress_details
                        end            
        if self.class == Company::Company  
            progress_hash[0]['percent'] = company_temporary_registration_progress(company)
            progress_hash[2]['percent'] = company_basic_information_progress(company) 
            progress_hash[4]['percent'] = company_home_page_progress(company)
            progress_hash[5]['percent'] = company_about_us_progress(company)
            progress_hash[6]['percent'] = company_member_progress(company)
            progress_hash[7]['percent'] = company_recruitment_progress(company)           
        elsif self.class == Company::CompanyCommitmentAbility                   
            progress_hash[1]['percent'] = company_commitment_ability_progress(company)  
        elsif self.class == Answer
            progress_hash[3]['percent'] = company_questionnaire_answer_progress(company)
        end          
     
        progess_record.update_column(:progress_details, progress_hash)
        unless progress_hash == nil
            total_percent = progress_hash.map{|h| h['percent'].to_i}.sum
        end        
        #if total_percent/(progress_hash.length) == 100
        if progress_hash[0]['percent'] > 0 && progress_hash[1]['percent'] > 0 &&  progress_hash[2]['percent'] > 0 &&  progress_hash[3]['percent'] > 0 && progress_hash[4]['percent'] > 0 && progress_hash[5]['percent'] > 0
            progess_record.update_column(:progress_complete, true)
        else
            progess_record.update_column(:progress_complete, false)
        end
    end

    #Commitment profile progress
    def company_temporary_registration_progress(company)
        kodawari_not_null_count = 0   
        KodawariConfig.company_kodawari_profile_params.each do |field_name|
            unless company[field_name] == nil || company[field_name] == "" || company[field_name] == [""] 
                kodawari_not_null_count += 1
            end
        end  
        percent = ((kodawari_not_null_count / KodawariConfig.company_kodawari_profile_params.length.to_f) * 100).ceil
    end

    #Company Kodawari assessessment Progress
    def company_commitment_ability_progress(company)
        status_query = Company::CompanyCommitmentAbility.where(company_id: company.company_id, status: "active")
        percent = status_query.size > 0 ? 100 : 0
    end

    #Company profile progress
    def company_basic_information_progress(company)
        not_null_count = 0     
        KodawariConfig.company_profile_params.each do |field_name|
            if field_name == "capital_amount_string"
                unless company.capital_amount_string == nil || company.capital_amount_string == "" || company.capital_amount_string == [""] 
                    not_null_count += 1
                end            
            elsif field_name == "sales_amount_string"
                unless company.sales_amount_string == nil || company.sales_amount_string == "" || company.sales_amount_string == [""] 
                    not_null_count += 1
                end 
            else       
                unless company[field_name] == nil || company[field_name] == "" || company[field_name] == [""] 
                    not_null_count += 1
                end
            end
        end       
        percent = ((not_null_count.to_f / KodawariConfig.company_profile_params.length.to_f) * 100).ceil
    end

    # Company commitment profile progress
    def company_home_page_progress(company)
        kodawari_not_null_count = 0   
        percent = 0
        KodawariConfig.company_commitment_profile_params.each do |field_name| 
            if field_name == "image"
                if company.image.attached?
                    kodawari_not_null_count += 1
                end
            end

            if field_name == "cover_photo"
                if company.cover_photo.attached?
                    kodawari_not_null_count += 1
                end
            end

            if field_name == "job_info"
                unless company.job_info.blank?
                    kodawari_not_null_count += 1
                end 
            end

            if field_name == "company_intro"
                unless company.company_intro.blank?
                    kodawari_not_null_count += 1
                end 
            end

            unless company[field_name] == nil || company[field_name] == "" || company[field_name] == [""] 
                kodawari_not_null_count += 1
            end            
        end  
        percent = ((kodawari_not_null_count / KodawariConfig.company_commitment_profile_params.length.to_f) * 100).ceil
    end

    # Company About us progress
    def company_about_us_progress(company)
        percent = 0
        not_null_count = 0
        if company.company_message.present? 
            not_null_count += 1           
        end 
        if company.other_message.present?
            not_null_count += 1
        end
        if company.company_vision_mission.present?
            not_null_count += 1
        end
        if company.what_we_do.present?
            not_null_count += 1
        end
        if company.how_we_do.present?
            not_null_count += 1
        end
        percent = ((not_null_count / KodawariConfig.company_about_us_params.length.to_f) * 100).ceil
    end

    # Company Recruitment progress
    def company_recruitment_progress(company)
        percent = 0
        not_null_count = 0
        if company.experience_requirements.present?
            not_null_count += 1
        end 
        if company.fresher_requirements.present?
            not_null_count += 1
        end 
        if company.fresher_second_requirements.present?
            not_null_count += 1
        end 

        percent = ((not_null_count / KodawariConfig.company_recruitment_params.length.to_f) * 100).ceil
    end

    # Company Recruitment progress
    def company_member_progress(company)
        percent = 0
        not_null_count = 0
        if company.about_our_team.present?
            not_null_count += 1
        end 
        if company.member_message.present?
            not_null_count += 1
        end 
        percent = ((not_null_count / KodawariConfig.company_member_params.length.to_f) * 100).ceil
    end

    # company questionnaire answer progress
    def company_questionnaire_answer_progress(company)
        answer_query = Answer.where(user_id: company.user_id, role: "Company")
        percent = answer_query.size > 0 ? 100 : 0
    end

    def company_complete_percentage(data)
        ((current_company.progress_details.map{|h| h['percent'].to_i}.sum).to_f /  (current_company.progress_details.length).to_f).floor
    end

    def company_profile_percent
        ((current_company.progress_details[4]['percent'] + current_company.progress_details[5]['percent'] + current_company.progress_details[6]['percent'] + current_company.progress_details[7]['percent']) / 4 ).ceil
    end
end