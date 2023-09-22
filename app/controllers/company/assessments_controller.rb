class Company::AssessmentsController < ApplicationController
  before_action :authenticate_company_user!
  authorize_resource class: 'Company::MCompanyQuestionnaire'

  def index
    @questionnaires_data = Company::MCompanyQuestionnaire.find_by_sql("
      select questionnaire_id, questionnaire_title, questionnaire_content,array_to_json(array_agg(row_to_json(answer))) as answer
    From (select id,questionnaire_id,questionnaire_answer from questionnaire_answers) answer
    INNER JOIN m_company_questionnaires ON answer.questionnaire_id = m_company_questionnaires.id
      group by questionnaire_id,questionnaire_title, questionnaire_content
      order by questionnaire_id")
      
      @company_assessment = Answer.find_by_sql("SELECT m_company_questionnaires.questionnaire_title, m_company_questionnaires.questionnaire_content,
      questionnaire_answers.questionnaire_answer,answers.*
      FROM answers
      INNER JOIN m_company_questionnaires ON m_company_questionnaires.id = answers.questionnaire_id
      INNER JOIN questionnaire_answers ON questionnaire_answers.id = answers.answer_id
      WHERE user_id = #{current_company.id} and answers.role = 'Company'
      ORDER BY m_company_questionnaires.id")
  end

  def questionnaire
    @questionnaires_data = Company::MCompanyQuestionnaire.find_by_sql("
    select questionnaire_id, questionnaire_title, questionnaire_content,array_to_json(array_agg(row_to_json(answer))) as answer
    From (select id,questionnaire_id,questionnaire_answer from questionnaire_answers) answer
    INNER JOIN m_company_questionnaires ON answer.questionnaire_id = m_company_questionnaires.id
    group by questionnaire_id,questionnaire_title, questionnaire_content
    order by questionnaire_id")
    
    @company_assessment = Answer.find_by_sql("SELECT m_company_questionnaires.questionnaire_title, m_company_questionnaires.questionnaire_content,
    questionnaire_answers.questionnaire_answer,answers.*
    FROM answers
    INNER JOIN m_company_questionnaires ON m_company_questionnaires.id = answers.questionnaire_id
    INNER JOIN questionnaire_answers ON questionnaire_answers.id = answers.answer_id
    WHERE user_id = #{current_company.id} and answers.role = 'Company'
    ORDER BY m_company_questionnaires.id")
    @create_permission = can? :create, Company::MCompanyQuestionnaire
    @update_permission = can? :update, Company::MCompanyQuestionnaire
  end

  def create
    #company matched variable
    com_trueMatchPoint = 0     
    com_falseMatchPoint = 0
    com_trueAdjustPoint = 0
    com_falseAdjustPoint = 0 

    #student matched variable
    stu_trueMatchPoint = 0     
    stu_falseMatchPoint = 0
    stu_trueAdjustPoint = 0
    stu_falseAdjustPoint = 0

    com_questionnaire_list = Company::MCompanyQuestionnaire.all
    stu_questionnaire_list = Student::MStudentQuestionnaire.all
    std_list = Student::Student.all    

    std_list.each_with_index do |value, index|
      student_assessment = Answer.select(:questionnaire_id, :answer_id, :choice_flg).where("answers.role = ? and answers.user_id = ?", 'Student', value.id).order(id: :asc)
      student_assessment.each_with_index do |std_value, s_index|
        #Company Side Calculation 
        if (std_value.answer_id ==  params[:company_answer_data][s_index][:answer_id])       
          if (params[:company_answer_data][s_index][:choice_flg]==true)
            com_trueAdjustPoint += 20 * com_questionnaire_list[s_index][:stages]
          else
            com_falseAdjustPoint += 10 * com_questionnaire_list[s_index][:stages]
          end 
        end      
        if (params[:company_answer_data][s_index][:choice_flg]==true)
          com_trueMatchPoint += 20 * com_questionnaire_list[s_index][:stages]
        else
          com_falseMatchPoint += 10 * com_questionnaire_list[s_index][:stages]
        end   
        #Student Side Calculation
        if (std_value.answer_id ==  params[:company_answer_data][s_index][:answer_id])    
          if std_value.choice_flg?
            stu_trueAdjustPoint += 20 * stu_questionnaire_list[s_index][:stages]
          else
            stu_falseAdjustPoint += 10 * stu_questionnaire_list[s_index][:stages]
          end
        end
        if std_value.choice_flg?
          stu_trueMatchPoint += 20 * stu_questionnaire_list[s_index][:stages]
        else
          stu_falseMatchPoint += 10 * stu_questionnaire_list[s_index][:stages]
        end
      end
      if student_assessment.present?
        # assessment_matched_results for company-student
        db_data = AssessmentMatchedResult.new        
        db_data.company_id = current_company.id
        db_data.student_id = value.id 
        db_data.role = 'Company'
        db_data.matched_result = (((com_trueAdjustPoint + com_falseAdjustPoint).to_f/(com_trueMatchPoint + com_falseMatchPoint).to_f)*100).round(2)
        db_data.save
        # assessment_matched_results for student-company
        exist_stu_com_db_data = AssessmentMatchedResult.where("company_id = ? and student_id = ? and role = ? ", current_company.id, value.id, 'Student').take
        if exist_stu_com_db_data.present?
          exist_stu_com_db_data.matched_result = (((stu_trueAdjustPoint + stu_falseAdjustPoint).to_f/(stu_trueMatchPoint + stu_falseMatchPoint).to_f)*100).round(2)
          exist_stu_com_db_data.save
        else
          stu_com_db_data = AssessmentMatchedResult.new        
          stu_com_db_data.company_id = current_company.id
          stu_com_db_data.student_id = value.id 
          stu_com_db_data.role = 'Student'
          stu_com_db_data.matched_result = (((stu_trueAdjustPoint + stu_falseAdjustPoint).to_f/(stu_trueMatchPoint + stu_falseMatchPoint).to_f)*100).round(2)
          stu_com_db_data.save
        end
      end
      #reset company matched variable
      com_trueMatchPoint = 0     
      com_falseMatchPoint = 0
      com_trueAdjustPoint = 0
      com_falseAdjustPoint = 0
      #reset student matched variable
      stu_trueMatchPoint = 0     
      stu_falseMatchPoint = 0
      stu_trueAdjustPoint = 0
      stu_falseAdjustPoint = 0
    end
    params[:company_answer_data].each do |company_answer|
      @company_assessment = Answer.new(company_assessment_params(company_answer))
      @company_assessment.user_id = current_company.id
      @company_assessment.role = 'Company'
      @company_assessment.save
      flash[:success] = [t('common.create_success'), t("company_assessment.title")]
    end
    render :json => {:status => 'ok'}
  end


  def update
    #company matched variable
    com_trueMatchPoint = 0     
    com_falseMatchPoint = 0
    com_trueAdjustPoint = 0
    com_falseAdjustPoint = 0

    #student matched variable
    stu_trueMatchPoint = 0     
    stu_falseMatchPoint = 0
    stu_trueAdjustPoint = 0
    stu_falseAdjustPoint = 0

    com_questionnaire_list = Company::MCompanyQuestionnaire.all
    stu_questionnaire_list = Student::MStudentQuestionnaire.all
    std_list = Student::Student.all    

    std_list.each do |value|
      student_assessment = Answer.select(:questionnaire_id, :answer_id, :choice_flg).where("answers.role = ? and answers.user_id = ?", 'Student', value.id).order(id: :asc)
      student_assessment.each_with_index do |std_value, s_index|
        #Company Side Calculation 
        if (std_value.answer_id ==  params[:company_answer_data][s_index][:answer_id])       
          if (params[:company_answer_data][s_index][:choice_flg]==true)
            com_trueAdjustPoint += 20 * com_questionnaire_list[s_index][:stages]
          else
            com_falseAdjustPoint += 10 * com_questionnaire_list[s_index][:stages]
          end 
        end      
        if (params[:company_answer_data][s_index][:choice_flg]==true)
          com_trueMatchPoint += 20 * com_questionnaire_list[s_index][:stages]
        else
          com_falseMatchPoint += 10 * com_questionnaire_list[s_index][:stages]
        end    
        #Student Side Calculation
        if (std_value.answer_id ==  params[:company_answer_data][s_index][:answer_id])    
          if std_value.choice_flg?
            stu_trueAdjustPoint += 20 * stu_questionnaire_list[s_index][:stages]
          else
            stu_falseAdjustPoint += 10 * stu_questionnaire_list[s_index][:stages]
          end
        end
        if std_value.choice_flg?
          stu_trueMatchPoint += 20 * stu_questionnaire_list[s_index][:stages]
        else
          stu_falseMatchPoint += 10 * stu_questionnaire_list[s_index][:stages]
        end
      end 
      if student_assessment.present?
        # assessment_matched_results for company-student
        exist_com_stu_db_data = AssessmentMatchedResult.where("company_id = ? and student_id = ? and role = ? ", current_company.id, value.id, 'Company').take
        if exist_com_stu_db_data.present?
          exist_com_stu_db_data.matched_result = (((com_trueAdjustPoint + com_falseAdjustPoint).to_f/(com_trueMatchPoint + com_falseMatchPoint).to_f)*100).round(2)
          exist_com_stu_db_data.save
        else
          com_stu_db_data = AssessmentMatchedResult.new
          com_stu_db_data.student_id = value.id 
          com_stu_db_data.company_id = current_company.id
          com_stu_db_data.role = 'Company'
          com_stu_db_data.matched_result = (((com_trueAdjustPoint + com_falseAdjustPoint).to_f/(com_trueMatchPoint + com_falseMatchPoint).to_f)*100).round(2)
          com_stu_db_data.save
        end   
        # assessment_matched_results for student-company
        exist_stu_com_db_data = AssessmentMatchedResult.where("company_id = ? and student_id = ? and role = ? ", current_company.id, value.id, 'Student').take
        if exist_stu_com_db_data.present?
          exist_stu_com_db_data.matched_result = (((stu_trueAdjustPoint + stu_falseAdjustPoint).to_f/(stu_trueMatchPoint + stu_falseMatchPoint).to_f)*100).round(2)
          exist_stu_com_db_data.save
        else
          stu_com_db_data = AssessmentMatchedResult.new        
          stu_com_db_data.company_id = current_company.id
          stu_com_db_data.student_id = value.id 
          stu_com_db_data.role = 'Student'
          stu_com_db_data.matched_result = (((stu_trueAdjustPoint + stu_falseAdjustPoint).to_f/(stu_trueMatchPoint + stu_falseMatchPoint).to_f)*100).round(2)
          stu_com_db_data.save
        end
      end  
      #reset company matched variable
      com_trueMatchPoint = 0     
      com_falseMatchPoint = 0
      com_trueAdjustPoint = 0
      com_falseAdjustPoint = 0
      #reset student matched variable
      stu_trueMatchPoint = 0     
      stu_falseMatchPoint = 0
      stu_trueAdjustPoint = 0
      stu_falseAdjustPoint = 0 
    end
    params[:company_answer_data].each do |company_answer|
      @company_assessment = Answer.new(company_assessment_params(company_answer))
      @existed_data = Answer.where(id: @company_assessment.id, user_id: current_company.id) 
      if @existed_data.present?
        @existed_data.update(company_assessment_params(company_answer))
        flash[:success] = [t('common.update_success'), t("company_assessment.title")]
      end
    end
    render :json => {:status => 'ok'}
  end

  private

  def company_assessment_params(company_answer)
    company_answer.permit(:user_id, :id, :questionnaire_id, :answer_id, :comment, :choice_flg, :delete_flg)    
  end

end
