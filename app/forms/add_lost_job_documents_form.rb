class AddLostJobDocumentsForm < AddDocumentsForm
  def self.change_type
    "job_termination"
  end
end
