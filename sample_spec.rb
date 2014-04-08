require 'matrix_formatter'

implementors = ['LegacyWidget', 'HTML5Widget']
RSpec.configure do |config|
  config.matrix_implementors = ['LegacyWidget', 'HTML5Widget']
  # config.matrix_options = { :layout => nil }
end

describe 'MVP Features', :markdown =>
"""
You can use [Markdown](http://daringfireball.net/projects/markdown/) produce extra documentation
on the feature matrix.
""" do
  describe 'creates a thing', :link => "https://github.com/maxlinc/matrix_formatter", :markdown =>
  """
  Yes, it works here as well.
  """ do
    implementors.each do |implementor|
      it implementor do
        fail if implementor.eql? implementors.first
      end
    end
  end
  describe 'saves a thing', :link => "http://www.google.com", :markdown =>
  """
  Hello again!
  """ do
    implementors.each do |implementor|
      it implementor do
        fail unless implementor.eql? implementors.first
      end
    end
  end
end

describe 'Cool Features' do
  describe 'renders a nyan cat video' do
    implementors.each do |implementor|
      it implementor do
        fail if implementor.eql? implementors.first
      end
    end
  end
  describe 'does a headstand' do
    implementors.each do |implementor|
      it implementor do
        fail unless implementor.eql? implementors.first
      end
    end
  end
  describe 'reads your mind' do
    implementors.each do |implementor|
      skip implementor
    end
  end
end

