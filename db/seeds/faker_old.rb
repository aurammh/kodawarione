20.times do |index|
    admin_event = Admin::Event.new
    admin_event.event_code = "22-#{sprintf('%05d',Admin::Event.count+1)}" 
    admin_event.created_by_id = 1
    admin_event.event_name = Faker::Restaurant.name
    admin_event.event_content = Faker::Lorem.sentence
    admin_event.venue = Faker::Address.full_address 
    admin_event.category = "{NULL,1,2,3}"
    admin_event.event_show_option = rand(1..3)
    admin_event.apply_event_limit = rand(10..200) 
    admin_event.created_user_id = 1 
    admin_event.event_type = 3
    admin_event.event_start_date = Faker::Date.backward(days: rand(5..30))
    admin_event.event_end_date = Faker::Date.forward(days: rand(5..30)) 
    admin_event.post_start_date = Faker::Date.backward(days: rand(5..30)) 
    admin_event.post_end_date = Faker::Date.forward(days: rand(5..30)) 
    admin_event.application_start_date = admin_event.post_start_date
    admin_event.application_deadline = admin_event.post_end_date
    admin_event.save(validate: false)
end
p "Created #{Admin::Event.where(event_type: 3).count} admin events."

30.times do  |index|
    s_user = User.new
    s_user.partner_id = 1
    s_user.email = "user#{index+1}@gmail.com"
    s_user.password = "123456"    
    s_user.sign_in_count = 0
    s_user.confirmed_at = Faker::Time.backward(days: 1)
    s_user.save 

    s = Student::Student.new
    s.user_id = s_user.id
    s.nick_name = Faker::Name.name
    s.last_name = Faker::Name.last_name
    s.first_name = Faker::Name.first_name
    s.last_name_kana = Faker::Name.male_first_name
    s.first_name_kana = Faker::Name.female_first_name
    s.gender = 0
    s.birthday = Faker::Date.birthday(min_age: 18 , max_age: 65)
    s.email_two = Faker::Internet.free_email 
    s.postal_code = 1600002
    s.postal_region_id = 15 
    s.postalcode_city = "新宿区"
    s.address = Faker::Address.street_address
    s.display_address = s.postal_code + s.postalcode_city + s.address
    s.phone_no = Faker::PhoneNumber.cell_phone
    s.school_type = 2
    s.school_name = Faker::University.name
    s.department_name = Faker::Commerce.department
    s.subject_system = 1
    s.graduation_date = Faker::Date.in_date_period(year: 2019 , month: 2) 
    s.desire_industry_type_id = "{NULL,1,3}"
    s.desire_job_type_id =  "{NULL,3}"
    s.m_region_id = "3"
    s.m_prefecture_id = "{NULL,7}"
    s.transfer = "エリア内のみ"
    s.qualification_category_id =  "{NULL,3}"
    s.qualification_type_id =  "{NULL,4}"
    s.club_name = Faker::Team.name 
    s.club_position = Faker::Job.position 
    s.club_detail_activity = Faker::Lorem.sentences 
    s.club_guide = Faker::Team.sport 
    s.sns_blog_for_pr = "mailto:user01@123.com"
    s.job_info = Faker::Food.description 
    student_image = URI.parse(Faker::Avatar.image(slug: [Faker::Creature::Cat.name,Faker::Creature::Bird.adjective].sample, size: "120x120", format: "jpg", set: ["set1","set2","set3","set4"].sample, bgset: ["bg1","bg2"].sample).to_s)
    s.image.attach(io: student_image.open, filename: "#{s.nick_name}-avatar.jpg")
    s.save 

    s_c = Student::StudentCommitment.new
    s_c.user_id = s_user.id
    s_c.full_name = Faker::Name.name
    s_c.address = "3"
    s_c.desired_location = "{NULL,3}"
    s_c.commitment = Faker::Lorem.characters 
    s_c.cover_color = "#000000"
    s_c.save 
end
p "Created #{User.count} users."
p "Created #{Student::Student.count} students."
p "Created #{Student::StudentCommitment.count} student commitments."

