# MatrixFormatter

Generates a Feature Matrix from specs following a certain pattern.

Given tests like these:
```ruby
require 'matrix_formatter'

implementors = ['LegacyWidget', 'HTML5Widget']
RSpec.configure do |config|
  config.matrix_implementors = ['LegacyWidget', 'HTML5Widget']
end

describe 'MVP Features' do
  implementors.each do |implementor|
    context implementor do
      it 'creates a thing' do
        fail if implementor.eql? implementors.first
      end
      it 'saves a thing' do
        fail unless implementor.eql? implementors.first
      end
    end
  end
end

describe 'Cool Features' do
  implementors.each do |implementor|
    context implementor do
      it 'renders a nyan cat video' do
        fail if implementor.eql? implementors.first
      end
      it 'does a headstand' do
        fail unless implementor.eql? implementors.first
      end
      pending 'reads your mind'
    end
  end
end
```

It will produce output like this:
![Preview](//raw.github.com/maxlinc/matrix_formatter/master/sample_html.png)

## Installation

Add this line to your application's Gemfile:

    gem 'matrix_formatter'

And then execute:

    $ bundle

## Usage

Together with the documentation formatter:

`rspec sample_spec.rb --format documentation --format MatrixFormatter::Formatters::HTMLFormatter --out matrix.html`

or via .rspec:
```rb
--format documentation
--format MatrixFormatter::Formatters::HTMLFormatter
--out matrix.html
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
