3.times do |index|

    admin = Admin.new
    admin.email ="SP1_member00#{index+1}@kodawarione.com"
    admin.password = "123456"
    admin.admin_code = ""
    admin.last_name = "SP00#{index+1}テスト管理者"
    admin.first_name = "00#{index+1}"
    admin.user_type = ""
    admin.confirmed_at = Faker::Date.in_date_period(year: 2019 , month: 2) 
    admin.save

    super_partner = Kodawarione::SuperPartner.new
    super_partner.name= "スーパーパートナー00#{index+1}"
    super_partner.super_partner_code= Faker::Number.leading_zero_number(digits: 4)
    super_partner.postal_code= "1600002"
    super_partner.address= Faker::Address.street_address 
    super_partner.display_address= "〒160-0002 東京都 新宿区 room-007"
    super_partner.phone_no= Faker::PhoneNumber.cell_phone
    super_partner.website_url= "www.kodawarione.com"
    super_partner.postalcode_city= "新宿区"
    super_partner.m_region_id= Faker::Number.number(digits: 1)
    super_partner.m_prefecture_id= Faker::Number.number(digits: 1)
    super_partner.save
    
    admin_member = Kodawarione::AdminMember.new
    admin_member.admins_id = admin.id
    admin_member.admin_roles_id = "2"
    admin_member.super_partners_id = super_partner.id
    admin_member.partners_id = ""
    admin_member.save
end
p "Created #{Admin.count} admins."
p "Created #{Kodawarione::SuperPartner.count} superpartners."
p "Created #{Kodawarione::AdminMember.count} adminmembers."