5.times do |index|
    c = Company::Company.new
    c.partner_id = rand(1..20)
    c.contact_email = "company#{index+1}@gmail.com"
    c.company_name = Faker::Company.name
    c.company_name_kana = Faker::Company.name
    c.postal_code = "1600002"
    c.m_region_id = 4
    c.m_prefecture_id = 15
    c.postalcode_city = "新宿区"
    c.address = Faker::Address.street_address
    c.display_address = "〒" + c.postal_code + c.postalcode_city + c.address
    c.phone_no = Faker::PhoneNumber.cell_phone
    c.company_info = Faker::Lorem.paragraph
    c.website_url = "www.kodawarione.com"
    c.m_industry_id = rand(1..57)
    c.job_info = Faker::Food.description
    c.company_established = Faker::Date.in_date_period(year: 2012)
    c.capital_amount = 3.times.map{rand(1..9)}.join + "0000"
    c.employee_count = rand(10..2000)
    c.sales_amount = 3.times.map{rand(1..9)}.join + "0000"
    c.related_company = Faker::Company.name
    c.main_bank = Faker::Bank.name
    c.representative = Faker::Name.name
    c.contact = Faker::PhoneNumber.cell_phone
    c.history = Faker::Quote.famous_last_words
    c.transportation_facilities = Faker::Vehicle.make
    c.avg_service_year = rand(1..20)
    c.avg_overtime_per_month = rand(1..20)
    c.avg_paid_leaves = rand(1..20)
    c.number_eligible_childcare_leaves_female = rand(1..20)
    c.taken_childcare_leaves_female = rand(1..20)
    c.taken_childcare_leaves_male = rand(1..20) 
    c.childcare_leave_acquisition_rate_male = rand(10..100)
    c.rate_taken_childcare_leaves_female = rand(10..100)
    c.basic_idea = Faker::IndustrySegments.sector
    c.percentage_female_ration = rand(10..100)
    c.percentage_training = rand(10..100)
    c.mentor_system = Faker::Company.buzzword
    c.career_consulting_system = Faker::Company.type
    c.in_house_certification_system = Faker::Lorem.sentence
    c.contact_person_first_name = Faker::Name.first_name
    c.contact_person_last_name = Faker::Name.last_name
    company_image = URI.parse(Faker::Company.logo.to_s)
    c.image.attach(io: company_image.open, filename: "#{c.company_name}-logo.jpg")
    c.save(validate: false)

    c_user = CompanyUser.new
    c_user.email = c.contact_email
    c_user.password = "123456"
    c_user.first_name = c.contact_person_first_name
    c_user.last_name = c.contact_person_last_name
    c_user.confirmed_at = Faker::Time.backward(days: 1)
    c_user.save

    c_member = Company::CompanyMember.new
    c_member.user_id = c_user.id
    c_member.user_email = c.contact_email
    c_member.company_id = c.id
    c_member.company_roles_id = 1
    c_member.join_flag = true
    c_member.save(validate: false)

    c_commitment = Company::CompanyCommitment.new
    c_commitment.company_id = c.id
    c_commitment.company_intro = Faker::Lorem.paragraph(sentence_count: 8)
    c_commitment.applicant = rand(1..4)
    c_commitment.save
end
p "Created #{Company::Company.count} companies."
p "Created #{CompanyUser.count} company users."
p "Created #{Company::CompanyMember.count} company members."
p "Created #{Company::CompanyCommitment.count} company commitments."

