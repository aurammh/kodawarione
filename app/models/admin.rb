class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,:timeoutable,
         :recoverable, :rememberable, :validatable,:confirmable

         attr_accessor :check_password, :current_password, :check_current_password ,:check_update ,:chk_pass_edit ,:chk_edit_email ,:check_email
         
    validates :email, uniqueness: true, length: { maximum: 255 }, presence: true,on: :update, if: :check_email
    validates :current_password, presence: true, if: :check_current_password
    validates :password, presence: true, if: :check_password
    validates :password, confirmation: true, if: :check_password
    validates_confirmation_of :password, if: :check_password
    validates :first_name, length: { maximum: 255 }, presence: true
    validates :last_name, length: { maximum: 255 }, presence: true

    has_one :admin_member, class_name: "Kodawarione::AdminMember", foreign_key: "admins_id", dependent: :destroy

    def chief_administrator?
      self.admin_member.admin_roles_id == 1 ? true : false
    end

    def super_partner?
      self.admin_member.admin_roles_id == 2 ? true : false
    end

    def partner?
      self.admin_member.admin_roles_id == 3 ? true : false
    end

    private

    def password_required?
      if self.check_update
        if self.check_password
          return true
          super
        else
          return false
        end
      else
        new_record? ? false : super
      end
    end

    def first_name_changed
      if first_name.blank?
        errors.add(:first_name) 
      end 
    end
  
    def last_name_changed
      if last_name.blank?
        errors.add(:last_name) 
      end
    end
end