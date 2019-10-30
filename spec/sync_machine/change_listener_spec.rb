require 'spec_helper'

RSpec.describe SyncMachine::ChangeListener do
  before do
    TestSync::FindSubjectsWorker.clear
  end

  it "enqueues a FindSubjectsWorker when a model is created" do
    test_sync_subject = Customer.create!
    expect(TestSync::FindSubjectsWorker.jobs.count).to eq(1)
    args = TestSync::FindSubjectsWorker.jobs.first['args']
    expect(args.size).to eq(4)
    expect(args[0]).to eq('Customer')
    expect(args[1]).to eq(test_sync_subject.id)
    expect(args[2]).to eq(['id'])
    expect(Time.parse(args[3])).to be_within(1).of(Time.now)
  end

  it "includes changed keys on an update" do
    test_sync_subject = Customer.create!
    TestSync::FindSubjectsWorker.clear
    expect(TestSync::FindSubjectsWorker.jobs.count).to eq(0)
    test_sync_subject.name = "new name"
    test_sync_subject.save!
    expect(TestSync::FindSubjectsWorker.jobs.count).to eq(1)
    args = TestSync::FindSubjectsWorker.jobs.first['args']
    expect(args.size).to eq(4)
    expect(args[0]).to eq('Customer')
    expect(args[1]).to eq(test_sync_subject.id)
    expect(args[2]).to eq(['name'])
    expect(Time.parse(args[3])).to be_within(1).of(Time.now)
  end
end