20.times do |index|
    vacancy = Company::Vacancy.new
    vacancy.company_id = rand(1..5)
    vacancy.vacancy_title = Faker::Job.title
    vacancy.vacancy_description = Faker::Lorem.paragraph(sentence_count: 8)
    vacancy.postal_code = "1600002"
    vacancy.m_region_id = 4
    vacancy.m_prefecture_id = 15
    vacancy.postalcode_city = "新宿区"
    vacancy.address = Faker::Address.street_address
    vacancy.display_address = "〒" + vacancy.postal_code + vacancy.postalcode_city + vacancy.address
    vacancy.recruit_industry_type = rand(1..57)
    vacancy.recruit_job_type = rand(1..65)
    vacancy.required_applicants = rand(1..100)
    vacancy.basic_salary = 2.times.map{rand(1..9)}.join + "0000"
    vacancy.model_salary = 2.times.map{rand(1..9)}.join + "0000"
    vacancy.allowance = 2.times.map{rand(1..9)}.join + "0000"
    vacancy.bonus = 2.times.map{rand(1..9)}.join + "0000"
    vacancy.promotion = Faker::Boolean.boolean(true_ratio: 0.8)
    vacancy.probation = Faker::Boolean.boolean(true_ratio: 0.8)
    vacancy.transportation_allowance = Faker::Boolean.boolean(true_ratio: 0.5)
    vacancy.dormitory = Faker::Boolean.boolean(true_ratio: 0.5)
    vacancy.insurance = Faker::Boolean.boolean(true_ratio: 0.8)
    vacancy.severance_pay = Faker::Boolean.boolean(true_ratio: 0.8)
    vacancy.working_hours = "08:00～17:00"
    vacancy.break_time = "12:00～13:00"
    vacancy.over_time = Faker::Boolean.boolean(true_ratio: 0.7)
    vacancy.other = Faker::Company.type
    vacancy.hiring_flow_data = "{#{Faker::Job.employment_type}}"
    vacancy.holiday = "週末と祝日"
    vacancy.welfare_list_data = "{#{61.times.map{rand(0..1)}}}"
    vacancy.company_enhancement = "{#{5.times.map{rand(0..1)}}}"
    vacancy.display_from = Faker::Date.backward(days: rand(5..30))
    vacancy.display_to = Faker::Date.forward(days: rand(5..30))
    vacancy.other_skill = Faker::Job.key_skill
    vacancy.published_flg = true
    vacancy.created_user_id = rand(1..5)
    vacancy.save(validate: false)

    c_event = Company::Event.new
    c_event.event_code = "22-#{sprintf('%05d',Admin::Event.count+1)}" 
    c_event.created_by_id = rand(1..5)
    c_event.event_name = Faker::Restaurant.name
    c_event.event_content = Faker::Lorem.sentence
    c_event.venue = Faker::Address.full_address 
    c_event.category = "{NULL,1,2,3}"
    c_event.event_show_option = rand(1..3)
    c_event.apply_event_limit = rand(10..200) 
    c_event.created_user_id = rand(1..5) 
    c_event.event_type = 1
    c_event.event_start_date = Faker::Date.backward(days: rand(5..30))
    c_event.event_end_date = Faker::Date.forward(days: rand(5..30)) 
    c_event.post_start_date = Faker::Date.backward(days: rand(5..30)) 
    c_event.post_end_date = Faker::Date.forward(days: rand(5..30)) 
    c_event.application_start_date = c_event.post_start_date
    c_event.application_deadline = c_event.post_end_date
    c_event.save(validate: false)  
end
p "Created #{Company::Vacancy.count} company vacancies."
p "Created #{Admin::Event.where(event_type: 1).count} company events."

20.times do |index|
    partner = Partner::Partner.new
    partner.name= Faker::Name.name
    partner.partner_code= Faker::Number.leading_zero_number(digits: 4)
    partner.postal_code= "1600002"
    partner.address= Faker::Address.street_address 
    partner.display_address= "〒160-0002 東京都 新宿区 room-007"
    partner.phone_no= Faker::PhoneNumber.cell_phone
    partner.website_url= "www.kodawarione.com"
    partner.postalcode_city= "新宿区"
    partner.m_region_id= Faker::Number.number(digits: 1)
    partner.m_prefecture_id= Faker::Number.number(digits: 1)
    partner.save

    partner_user = PartnerUser.new
    partner_user.partner_id = partner.id
    partner_user.email = "partner#{index+1}@gmail.com"
    partner_user.password = "123456"
    partner_user.first_name = Faker::Name.first_name
    partner_user.last_name = Faker::Name.last_name
    partner_user.save(validate: false)

    p_event = Partner::PartnerEvent.new
    p_event.event_code= "22-#{sprintf('%05d',Admin::Event.count+1)}" 
    p_event.created_by_id= partner_user.partner_id
    p_event.event_name= Faker::Restaurant.name
    p_event.event_content= Faker::Lorem.sentence
    p_event.venue= Faker::Address.full_address 
    p_event.category= "{NULL,1,2,3}"
    p_event.event_show_option= rand(1..3)
    p_event.apply_event_limit= 50 
    p_event.created_user_id= index+1 
    p_event.event_type= 2
    p_event.event_start_date= Faker::Date.backward(days: rand(5..30))
    p_event.event_end_date= Faker::Date.forward(days: rand(5..30))  
    p_event.post_start_date= Faker::Date.backward(days: rand(5..30)) 
    p_event.post_end_date= Faker::Date.forward(days: rand(5..30))
    p_event.application_deadline= p_event.event_end_date
    p_event.save
end
p "Created #{Partner::Partner.count} partners."
p "Created #{PartnerUser.count} partner users."
p "Created #{Admin::Event.where(event_type: 2).count} partner events."
