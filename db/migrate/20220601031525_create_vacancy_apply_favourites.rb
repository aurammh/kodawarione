class CreateVacancyApplyFavourites < ActiveRecord::Migration[6.1]
  def change
    create_table :vacancy_apply_favourites do |t|
      t.belongs_to :student  
      t.belongs_to :company 
      t.belongs_to :company_vacancy
      t.boolean :apply_flg,:default => 'false'
      t.boolean :favourite_flg,:default => 'false'
      t.date :apply_date
      t.date :favourite_date
      t.integer :apply_status
      t.date :apply_status_date
      t.timestamps
    end
  end
end
