class AddAdditionalAttributeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :additional_attribute, :string
  end
end
