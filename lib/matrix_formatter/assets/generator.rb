require 'sprockets'
require 'fileutils'

module MatrixFormatter
  module Assets
    class Generator
      def initialize(options = {})
        @options = options
        @sprocket_options = options[:sprocket_options] || {:minify => false}
      end

      def environment
        @environment ||= setup_environment
      end

      def generate(files = %w{dashboard.js dashboard.css})
        files.each do |file|
          environment[file].write_to "docs/resources/#{file}"
        end

        # Copy bootstrap fonts and icons
        FileUtils.mkdir_p "docs/fonts/"
        FileUtils.cp_r vendor_path('bootstrap/dist/fonts/'), "docs/"
      end

      private

      def setup_environment
        @environment = Sprockets::Environment.new
        @environment.append_path resource_path('css')
        @environment.append_path resource_path('javascript')
        extra_resource_paths = @options[:extra_resource_paths] || []
        extra_vendor_paths = @options[:extra_vendor_paths] || []
        extra_resource_paths.each do |path|
          @environment.append_path resource_path(path)
        end
        extra_vendor_paths.each do |path|
          @environment.append_path vendor_path(path)
        end
        # FIXME: Not sure Bower integration will work as well as I hoped
        @environment.append_path vendor_path('sizzle/dist')
        @environment.append_path vendor_path('jquery/dist')
        @environment.append_path vendor_path('bootstrap/dist/js')
        @environment.append_path vendor_path('bootstrap/dist/css')
        # environment.append_path vendor_path('bootstrap/dist/fonts')

        if @sprocket_options[:minify]
          @environment.js_compressor  = :uglify
          @environment.css_compressor = :scss
        end
        @environment
      end

      def resource_path name
        File.join(File.dirname(File.expand_path(__FILE__)), '../../../resources/html5', name)
      end

      def vendor_path name
        File.join(File.dirname(File.expand_path(__FILE__)), '../../../resources/vendor', name)
      end
    end
  end
end