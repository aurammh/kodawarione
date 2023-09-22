module Student::AssessmentsHelper
    #call enum function for priority language
    def priority_language_options
        Student::Assessment.priority_languages.each.map{ |k,v| [t("student_assessment.priority_language.#{k}"), v] }
    end

    #call enum function for eng qualification
    def english_qualification_options
        Student::Assessment.english_qualifications.keys.map{ |k| [t("student_assessment.english_qualification.#{k}"), k] }
    end

    #call enum function for toefl_test
    def toefl_test_options
        Student::Assessment.toefl_tests.keys.map{ |k| [t("student_assessment.toefl_test.#{k}"), k] }
    end

    #call enum function for toeic_test
    def toeic_test_options
        Student::Assessment.toeic_tests.keys.map{ |k| [t("student_assessment.toeic_test.#{k}"), k] }
    end

    #for radar chart one
    def selfEevaluationChart_rank(student_assessment) 
        selfEevaluation_A , selfEevaluation_B , selfEevaluation_C , selfEevaluation_D = 0
        replaceArray = [0, 0, 0, 0]
    
          if student_assessment.nil? 
            @chartOne  = [0,0,0,0]
                  
          elsif  student_assessment.logical_and_rational.nil? or student_assessment.solid_and_planned.nil?
            @chartOne  = [0,0,0,0]    
    
          else        
            selfEevaluation_A  = sumValue(student_assessment.logical_and_rational) 
            selfEevaluation_B =  sumValue(student_assessment.solid_and_planned) 
            selfEevaluation_C =  sumValue(student_assessment.sensory_and_friendly)     
            selfEevaluation_D =  sumValue(student_assessment.adventurous_and_original)
            totalSum =  selfEevaluation_A + selfEevaluation_B + selfEevaluation_C + selfEevaluation_D
            selfEevaluation_A = calEachSum(totalSum.to_f,selfEevaluation_A.to_f)
            selfEevaluation_B = calEachSum(totalSum.to_f,selfEevaluation_B.to_f)
            selfEevaluation_C = calEachSum(totalSum.to_f,selfEevaluation_C.to_f)
            selfEevaluation_D = calEachSum(totalSum.to_f,selfEevaluation_D.to_f)
            @chartOne  = [selfEevaluation_A,selfEevaluation_B,selfEevaluation_C,selfEevaluation_D]
          end
          result = @chartOne.zip(replaceArray).map{ |x,y| x || y }
          rankArray = result.map{|value| result.select{|item| item > value }.size + 1 }
          rankedMap = {A: rankArray[0], B: rankArray[1] , C: rankArray[2], D: rankArray[3]}
          @rankedChartOne = rankedMap.sort_by {|k, v| v}    
    end

    #for radar chart two
    def potentialDesireType(student_assessment)
      love_and_desire_to_belong,desire_for_power_and_value,desire_for_freedom,desire_for_fun,desire_for_survival = 0
      @chartTwo = []
        if student_assessment.nil?
          @chartTwo = [0,0,0,0,0]
  
        elsif student_assessment.love_and_desire_to_belong.nil?  or student_assessment.desire_for_power_and_value.nil?
          @chartTwo = [0,0,0,0,0] 
  
        else  
        love_and_desire_to_belong = sumValue(student_assessment.love_and_desire_to_belong)
        desire_for_power_and_value = sumValue(student_assessment.desire_for_power_and_value) 
        desire_for_freedom = sumValue(student_assessment.desire_for_freedom)
        desire_for_fun = sumValue(student_assessment.desire_for_fun)
        desire_for_survival = sumValue(student_assessment.desire_for_survival)
        @chartTwo = [love_and_desire_to_belong,desire_for_power_and_value,desire_for_freedom,desire_for_fun,desire_for_survival]
        end
        rankArray = @chartTwo.map{|value| @chartTwo.select{|item| item > value }.size + 1 }
        rankedMap = {A: rankArray[0], B: rankArray[1] , C: rankArray[2], D: rankArray[3], E: rankArray[4]}
        @rankedChartTwo = rankedMap.sort_by {|k, v| v}
    end

    def behavioralTraitTypeChart_rank(student_assessment)
      self_expression , self_assertion , self_flexibility = 0
      if student_assessment.nil? 
        @chartThree = ["null","null","null"]
              
      elsif  student_assessment.self_expression.nil? or student_assessment.self_assertion.nil?
        @chartThree = ["null","null","null"]    
  
      else        
        self_expression = calBehavioralType(student_assessment.self_expression)
        self_assertion = calBehavioralType(student_assessment.self_assertion)
        self_flexibility = calBehavioralType(student_assessment.self_flexibility)
        @chartThree = [self_expression,self_assertion,self_flexibility]
      end
    end

    def sumValue(arrVal) 
      sum = arrVal.inject(0){|sum,x| sum + x } 
      sum
    end
  
    def calEachSum(totalSum,val) 
      dev = sprintf("%3.2f", (val/totalSum)*2).to_f
      total = (dev*100).to_i 
      total
    end

    def calBehavioralType (arrVal)

      countAtimes = 0
      countBtimes = 0

      # make the hash default to 0 so that += will work correctly
      b = Hash.new(0)

      # iterate over the array, counting duplicate entries
      arrVal.each do |v|
        b[v] += 1
      end

      b.each do |k, v|
        if k == 1
          countAtimes = v 
        else
          countBtimes = v
        end
      end
      total = countBtimes - countAtimes
      total
    end

    def commitment_rank(student_commitment)
      @chart_commitment_range = []
      @chart_commitment_label = []
      if student_commitment.ability.present?
        @ability_list =
          if student_commitment.ability.present?
            ability_list = student_commitment.ability.select { |item| nil != item }
            ability_data_index =  ability_list.each_index.select do |i|
                                    ability_list[i] == 1
                                  end.map! { |element| element.is_a?(Integer) ? element + 1 : element }
            if ability_data_index.any?
              MCommitmentAbility.where("id IN (#{ability_data_index.join(',')})").map { |ab| ab.name }
            end
          end
          
        if !@ability_list.nil?
          @chart_commitment_range[0] = student_commitment.ability_one
          @chart_commitment_range[1] = student_commitment.ability_two
          @chart_commitment_range[2] = student_commitment.ability_three

          # chart label
          @chart_commitment_label = ["A", "B", "C"]
        else 
          @chart_commitment_range = [0,0,0]
          @ability_list = [" "," "," "]
          # chart label
          @chart_commitment_label = ["A", "B", "C"]
        end
       
      else
        @chart_commitment_range = [0,0,0]
        @ability_list = [" "," "," "]
        # chart label
        @chart_commitment_label = ["A", "B", "C"]
      end
    end

    def commitment_ability_chart(user_id)
      student_id = Student::Student.select("id").where("user_id = ?", user_id).take.id
      @chart_commitment_range = []
      @chart_commitment_label = []
      student_commitment_ability = Student::StudentCommitmentAbility.where("student_id = ? and status = ? ", student_id, "active").take 
      if student_commitment_ability.present?
        @ability_list = Student::StudentCommitmentAbilityDetail.joins("INNER JOIN m_commitment_abilities on m_commitment_abilities.id = student_commitment_ability_details.m_commitment_abilities_id").select(:ability_value,:ability_reason,:m_commitment_abilities_id,:name).where("student_commitment_ability_id = ?",student_commitment_ability.id)
        if !@ability_list.nil?
          @chart_commitment_range[0] = @ability_list[0].ability_value
          @chart_commitment_range[1] = @ability_list[1].ability_value
          @chart_commitment_range[2] = @ability_list[2].ability_value

          # chart label
          @chart_commitment_label = ["A", "B", "C"]
        else 
          @chart_commitment_range = [0,0,0]
          @ability_list = [" "," "," "]
          # chart label
          @chart_commitment_label = ["A", "B", "C"]
        end
      else
        @chart_commitment_range = [0,0,0]
        @ability_list = [" "," "," "]
        # chart label
        @chart_commitment_label = ["A", "B", "C"]
      end
    end

    def commitment_ability_comment(index)
      case index
      when 0
        @ability_list[0].ability_reason
      when 1
        @ability_list[1].ability_reason
      when 2
        @ability_list[2].ability_reason
      end
  end

    def commitment_comment(index)
        case index
        when 0
          @user_commitment.ability_reason_one
        when 1
          @user_commitment.ability_reason_two
        when 2
          @user_commitment.ability_reason_three
        when 3
          @user_commitment.ability_reason_four
        when 4
          @user_commitment.ability_reason_five
        end
    end
    # commitment chart for company
  def commitment_ability_chart_for_company(com_id)
    @chart_commitment_range = []
    @chart_commitment_label = []  
    company_commitment_ability = Company::CompanyCommitmentAbility.where("company_id = ? and status = ? ", com_id, "active").take 
    if company_commitment_ability.present?
      @ability_list = Company::CompanyCommitmentAbilityDetail.joins("INNER JOIN m_commitment_abilities on m_commitment_abilities.id = company_commitment_ability_details.m_commitment_abilities_id").select(:ability_value,:ability_reason,:m_commitment_abilities_id,:name).where("company_commitment_ability_id = ?",company_commitment_ability.id)
      if !@ability_list.nil?
        @chart_commitment_range[0] = @ability_list[0].ability_value
        @chart_commitment_range[1] = @ability_list[1].ability_value
        @chart_commitment_range[2] = @ability_list[2].ability_value

        # chart label
        @chart_commitment_label = ["A", "B", "C"]
      else 
        @chart_commitment_range = [0,0,0]
        @ability_list = [" "," "," "]
        # chart label
        @chart_commitment_label = ["A", "B", "C"]
      end
    else
      @chart_commitment_range = [0,0,0]
      @ability_list = [" "," "," "]
      # chart label
      @chart_commitment_label = ["A", "B", "C"]
    end
  end
end