class Api::V1::CoursesController < ApplicationController

  # Get all courses and their respective tutors
  def index
    @courses = Course.includes(:tutors).all.paginate(page: params[:page], per_page: params[:per_page])
    render json: @courses, each_serializer: CourseSerializer
  end

  # Create a new course with tutors
  def create
    @course = Course.new(course_params)
    if @course.save
      render json: { message: t('success', model_name: 'Course') }, status: :created
    else
      render json: { errors: @course.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Strong params for course
  def course_params
    params.require(:course)
          .permit(:title, :description,
                  tutors_attributes: [:name]
                )
  end

end