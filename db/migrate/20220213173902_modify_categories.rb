class ModifyCategories < ActiveRecord::Migration[6.1]
  def change
    add_index :categories, :alias, unique: true
    Category.create(:alias => "football", :title => "Футбол")
    Category.create(:alias => "hockey", :title => "Хоккей")
    Category.create(:alias => "futsal", :title => "Футзал")
    Category.create(:alias => "basketball", :title => "Баскетбол")
    Category.create(:alias => "handball", :title => "Гандбол")
  end
end
