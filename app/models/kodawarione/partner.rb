class Kodawarione::Partner < ApplicationRecord
    belongs_to :m_regions, class_name: "MRegion", foreign_key: "m_region_id",optional: true
    belongs_to :m_prefectures, class_name: "MPrefecture", foreign_key: "m_prefecture_id",optional: true
    self.table_name = "partners"
    has_many :admin_members, class_name: "Kodawarione::AdminMember", foreign_key: "partners_id"
    attr_accessor :prefecture_name,:region_name

    validates :name, length: { maximum: 255 }, presence: true
    validates :super_partner_id, presence: true
    validates :website_url, presence: true, :format => { :with => VALID_URL_REGEX, message: "がフォーマット正しくありません。" }, length: { maximum: 255 }, on: :update,  if: :website_url_changed?
    validates :address, length: { maximum: 255 }, presence: true, on: :update, if: :address_changed?
    validates :display_address, presence: true, on: :update
    validates :postal_code, presence: true, on: :update, if: :postal_code_changed?
    validates :phone_no, presence: true, length: { within: 6..20 }, on: :update
    validates :postalcode_city, presence: true, on: :update
    validates :m_prefecture_id, presence: true, on: :update
    validates :m_region_id , presence: true, on: :update
end
