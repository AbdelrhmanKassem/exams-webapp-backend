class QrCodeGenerator

  require 'zip'
  require 'parallel'

  def initialize(exam)
    @exam = exam
    @private_key = OpenSSL::PKey::EC.new(Rails.application.credentials.students_jwt_ec_private_key)
  end

  def generate_qr_codes
    # Create a temporary file to store the zip file
    temp_file = Tempfile.new("qr_codes_exam_#{@exam.id}.zip")

    # Parallelize the processing of schools
    school_files = Parallel.map(School.all, in_threads: ActiveRecord::Base.connection_pool.db_config.pool / 2) do |school|
      process_school(school)
    end.compact

    # Create the zip file containing all the school pdf files
    Zip::OutputStream.open(temp_file.path) do |zip|
      school_files.each do |school_file_name, pdf_file_path|
        zip.put_next_entry(school_file_name)
        zip.print IO.read(pdf_file_path)
      end
    end

    # Delete the temporary directory containing the pdf files
    FileUtils.rm_rf(Rails.root.join("tmp/exam_qr_codes/exam_#{@exam.id}"))

    temp_file
  end

  private

  def process_school(school)
    pdf = Prawn::Document.new(page_size: 'A4')
    students_count = 0
    school_file_name = ''
    ActiveRecord::Base.connection_pool.with_connection do
      school.students.order(:seat_number).find_each do |student|
        # Skip students who are not in the exam
        next unless @exam.branch_ids.include?(student.branch_id)

        students_count += 1
        # Create a new page for each student
        write_student_to_pdf(pdf, student)
      end
      school_file_name = "district_#{school.district.id}_#{school.district.name}/school_#{school.id}_#{school.name}.pdf"
    end
    # Skip schools with no students
    return if students_count.zero?

    # Add the total number of pages to the first page
    pdf.go_to_page(1)
    pdf.move_cursor_to(pdf.bounds.top - 50)
    pdf.text('Number of students:', align: :center, size: 32)
    pdf.text(students_count.to_s, align: :center, size: 64)

    # Add page numbers staring from first student page
    pdf.number_pages '<page> / <total>', { start_count_at: 1,
                                          total_pages: students_count,
                                          page_filter: ->(pg) { pg != 1 },
                                          align: :right }

    # Write the pdf to a file and add it to the zip file
    directory = Rails.root.join("tmp/exam_qr_codes/exam_#{@exam.id}")
    FileUtils.mkdir_p directory
    pdf_file_path = "#{directory}/#{school.id}.pdf"
    pdf.render_file(pdf_file_path)
    return school_file_name, pdf_file_path
  end

  def write_student_to_pdf(pdf, student)
    # Generate a JWT token for the student and convert it to a QR code
    payload = generate_payload(student)
    jwt_token = JWT.encode(payload, @private_key, 'ES256')
    qr_code = RQRCode::QRCode.new(jwt_token)

    # Write the QR code to the pdf
    png = qr_code.as_png(size: 300)
    pdf.start_new_page
    # Center the QR code in the page
    pdf.image StringIO.new(png.to_s), at: [pdf.bounds.width / 2 - 150, pdf.bounds.height - 150], width: 300

    # Write the student name and seat number to the pdf
    pdf.move_down 10
    pdf.text "Student Name: #{student.full_name}", align: :center
    pdf.text "Seat Number: #{student.seat_number}", align: :center
  end

  def generate_payload(student)
    {
      student_seat_number: student.seat_number,
      exam_id: @exam.id,
      # TODO: Add Any Other Data Required by the Exam Service.
    }
  end
end
