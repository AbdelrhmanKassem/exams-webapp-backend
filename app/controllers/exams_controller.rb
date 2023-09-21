class ExamsController < ApplicationController

  include Sift

  filter_on :examiner_name, type: :scope
  filter_on :name, internal_name: :search_by_name, type: :scope
  filter_on :branches_include, type: :scope
  filter_on :in_progress, type: :scope

  sort_on :id, type: :int
  sort_on :examiner_name, internal_name: :order_on_examiner_name, type: :scope, scope_params: [:direction]
  sort_on :name, type: :string
  sort_on :start_time, type: :datetime
  sort_on :end_time, type: :datetime
  sort_on :max_grade, type: :decimal

  def create
    authorize Exam
    exam = Exam.new(exam_params)
    exam.examiner = current_user
    if exam.save
      branch_params['branches'].each do |branch_id|
        ExamBranch.create(branch_id: , exam_id: exam.id)
      end
      render json: ExamBlueprint.render(exam, view: :trusted), status: :created
    else
      render json: { error: exam.errors.messages }, status: :unprocessable_entity
    end
  end

  def index
    authorize Exam
    @exams = filtrate(policy_scope(Exam)).page params[:page]
    render json: {
      exams: ExamBlueprint.render_as_hash(@exams, view: :index),
      meta: PaginationBlueprint.render(@exams)
    }, status: :ok
  end

  def show
    exam = Exam.find_by(id: params[:id])
    if exam.nil?
      render json: { error: I18n.t('messages.exam.not_found') }, status: :not_found if exam.nil?
      return
    end
    authorize exam
    render json: ExamBlueprint.render(exam, view: :trusted), status: :ok
  end

  def update
    exam = Exam.find_by(id: params[:id])
    if exam.nil?
      render json: { error: I18n.t('messages.exam.not_found') }, status: :not_found if exam.nil?
      return
    end
    if exam.start_time.present? && exam.start_time.today?
      render json: { error: I18n.t('messages.exam.cannot_update') }, status: :unprocessable_entity
      return
    end
    authorize exam
    if exam.update(exam_params)
      if branch_params.present? && branch_params['branches'].present?
        branch_params['branches'].each do |branch_id|
          ExamBranch.create(branch_id: , exam_id: exam.id)
        end
      end
      render json: ExamBlueprint.render(exam, view: :trusted), status: :ok
    else
      render json: { error: exam.errors.messages }, status: :unprocessable_entity
    end
  end

  def generate_qr_codes
    exam = Exam.find_by(id: params[:id])
    district = District.find_by(id: params[:district_id])
    if exam.nil? || district.nil?
      render json: { error: I18n.t('messages.exam.not_found') }, status: :not_found if exam.nil?
      return
    end
    authorize exam

    response.headers['Content-Type'] = 'application/zip'
    response.headers['Content-Disposition'] = `attachment; filename="qr_codes_exam_#{exam.id}.zip"`

    qr_generator = QrCodeGenerator.new(exam, district)
    zip_file_path = qr_generator.generate_qr_codes

    File.open(zip_file_path, 'r') do |f|
      send_data zip_file_path.read, type: 'application/zip', disposition: 'attachment'
    end
    File.delete(zip_file_path)
  end

  def in_progress
    authorize Exam
    render json: { exams: ExamBlueprint.render_as_hash(Exam.started_today, view: :index) }, status: :ok
  end

  def destroy
    exam = Exam.find_by(id: params[:id])
    if exam.nil?
      render json: { error: I18n.t('messages.exam.not_found') }, status: :not_found if exam.nil?
      return
    end
    authorize exam
    if exam.start_time.present? && exam.start_time.today?
      render json: { error: I18n.t('messages.exam.cannot_delete') }, status: :unprocessable_entity
      return
    end
    if exam.destroy
      render json: {}, status: :ok
    else
      render json: { error: exam.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def exam_params
    params.require(:exam).permit(
      :name,
      :max_grade,
      :start_time,
      :end_time,
      questions: [:question, choices: []],
      answers: []
    )
  end

  def branch_params
    params.require(:exam).permit(branches: [])
  end

  def questions_params
    params.require(:exam).permit(questions)
  end

  def answers_params
    params.require(:exam).permit(answers)
  end
end
