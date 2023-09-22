module Student::StudentCommitmentHelper
    def ability_options
        MCommitmentAbility.select(:id,:name).order(id: :asc)
    end
end
