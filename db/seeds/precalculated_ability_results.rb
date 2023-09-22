commitment_ability_list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24];
commitment_ability_degree_list = [3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33.75, 37.50, 41.25, 45, 48.75, 52.50, 56.25, 60, 65, 70, 75, 80, 85, 90];

commitment_ability_list.each_with_index do |list_1, index_1|
    commitment_ability_list.each_with_index do |list_2, index_2|           
        PreCalculatedAbilityResults.create!(
        {
            ability_1_id: list_1,
            ability_2_id: list_2,
            matched_percentage: (Math.cos(((commitment_ability_degree_list[index_1] - commitment_ability_degree_list[index_2]).abs)*(Math::PI/180)) * 100).round(2) ,
            original_matched_result: (Math.cos(((commitment_ability_degree_list[index_1] - commitment_ability_degree_list[index_2]).abs)*(Math::PI/180))).round(5),
            delete_flg: false
        }
    )
    end
end

p "Created #{PreCalculatedAbilityResults.count}.precalculated_ability_result"
