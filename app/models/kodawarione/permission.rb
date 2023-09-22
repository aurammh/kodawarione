class Kodawarione::Permission < ApplicationRecord
    self.table_name = "permissions"
    validates :permission_name, length: { maximum: 1000 }, presence: true
    validates :action_name, length: { maximum: 1000 }, presence: true
    validates :permission_model_name, length: { maximum: 1000 }, presence: true
    validates :permission_for, length: {maximum: 8}, presence: true
    validates :permission_group, length: { maximum: 1000 }, presence: true
    validates :remark, length: { maximum: 1000 }, presence: true
    # validate :module_check
    # validate :controller_action_check

    private

    # def module_check
    #     return if module_name.blank?
    #     module_size = module_name.split(' ').size
    #     module_array = module_name.split(' ').map(&:capitalize)
    #     if module_array.any? {|el| el[0].start_with?(INT_REGEX)} || module_array.grep(SPECIAL_CHAR_REGEX).any?
    #         errors.add(:module_name,"is invalid.")
    #     else
    #         @module_var = module_size == 1 ? module_array[0] : module_array.shift.concat("::").concat(module_array * "")
    #         unless Object.const_defined?(@module_var)
    #             errors.add(:module_name, "is not defined.")
    #         end
    #     end
    # end

    # def controller_action_check
    #     return if controller_name.blank?
    #     controller_var = controller_name.split('/')[0].camelize
    #     action_var = controller_name.split('/')[1]
    #     return errors.add(:controller_name,"require controller_name.") if controller_var.blank?
    #     return errors.add(:controller_name,"require action_name.") if action_var.blank?
    #     if controller_var.start_with?(INT_REGEX) || controller_var.match?(SPECIAL_CHAR_REGEX)
    #         errors.add(:controller_name,"is invalid.")
    #     else
    #         controller_class = "Company::" + controller_var + "Controller"
    #         unless Object.const_defined?(controller_class)
    #             errors.add(:controller_name,"is not defined.")
    #         else
    #             unless controller_class.constantize.action_methods.include?(action_var)
    #                 errors.add(:controller_name,"action_method is not defined.")
    #             end
    #         end
    #     end
    # end
end
