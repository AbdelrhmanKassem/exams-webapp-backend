module External
  class ExamServiceController < ApplicationController
    before_action :validate_request, :authenticate_exam_service_request

    def exam
      exam = Exam.find_by(id: params[:id])
      unless exam
        render json: { error: I18n.t('messages.exam.not_found') }, status: :not_found
        return
      end
      render json: ExamBlueprint.render(exam, view: :trusted), status: :ok if valid_exam_time(exam)
    end

    private

    def valid_exam_time (exam)
      if exam.start_time > Time.current + 30.minutes
        render json: { error: I18n.t('messages.exam.too_early') }, status: :not_found
      elsif exam.end_time < Time.current
        render json: { error: I18n.t('messages.exam.too_late') }, status: :not_found
      elsif exam.start_time < Time.current - 15.minutes
        render json: { error: I18n.t('messages.exam.too_late_to_start') }, status: :not_found
      else
        return true
      end
      false
    end

    def authenticate_exam_service_request
      api_key_validator = SimpleStructuredSecrets.new('E', 's')
      unauthorized unless
        api_key_validator.validate(api_key_header) &&
        Digest::SHA256.hexdigest(api_key_header) == Rails.application.credentials.exam_service_api_key_hash
    end

    def validate_request
      return if api_key_header.present?

      render json: { error: I18n.t('errors.bad_request') }, status: :bad_request
    end

    def api_key_header
      request.headers['X-API-KEY']
    end
  end
end
