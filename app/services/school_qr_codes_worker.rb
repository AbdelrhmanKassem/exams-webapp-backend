class SchoolQrCodesWorker
  include Sidekiq::Job
  sidekiq_options retry: false

  def perform(school_id, exam_id, request_id)
    school = School.find(school_id)
    @request_id = request_id
    @private_key = OpenSSL::PKey::EC.new(Rails.application.credentials.students_jwt_ec_private_key)
    @exam_id = exam_id
    process_school(school)
  end

  private

  def process_school(school)
    pdf = Prawn::Document.new(page_size: 'A4')
    students_count = 0
    school.students.order(:seat_number).find_each do |student|
      # Skip students who are not in the exam
      next unless Exam.find(@exam_id).branch_ids.include?(student.branch_id)

      students_count += 1
      # Create a new page for each student
      write_student_to_pdf(pdf, student)
    end
    # Skip schools with no students

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
    directory = Rails.root.join("tmp/#{@request_id}")
    FileUtils.mkdir_p directory
    pdf_file_path = "#{directory}/school_#{school.id}_#{school.name}.pdf"
    pdf.render_file(pdf_file_path)
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
      exam_id: @exam_id,
      # TODO: Add Any Other Data Required by the Exam Service.
    }
  end
end
