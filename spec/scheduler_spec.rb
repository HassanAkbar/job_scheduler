require_relative '../lib/scheduler'

describe "#execution_sequence" do
  context 'without any job' do
    # ''
    it 'allows scheduling without any job' do
      scheduler = Scheduler.new('')
      expect(scheduler.execution_sequence).to eq([])
    end
  end
end