6.times do |index|

    admin = Admin.new
    admin.email ="P#{index+1}_member00#{index+1}@kodawarione.com"
    admin.password = "123456"
    admin.admin_code = ""
    admin.last_name = "P00#{index+1}テスト管理者"
    admin.first_name = "00#{index+1}"
    admin.user_type = ""
    admin.confirmed_at = Faker::Date.in_date_period(year: 2019 , month: 2) 
    admin.save

    partner = Kodawarione::Partner.new
    partner.super_partner_id = index <= 1? 1 : (index >=2 && index <=3)? 2 : 3
    partner.name= "パートナー00#{index+1}"
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

    admin_member = Kodawarione::AdminMember.new
    admin_member.admins_id = admin.id
    admin_member.admin_roles_id = "3"
    admin_member.super_partners_id = index <= 1? 1 : (index >=2 && index <=3)? 2 : 3
    admin_member.partners_id = partner.id
    admin_member.save

    10.times do  |index|
        s_user = User.new
        s_user.partner_id = partner.id
        s_user.email = "student#{(User.count+1).to_s.rjust(3, '0')}@gmail.com"
        s_user.password = "123456"    
        s_user.sign_in_count = 0
        s_user.confirmed_at = Faker::Time.backward(days: 1)
        s_user.save 
        
        s = Student::Student.new
        s.user_id = s_user.id
        s.nick_name = "学生 #{(User.count+1).to_s.rjust(3, '0')}"
        s.last_name = "学生"
        s.first_name = "#{(User.count+1).to_s.rjust(3, '0')}"
        s.last_name_kana = "学生"
        s.first_name_kana = "#{(User.count+1).to_s.rjust(3, '0')}"
        s.gender = rand(0..2)
        s.birthday = Faker::Date.birthday(min_age: 18 , max_age: 65)
        s.email_two = Faker::Internet.free_email 
        s.postal_code = 1600002
        s.postal_region_id = rand(2..40) 
        s.postalcode_city = "新宿区"
        s.address = Faker::Address.street_address
        s.display_address = "#{s.postal_code} #{s.postalcode_city} #{s.address}"
        s.phone_no = Faker::PhoneNumber.cell_phone
        s.school_type = rand(1..4)
        s.school_name = Faker::University.name
        s.department_name = Faker::Commerce.department
        s.subject_system = 1
        s.graduation_date = Faker::Date.in_date_period(year: 2019 , month: 2) 
        s.desire_industry_type_id = "{NULL,1,3}"
        s.desire_job_type_id =  "{NULL,3}"
        s.m_region_id = "3"
        s.m_prefecture_id = "{NULL,7}" 
        s.qualification_category_id =  "{NULL,3}"
        s.qualification_type_id =  "{NULL,4}"
        s.club_name = Faker::Team.name 
        s.club_position = Faker::Job.position 
        s.club_detail_activity = Faker::Lorem.sentences 
        s.club_guide = Faker::Team.sport 
        s.sns_blog_for_pr = "mailto:user01@123.com"
        s.job_info = Faker::Food.description 
        # student_image = URI.parse(Faker::Avatar.image(slug: [Faker::Creature::Cat.name,Faker::Creature::Bird.adjective].sample, size: "120x120", format: "jpg", set: ["set1","set2","set3","set4"].sample, bgset: ["bg1","bg2"].sample).to_s)
        # s.image.attach(io: student_image.open, filename: "#{s.nick_name}-avatar.jpg")
        s.current_address = 4
        s.preferred_working_area = "{NULL,3}"
        s.commitment = Faker::Lorem.characters
        s.cover_color = "#000000"
        s.qualification_string = Faker::Lorem.characters
        s.save(validate: false)
        
        c = Company::Company.new
        c.partner_id = partner.id
        c.m_industry_id = rand(2..20)
        c.job_info = Faker::Food.description
        c.capital_amount = 3.times.map{rand(1..9)}.join + "00000"
        c.employee_count = rand(5..210)
        c.sales_amount = 3.times.map{rand(1..9)}.join + "00000"
        c.related_company = "企業"
        c.main_bank = Faker::Bank.name
        c.history = Faker::Quote.famous_last_words
        c.basic_idea = Faker::IndustrySegments.sector
        c.representative = Faker::Name.name
        c.contact = Faker::PhoneNumber.cell_phone
        c.transportation_facilities = Faker::Vehicle.make
        c.company_name = "企業 #{(Company::Company.count+1).to_s.rjust(3, '0')}"
        c.company_name_kana = "企業 #{(Company::Company.count+1).to_s.rjust(3, '0')}"
        c.phone_no = Faker::PhoneNumber.cell_phone
        c.postal_code = "1600002"
        c.m_prefecture_id = rand(1..57)
        c.m_region_id = rand(1..11)
        c.postalcode_city = "新宿区"
        c.address = Faker::Address.street_address
        c.display_address = "〒" + c.postal_code + c.postalcode_city + c.address
        c.company_established = Faker::Date.in_date_period(year: 2012)
        c.company_intro = Faker::Lorem.paragraph(sentence_count: 8)
        c.website_url = "https://www.kodawarione.com"
        c.company_message = Faker::Lorem.paragraph(sentence_count: 5)
        c.other_message = Faker::Lorem.paragraph(sentence_count: 5)
        c.experience_requirements = Faker::Lorem.paragraph(sentence_count: 5)
        c.fresher_requirements = Faker::Lorem.paragraph(sentence_count: 5)
        c.fresher_second_requirements = Faker::Lorem.paragraph(sentence_count: 5)
        c.company_vision_mission = Faker::Quote.matz
        c.what_we_do = Faker::Quote.yoda
        c.how_we_do = Faker::Quote.jack_handey
        c.about_our_team = Faker::Lorem.paragraph(sentence_count: 8)
        c.member_message = Faker::Lorem.paragraph(sentence_count: 5)
        c.mail_setting = 0
        c.contact_email = "company#{(Company::Company.count+1).to_s.rjust(3, '0')}@gmail.com"
        company_image = URI.parse(Faker::Company.logo.to_s)
        c.image.attach(io: company_image.open, filename: "#{c.company_name}-logo.jpg")
        c.save(validate: false)
    
        c_user = CompanyUser.new
        c_user.email = c.contact_email
        c_user.password = "123456"
        c_user.first_name = "#{(Company::Company.count).to_s.rjust(3, '0')}"
        c_user.last_name = "企業"
        c_user.confirmed_at = Faker::Time.backward(days: 1)
        c_user.save
    
        c_member = Company::CompanyMember.new
        c_member.user_id = c_user.id
        c_member.user_email = c.contact_email
        c_member.company_id = c.id
        c_member.company_roles_id = 1
        c_member.department = Faker::Commerce.department
        c_member.position = Faker::Job.position
        c_member.join_flag = true
        c_member.save(validate: false)

        2.times do  |index|
            c_user = CompanyUser.new
            c_user.email = "C#{Company::Company.count}_member#{(index+1).to_s.rjust(3, '0')}@gmail.com"
            c_user.password = "123456"
            c_user.first_name = "#{(index+1).to_s.rjust(3, '0')}"
            c_user.last_name = "C#{Company::Company.count}_member"
            c_user.confirmed_at = Faker::Time.backward(days: 1)
            c_user.save
        
            c_member = Company::CompanyMember.new
            c_member.user_id = c_user.id
            c_member.user_email = "C#{Company::Company.count}_member#{(index+1).to_s.rjust(3, '0')}@gmail.com"
            c_member.company_id = c.id
            c_member.company_roles_id = 3
            c_member.department = Faker::Commerce.department
            c_member.position = Faker::Job.position
            c_member.join_flag = true
            c_member.save(validate: false)
        end
        
    end
end
p "Created #{Admin.count} admins."
p "Created #{Kodawarione::Partner.count} partners."
p "Created #{Kodawarione::AdminMember.count} adminmembers."
p "Created #{Student::Student.count} students."
p "Created #{Company::Company.count} companies."