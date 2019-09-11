require_relative '../lib/scheduler'

describe "#execution_sequence" do
  context 'without any job' do
    # ''
    it 'allows scheduling without any job' do
      scheduler = Scheduler.new('')
      expect(scheduler.execution_sequence).to eq([])
    end
  end

  context 'with resolvable or no dependency' do
    # a =>
    it 'allows scheduling of a single job `a =>`' do
      scheduler = Scheduler.new('a =>')
      expect(scheduler.execution_sequence).to eq(['a'])
    end

    # a =>
    # b =>
    # c =>
    it 'allows scheduling of independent jobs' do
      scheduler = Scheduler.new(
        'a =>
        b =>
        c =>'
      )
      result = scheduler.execution_sequence
      expect(result).to contain_exactly('a', 'b', 'c')
    end
  end
end
