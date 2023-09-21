class QrCodeGenerator

  require 'zip'
  require 'fileutils'

  def initialize(exam, district)
    @exam = exam
    @district = district
  end

  def generate_qr_codes
    request_id = SecureRandom.uuid
    output_folder = Rails.root.join("tmp/#{request_id}")
    FileUtils.mkdir_p(output_folder)

    batch = Sidekiq::Batch.new
    begin
      batch.jobs do
        @district.school_ids.each { |school_id| SchoolQrCodesWorker.perform_async(school_id, @exam.id, request_id) }
      end
    rescue => exception
    end

    sleep(1) while Dir.glob("#{output_folder}/*").count < @district.school_ids.count

    zip_file_path = Rails.root.join("tmp/qr_codes_exam_#{@exam.id}_district_#{@district.id}.zip")

    Zip::File.open(zip_file_path, Zip::File::CREATE) do |zipfile|
      Dir.glob("#{output_folder}/*").each do |file_path|
        filename = File.basename(file_path)
        zipfile.add(filename, file_path)
      end
    end

    FileUtils.rm_rf(Rails.root.join(output_folder))

    zip_file_path
  end
end
