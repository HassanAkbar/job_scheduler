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

    # a =>
    # b => c
    # c =>
    it 'allows scheduling of two independent and one dependent jobs' do
      scheduler = Scheduler.new(
        'a =>
        b => c
        c =>'
      )
      result = scheduler.execution_sequence
      expect(result).to contain_exactly('a', 'b', 'c')
      expect(result.find_index('c')).to be < result.find_index('b')
    end

    # a =>
    # b => c
    # c => f
    # d => a
    # e => b
    # f =>
    it 'allows scheduling of independent and 4th-level dependent jobs' do
      scheduler = Scheduler.new(
        'a =>
        b => c
        c => f
        d => a
        e => b
        f =>'
      )
      result = scheduler.execution_sequence
      expect(result).to contain_exactly('a', 'b', 'c', 'd', 'e', 'f')
      expect(result.find_index('c')).to be < result.find_index('b')
      expect(result.find_index('f')).to be < result.find_index('c')
      expect(result.find_index('a')).to be < result.find_index('d')
      expect(result.find_index('b')).to be < result.find_index('e')
    end
  end
end
