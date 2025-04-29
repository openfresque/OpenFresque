module OpenFresk
  module CoreExtensions
    module String
      def capitalize_with_dash
        capitalize.gsub(/-[a-z]/) { |s| s.upcase }
      end

      def titleize_with_dashes
        humanize.gsub(/\b('?[a-z])/) { |s| s.capitalize }
      end
    end
  end
end