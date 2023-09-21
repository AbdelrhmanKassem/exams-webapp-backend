require 'csv'
require 'tempfile'
class StudentsController < AuthenticatedController
  include Sift

  filter_on :seat_number, type: :int
  filter_on :full_name, internal_name: :search_by_full_name, type: :scope
  filter_on :school_id, type: :int
  filter_on :branch_id, type: :int

  filter_on :school_name, type: :scope
  filter_on :district_id, type: :scope
  filter_on :branch_name, type: :scope

  sort_on :seat_number, type: :int
  sort_on :full_name, type: :string
  sort_on :email, type: :string
  sort_on :school_name, internal_name: :order_on_school_name, type: :scope, scope_params: [:direction]
  sort_on :branch_name, internal_name: :order_on_branch_name, type: :scope, scope_params: [:direction]


  def create
    authorize Student
    student = Student.new(student_params)

    if student.save
      render json: StudentBlueprint.render(student), status: :created
    else
      render json: { error: student.errors.messages }, status: :unprocessable_entity
    end
  end

  def index
    authorize Student
    students = filtrate(Student.all).page params[:page]
    render json: {
      students: StudentBlueprint.render_as_hash(students, view: :index),
      meta: PaginationBlueprint.render(students)
    }, status: :ok
  end

  def bulk_upload
    file = params[:file]
    # Create a temporary file to store the uploaded CSV
    temp_file = Tempfile.new(['uploaded', '.csv'])
    temp_file.binmode
    temp_file.write(file.read)
    temp_file.rewind

    # Parse the CSV data
    csv_data = CSV.read(temp_file)

    # Check if headers are present
    headers_present = csv_data[0].include?('fullName') && csv_data[0].include?('email') && csv_data[0].include?('seatNumber') && csv_data[0].include?('branchId') && csv_data[0].include?('schoolId')
    # Extract headers if present
    headers = headers_present ? csv_data.shift : ['fullName', 'email', 'seatNumber', 'branchId', 'schoolId']
    # Iterate over each row and process the data
    csv_data.each do |row|
      puts row.inspect
      # Access the data using row[index] or row[header] syntax
      full_name = headers_present ? row[0] : row[headers.index('fullName')]
      email = headers_present ? row[1] : row[headers.index('email')]
      seat_number = headers_present ? row[2] : row[headers.index('seatNumber')]
      branch_id = headers_present ? row[3] : row[headers.index('branchId')]
      school_id = headers_present ? row[4] : row[headers.index('schoolId')]

      # Process and save the records as needed
      student = Student.new(full_name:, email:, seat_number:, branch_id:, school_id:)
      student.save!
      # Create student records using the extracted data
    end

    # Clean up the temporary file
    temp_file.close
    temp_file.unlink

    # Provide any necessary response or redirect
    render json: { message: 'Students created successfully' }, status: :ok
  end

  def destroy
    authorize Student
    student = Student.find_by(seat_number: params[:id])
    if student.nil?
      render json: { error: I18n.t('messages.student.not_found') }, status: :not_found
      return
    end
    if student.destroy
      render json: {}, status: :ok
    else
      render json: { error: student.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def student_params
    params.require(:student).permit(:full_name, :email, :seat_number, :branch_id, :school_id)
  end
end
