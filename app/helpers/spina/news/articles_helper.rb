module Spina
  module News
    module ArticlesHelper
      def formatted_date(year, month)
        if month
          date = Date.new year.to_i, month.to_i
          return date.strftime("%B %Y")
        else
          date = Date.new year.to_i
          return date.strftime("%Y")
        end
      end
    end
  end
end
