require 'pry'
require_relative 'job'

class Scheduler
  def initialize(job_sequences)
    # Example:
    # job_sequence = "a =>
    #  b => c
    #  c => f
    #  d => a
    #  e => b
    #  f =>"
    @jobs = prepare(job_sequences)
  end

  # This will convert job_sequences into a hash,
  # where key will be JobName and value will be an object of Job
  # Example:
  # {"a"=>#<Job:0x007f9c1493bdd8 @dependent_job=nil, @name="a">,
  # "b"=>#<Job:0x007f9c1493bab8 @dependent_job="c", @name="b">,
  # "c"=>#<Job:0x007f9c1493b838 @dependent_job="f", @name="c">,
  # "d"=>#<Job:0x007f9c1493b5b8 @dependent_job="a", @name="d">,
  # "e"=>#<Job:0x007f9c1493b360 @dependent_job="b", @name="e">,
  # "f"=>#<Job:0x007f9c1493b1a8 @dependent_job=nil, @name="f">}
  def prepare(job_sequences)
    jobs = {}
    job_sequences.split("\n").each do |job_sequence|
      # Example:
      # job_sequence: "a => "
      # job_sequence: "b => c "

      # Now we need to strip the spaces from the jobs and extract JobName
      # and Dependent Job
      job_name, dependent_job = job_sequence.split('=>').map(&:strip)
      job = Job.new(job_name, dependent_job)
      jobs[job_name] = job
    end
    jobs
  end

  def execution_sequence
    resultant_sequence = []
    @jobs.each do |job_name, job|
      # If the Job is already in the sequence then ignore it
      next if resultant_sequence.include?(job_name)

      if job.independent?
        resultant_sequence.unshift(job_name)
      else
        # We need to get all dependent Jobs in order
        # and update the resultant sequence
        resolve_job_dependence(job, resultant_sequence)
      end
    end
    resultant_sequence
  end

  def resolve_job_dependence(job, resultant_sequence)
    raise SelfDependencyError if job.name == job.dependent_job

    if resultant_sequence.include?(job.dependent_job)
      # if the dependent job is already in the sequence we need to
      # just place this before job.dependent_job
      dependent_job_position = resultant_sequence.find_index(job.dependent_job)
      resultant_sequence.insert(dependent_job_position + 1, job.name)
    else
      resultant_sequence << job.name
      until job.independent?
        resultant_sequence.unshift(job.dependent_job)
        job = @jobs[job.dependent_job]
      end
    end
  end
end
