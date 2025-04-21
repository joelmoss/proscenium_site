# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :fruit
  enum :gender, { male: 0, female: 1, other: 2 }
  validates :name, presence: true
end
