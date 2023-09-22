class Kodawarione::Plan < ApplicationRecord
    self.table_name = "plans"
    
    validates :name, length: { maximum: 100 }, presence: true
    validates :content, length: { maximum: 1500 }, presence: true
    validates :fee, length:{maximum: 7}, numericality: { only_integer: true }
end
