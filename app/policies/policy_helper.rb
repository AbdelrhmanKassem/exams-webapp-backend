module PolicyHelper
  def admin?
    user.role == 'admin'
  end

  def examiner?
    user.role == 'examiner'
  end
end
