class Job
  attr_accessor :name
  attr_accessor :dependent_job

  def initialize(name, dependent_job)
    @name = name
    @dependent_job = dependent_job
  end
end
