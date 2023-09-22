class Student::QuestionnarieAssessmentsController < ApplicationController
  before_action :authenticate_user!, :authorize_user!

  def index
  end

  def questionnaire
    @questionnaires_data = Student::MStudentQuestionnaire.find_by_sql("
    select questionnaire_id, questionnaire_title, questionnaire_content,array_to_json(array_agg(row_to_json(answer))) as answer
    From (select id,questionnaire_id,questionnaire_answer from questionnaire_answers) answer
    INNER JOIN m_student_questionnaires ON answer.questionnaire_id = m_student_questionnaires.id
    group by questionnaire_id,questionnaire_title, questionnaire_content
    order by questionnaire_id")
    
    @student_assessment = Answer.find_by_sql("SELECT m_student_questionnaires.questionnaire_title, m_student_questionnaires.questionnaire_content,
    questionnaire_answers.questionnaire_answer,answers.*
    FROM answers
    INNER JOIN m_student_questionnaires ON m_student_questionnaires.id = answers.questionnaire_id
    INNER JOIN questionnaire_answers ON questionnaire_answers.id = answers.answer_id
    WHERE user_id = #{current_user.student.id} and answers.role = 'Student'
    ORDER BY m_student_questionnaires.id")
  end

  def create
    #student matched variable
    stu_trueMatchPoint = 0     
    stu_falseMatchPoint = 0
    stu_trueAdjustPoint = 0
    stu_falseAdjustPoint = 0

    #company matched variable
    com_trueMatchPoint = 0     
    com_falseMatchPoint = 0
    com_trueAdjustPoint = 0
    com_falseAdjustPoint = 0

    com_questionnaire_list = Company::MCompanyQuestionnaire.all
    stu_questionnaire_list = Student::MStudentQuestionnaire.all
    com_list = Company::Company.all      

    com_list.each do |value|
      company_assessment = Answer.select(:questionnaire_id, :answer_id, :choice_flg).where("answers.role = ? and answers.user_id = ?", 'Company', value.id).order(id: :asc)
      company_assessment.each_with_index do |com_value, c_index|
        #Student Side Calculation
        if (com_value.answer_id ==  params[:student_answer_data][c_index][:answer_id])       
          if (params[:student_answer_data][c_index][:choice_flg]==true) 
            stu_trueAdjustPoint += 20 * stu_questionnaire_list[c_index][:stages]
          else
            stu_falseAdjustPoint += 10 * stu_questionnaire_list[c_index][:stages]
          end 
        end      
        if (params[:student_answer_data][c_index][:choice_flg]==true)
          stu_trueMatchPoint += 20 * stu_questionnaire_list[c_index][:stages]
        else
          stu_falseMatchPoint += 10 * stu_questionnaire_list[c_index][:stages]
        end 
        #Company Side Calculation
        if (com_value.answer_id ==  params[:student_answer_data][c_index][:answer_id])       
          if com_value.choice_flg?
            com_trueAdjustPoint += 20 * com_questionnaire_list[c_index][:stages]
          else
            com_falseAdjustPoint += 10 * com_questionnaire_list[c_index][:stages]
          end 
        end      
        if com_value.choice_flg?
          com_trueMatchPoint += 20 * com_questionnaire_list[c_index][:stages]
        else
          com_falseMatchPoint += 10 * com_questionnaire_list[c_index][:stages]
        end  
      end
      if company_assessment.present?
        # assessment_matched_results for student-company
        db_data = AssessmentMatchedResult.new
        db_data.student_id = current_user.student.id
        db_data.company_id = value.id
        db_data.role = 'Student'
        db_data.matched_result = (((stu_trueAdjustPoint + stu_falseAdjustPoint).to_f / (stu_trueMatchPoint + stu_falseMatchPoint).to_f) * 100).round(2)
        db_data.save
        # assessment_matched_results for company-student
        exist_com_stu_db_data = AssessmentMatchedResult.where("company_id = ? and student_id = ? and role = ? ", value.id, current_user.student.id, 'Company').take
        if exist_com_stu_db_data.present?
          exist_com_stu_db_data.matched_result = (((com_trueAdjustPoint + com_falseAdjustPoint).to_f / (com_trueMatchPoint + com_falseMatchPoint).to_f) * 100).round(2)
          exist_com_stu_db_data.save
        else
          com_stu_db_data = AssessmentMatchedResult.new
          com_stu_db_data.student_id = current_user.student.id
          com_stu_db_data.company_id = value.id
          com_stu_db_data.role = 'Company'
          com_stu_db_data.matched_result = (((com_trueAdjustPoint + com_falseAdjustPoint).to_f / (com_trueMatchPoint + com_falseMatchPoint).to_f) * 100).round(2)
          com_stu_db_data.save
        end
      end 
      #reset student matched variable
      stu_trueMatchPoint = 0     
      stu_falseMatchPoint = 0
      stu_trueAdjustPoint = 0
      stu_falseAdjustPoint = 0   
      #reset company matched variable
      com_trueMatchPoint = 0     
      com_falseMatchPoint = 0
      com_trueAdjustPoint = 0
      com_falseAdjustPoint = 0
    end       
    params[:student_answer_data].each do |student_answer|
      @student_assessment = Answer.new(student_assessment_params(student_answer))
      @student_assessment.user_id = current_user.student.id
      @student_assessment.role = 'Student'
      @student_assessment.save
      flash[:success] = [t('common.create_success'), t("company_assessment.title")]
    end
    render :json => {:status => 'ok'}
  end  

  def update
    #student matched variable
    stu_trueMatchPoint = 0     
    stu_falseMatchPoint = 0
    stu_trueAdjustPoint = 0
    stu_falseAdjustPoint = 0

    #company matched variable
    com_trueMatchPoint = 0     
    com_falseMatchPoint = 0
    com_trueAdjustPoint = 0
    com_falseAdjustPoint = 0

    com_questionnaire_list = Company::MCompanyQuestionnaire.all
    stu_questionnaire_list = Student::MStudentQuestionnaire.all
    com_list = Company::Company.all   

    com_list.each_with_index do |value, com_index|
      company_assessment = Answer.select(:questionnaire_id, :answer_id, :choice_flg).where("answers.role = ? and answers.user_id = ?", 'Company', value.id).order(id: :asc)
      company_assessment.each_with_index do |com_value, c_index|
        #Student Side Calculation
        if (com_value.answer_id ==  params[:student_answer_data][c_index][:answer_id])       
          if (params[:student_answer_data][c_index][:choice_flg]==true) 
            stu_trueAdjustPoint += 20 * stu_questionnaire_list[c_index][:stages]
          else
            stu_falseAdjustPoint += 10 * stu_questionnaire_list[c_index][:stages]
          end 
        end      
        if (params[:student_answer_data][c_index][:choice_flg]==true)
          stu_trueMatchPoint += 20 * stu_questionnaire_list[c_index][:stages]
        else
          stu_falseMatchPoint += 10 * stu_questionnaire_list[c_index][:stages]
        end 
        #Company Side Calculation
        if (com_value.answer_id ==  params[:student_answer_data][c_index][:answer_id])       
          if com_value.choice_flg?
            com_trueAdjustPoint += 20 * com_questionnaire_list[c_index][:stages]
          else
            com_falseAdjustPoint += 10 * com_questionnaire_list[c_index][:stages]
          end 
        end      
        if com_value.choice_flg?
          com_trueMatchPoint += 20 * com_questionnaire_list[c_index][:stages]
        else
          com_falseMatchPoint += 10 * com_questionnaire_list[c_index][:stages]
        end  
      end
      if company_assessment.present?
        # assessment_matched_results for student-company
        exist_stu_com_db_data = AssessmentMatchedResult.where("company_id = ? and student_id = ? and role = ? ", value.id, current_user.student.id, 'Student').take
        if exist_stu_com_db_data.present?
          exist_stu_com_db_data.matched_result = (((stu_trueAdjustPoint + stu_falseAdjustPoint).to_f / (stu_trueMatchPoint + stu_falseMatchPoint).to_f) * 100).round(2)
          exist_stu_com_db_data.save
        else
          stu_com_db_data = AssessmentMatchedResult.new
          stu_com_db_data.student_id = current_user.student.id
          stu_com_db_data.company_id = value.id
          stu_com_db_data.role = 'Student'
          stu_com_db_data.matched_result = (((stu_trueAdjustPoint + stu_falseAdjustPoint).to_f / (stu_trueMatchPoint + stu_falseMatchPoint).to_f) * 100).round(2)
          stu_com_db_data.save
        end  
        # assessment_matched_results for company-student
        exist_com_stu_db_data = AssessmentMatchedResult.where("company_id = ? and student_id = ? and role = ? ", value.id, current_user.student.id, 'Company').take
        if exist_com_stu_db_data.present?
          exist_com_stu_db_data.matched_result = (((com_trueAdjustPoint + com_falseAdjustPoint).to_f / (com_trueMatchPoint + com_falseMatchPoint).to_f) * 100).round(2)
          exist_com_stu_db_data.save
        else
          com_stu_db_data = AssessmentMatchedResult.new
          com_stu_db_data.student_id = current_user.student.id
          com_stu_db_data.company_id = value.id
          com_stu_db_data.role = 'Company'
          com_stu_db_data.matched_result = (((com_trueAdjustPoint + com_falseAdjustPoint).to_f / (com_trueMatchPoint + com_falseMatchPoint).to_f) * 100).round(2)
          com_stu_db_data.save
        end
      end 
      #reset student matched variable
      stu_trueMatchPoint = 0     
      stu_falseMatchPoint = 0
      stu_trueAdjustPoint = 0
      stu_falseAdjustPoint = 0
      #reset company matched variable
      com_trueMatchPoint = 0     
      com_falseMatchPoint = 0
      com_trueAdjustPoint = 0
      com_falseAdjustPoint = 0
    end
    params[:student_answer_data].each do |student_answer|
      @student_assessment = Answer.new(student_assessment_params(student_answer))
      @existed_data = Answer.where(id: @student_assessment.id, user_id: current_user.student.id) 
      if @existed_data.present?
        @existed_data.update(student_assessment_params(student_answer))
        flash[:success] = [t('common.update_success'), t("company_assessment.title")]
      end
    end
    render :json => {:status => 'ok'}
  end

  private

  def student_assessment_params(student_answer)
    student_answer.permit(:user_id, :id, :questionnaire_id, :answer_id, :comment, :choice_flg, :delete_flg)    
  end

end
