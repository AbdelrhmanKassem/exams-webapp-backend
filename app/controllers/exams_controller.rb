class ExamsController < ApplicationController

  include Sift

  filter_on :examiner_id, type: :int
  filter_on :name, type: :string
  filter_on :branches_include, type: :scope
  filter_on :in_progress, type: :scope

  sort_on :examiner_id, type: :int
  sort_on :start_time, type: :datetime
  sort_on :end_time, type: :datetime
  sort_on :max_grade, type: :decimal

  def create
    authorize Exam
    exam = Exam.new(exam_params)
    exam.examiner = current_user
    if exam.save
      branch_params['branches'].each do |branch|
        ExamBranch.create(branch_id: Integer(branch['id']), exam_id: exam.id)
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
      exams: ExamBlueprint.render_as_hash(@exams),
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
    authorize exam
    if exam.update(exam_params)
      branch_params['branches']&.each do |branch|
        ExamBranch.create(branch_id: branch['branch_id'], exam_id: exam.id)
      end
      render json: ExamBlueprint.render(exam, view: :trusted), status: :ok
    else
      render json: exam.errors, status: :unprocessable_entity
    end
  end

  def generate_qr_codes
    exam = Exam.find_by(id: params[:id])
    if exam.nil?
      render json: { error: I18n.t('messages.exam.not_found') }, status: :not_found if exam.nil?
      return
    end
    authorize exam

    response.headers['Content-Type'] = 'application/zip'
    response.headers['Content-Disposition'] = `attachment; filename="qr_codes_exam_#{exam.id}.zip"`

    qr_generator = QrCodeGenerator.new(exam)
    temp_file = qr_generator.generate_qr_codes
    temp_file.rewind
    send_data temp_file.read, type: 'application/zip', disposition: 'attachment', filename: "qr_codes_exam_#{exam.id}.zip"

    temp_file.close
    temp_file.unlink
  end

  private

  def exam_params
    params.require(:exam).permit(:start_time, :end_time, :max_grade, :questions, :answers)
  end

  def branch_params
    params.require(:exam).permit(branches: ['id'])
  end
end
