require 'fileutils'

describe 'reports' do
  before(:all) do
    FileUtils.rm_rf 'results'
    FileUtils.mkdir 'results'
  end

  formatters = {
    'json' => { :class => 'MatrixFormatter::Formatters::JSONFormatter', :filename => 'matrix.json' },
    'markdown' => { :class => 'MatrixFormatter::Formatters::MarkdownFormatter', :filename => 'matrix.md' },
    'html' => { :class => 'MatrixFormatter::Formatters::HTMLFormatter', :filename => 'matrix.html' },
    'html5' => { :class => 'MatrixFormatter::Formatters::HTML5Formatter', :filename => 'html5_matrix.html' }
  }
  formatters.each do |formatter_name, formatter|
    clazz = formatter[:class]
    filename = formatter[:filename]
    context formatter_name do
      it formatter do
        `bundle exec rspec sample_spec.rb -f #{clazz} -o results/#{filename}`
        fixture_content = File.read "fixtures/#{filename}"
        generated_content = File.read "results/#{filename}"
        expect(fixture_content).to eq(generated_content)
      end
    end
  end
end
