require 'pathname'

RSpec.describe "coppy executable" do
  root = Pathname.new(__FILE__).join('..', '..', '..').relative_path_from(Dir.pwd)

  let(:template) { root.join('spec', 'template').to_s }
  let(:target) { root.join('spec', 'tmp', "app_#{Time.now.to_i}") }

  before do
    system root.join('exe', 'coppy').to_s, template.to_s, target.to_s
  end

  it "creates new target folder" do
    expect(target).to exist
  end

  it "does not copy ignored files" do
    expect(target.join('ignored.rb')).not_to exist
    expect(target.join('ignored.txt')).not_to exist
  end
end
