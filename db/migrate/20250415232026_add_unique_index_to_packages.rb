# frozen_string_literal: true

class AddUniqueIndexToPackages < ActiveRecord::Migration[8.0]
  def change
    add_index :registry_packages, %i[name version], unique: true
  end
end
