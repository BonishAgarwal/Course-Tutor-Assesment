require 'rails_helper'

RSpec.describe Course, type: :model do

  describe 'associations' do
    it 'should have many tutors' do
      tutors_relation = described_class.reflect_on_association(:tutors)
      expect(tutors_relation.macro).to eq(:has_many)
    end
  end

  describe 'validations' do
    context 'validate title' do
      it 'should validate presence of title' do
        course = build(:course, title: nil)
        expect(course.valid?).to eq(false)
        expect(course.errors.messages[:title]).to eq(["can't be blank"])
      end

      it 'should validate uniqueness of title' do
        create(:course, title: 'Ruby on Rails')
        course = build(:course, title: 'Ruby on Rails')
        expect(course.valid?).to eq(false)
        expect(course.errors.messages[:title]).to eq(['has already been taken'])
      end
    end

    context 'validate description' do
      it 'should validate presence of description' do
        course = build(:course, description: nil)
        expect(course.valid?).to eq(false)
        expect(course.errors.messages[:description]).to eq(["can't be blank"])
      end
    end

    context 'validate title and description' do
      context 'when title and description are present and title is unique' do
        it 'the course should be created successfully' do
          course = build(:course)
          expect(course.valid?).to eq(true)
        end
      end
    end
  end
end