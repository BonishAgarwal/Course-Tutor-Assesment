require 'rails_helper'

RSpec.describe Api::V1::CoursesController, type: :request do

  let(:course) { create(:course) }
  let(:tutor) { create(:tutor, course: course) }
  let(:tutor2) { create(:tutor, course: course) } # create another tutor for the same course

  describe '#index' do

    def get_all_courses(params:)
      get "/api/v1/courses", params: params
    end
    
    it 'should return all courses' do
      course
      tutor
      tutor2
      get_all_courses(params: { page: 1, per_page: 5 })
      response_body = JSON.parse(response.body)
      expect(response.code).to eq('200')
      expect(response_body.count).to eq(1)
      expect(response_body[0]['tutors'].count).to eq(2)
    end
  end

  describe '#create' do

    before(:each) do
      post "/api/v1/courses", params: params
    end

    context 'when params are valid' do
      let(:params) do 
      { 
        course: { 
                title: 'Course 1', 
                description: 'Description 1', 
                tutors_attributes: 
                  [
                    { 
                      name: 'Tutor 1' 
                    }, 
                    { 
                      name: 'Tutor 2' 
                    }
                  ] 
                } 
      }
      end

      it 'should create a course' do
        expect(Course.count).to eq(1)
      end

      it 'should create tutors for the course' do
        expect(Tutor.count).to eq(2)
      end

      it 'should return a success message' do
        response_body = JSON.parse(response.body)
        expect(response.code).to eq('201')
        expect(response_body['message']).to eq('Course created successfully')
      end
    end

    context 'when params are invalid' do
      let(:params) do 
        { 
          course: { 
                  title: nil,
                  description: 'Description 1'
          }
        }
      end

      it 'should not create a course' do
        expect(Course.count).to eq(0)
      end

      it 'should return an error message' do
        response_body = JSON.parse(response.body)
        expect(response.code).to eq('422')
        expect(response_body['errors']).to eq(["Title can't be blank"])
      end
    end

    context 'when tutor name is blank' do
      let(:params) do 
        { 
          course: { 
                  title: 'Course 1', 
                  description: 'Description 1', 
                  tutors_attributes: 
                    [
                      { 
                        name: nil 
                      }
                    ] 
                  }
        }
      end

      it 'should return an error message' do
        expect(response.code).to eq('422')
        expect(JSON.parse(response.body)['errors']).to eq(["Tutors name can't be blank"])
      end
    end 
  end
end