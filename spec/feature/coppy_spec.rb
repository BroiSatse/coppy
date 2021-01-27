require 'pathname'
require 'fileutils'

RSpec.describe "coppy executable" do
  root = Pathname.new(__FILE__).join('..', '..', '..').relative_path_from(Dir.pwd)

  let(:template) { @template }
  let(:target) { @target}
  let(:timestamp) { @timestamp }

  before(:all) do
    @timestamp = Time.now.to_i
    @template = root.join('spec', 'template').to_s
    @target = root.join('spec', 'tmp', "app_#{@timestamp}")

    result = system root.join('exe', 'coppy').to_s, @template.to_s, @target.to_s
    raise "Command failed to execute" unless result
  end

  after(:all) do
    FileUtils.rm_r @target.to_s
  end

  it "does not copy ignored files" do
    expect(target.join('ignored.rb')).not_to exist
    expect(target.join('ignored.txt')).not_to exist
  end

  it "does not copy ignored folders" do
    expect(target.join('ignored_folder')).not_to exist
  end

  it "initializes new git repository and commits changes" do
    expect(target.join('.git')).to exist
    Dir.chdir(target) do
      expect(`git log`).to include "Created from template"
    end
  end

  it "replaces content of specified files" do
    expect(File.read(target.join('file.rb'))).to include "class App#{timestamp}"
  end
end
