module PolicyHelper
  def admin?
    user&.role&.name == 'admin'
  end

  def examiner?
    user&.role&.name == 'examiner'
  end

  def proctor?
    user&.role&.name == 'proctor'
  end
end
