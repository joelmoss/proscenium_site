# frozen_string_literal: true

class Fruit < ApplicationRecord
  has_many :users # rubocop:disable Rails/HasManyOrHasOneDependent
  def to_s = name
end
