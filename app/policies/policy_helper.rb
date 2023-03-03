module PolicyHelper
  def admin?
    user&.role&.name == 'admin'
  end

  def examiner?
    user&.role&.name == 'examiner'
  end
end
