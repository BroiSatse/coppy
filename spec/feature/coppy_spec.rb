require 'pathname'
require 'fileutils'

RSpec.describe "coppy executable" do
  root = Pathname.new(__FILE__).join('..', '..', '..').relative_path_from(Dir.pwd)

  let(:template) { @template }
  let(:target) { @target}

  before(:all) do
    @template = root.join('spec', 'template').to_s
    @target = root.join('spec', 'tmp', "app_#{Time.now.to_i}")

    system root.join('exe', 'coppy').to_s, @template.to_s, @target.to_s
  end

  after(:all) do
    FileUtils.rm_r @target.to_s
  end

  it "creates new target folder" do
    expect(target).to exist
  end

  it "does not copy ignored files" do
    expect(target.join('ignored.rb')).not_to exist
    expect(target.join('ignored.txt')).not_to exist
  end

  it "does not copy ignored folders" do
    expect(target.join('ignored_folder')).not_to exist
  end

  it "initializes new git repository and commits changes" do
    Dir.chdir(target) do
      expect(`git log`).to include "Created from template"
    end
  end
end
