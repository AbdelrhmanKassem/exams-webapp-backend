class CheatCaseBlueprint < Blueprinter::Base

  fields :notes
  association :proctor, blueprint: UserBlueprint
  association :exam, blueprint: ExamBlueprint
  association :student, blueprint: StudentBlueprint

end
