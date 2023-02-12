class Course < ApplicationRecord

  # Associations
  has_many :tutors, dependent: :destroy
  accepts_nested_attributes_for :tutors

  # Validations
  validates :title, :description, presence: true
  validates :title, uniqueness: true
end