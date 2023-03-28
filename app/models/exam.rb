# == Schema Information
#
# Table name: exams
#
#  id          :bigint           not null, primary key
#  examiner_id :bigint           not null
#  start_time  :datetime         not null
#  end_time    :datetime         not null
#  max_grade   :decimal(, )      not null
#  questions   :text             not null
#  answers     :text             not null
#  name        :string
#
class Exam < ApplicationRecord
  belongs_to :examiner, class_name: 'User'
  has_many :exam_branches
  has_many :branches, through: :exam_branches

  validates :examiner, :questions, :answers, :max_grade, :start_time, :end_time, :name, presence: true
  validates :max_grade, numericality: { greater_than_or_equal_to: 0 }

  validates_datetime :start_time, after: -> { Time.current }, on: :create
  validates_datetime :end_time, after: :start_time

  encrypts :questions, :answers

  scope :branches_include, ->(id) { joins(:exam_branches).where('exam_branches.branch_id = ?', id) }
  scope :in_progress, -> { where('start_time <= ? AND end_time >= ?', Time.current, Time.current) }
end
