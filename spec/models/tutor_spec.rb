require 'rails_helper'

RSpec.describe Tutor, type: :model do
  describe '#associations' do
    it 'should be associated with course' do
      course_relation = described_class.reflect_on_association(:course)
      expect(course_relation.macro).to eq(:belongs_to)
    end
  end

  describe '#validations' do
    context 'validate name' do
      it 'should validate presence of name' do
        tutor = build(:tutor, name: nil)
        expect(tutor.valid?).to eq(false)
        expect(tutor.errors.messages[:name]).to eq(["can't be blank"])
      end
    end
  end
end