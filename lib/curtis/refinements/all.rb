module Curtis
  module StringRefinements
    refine String do
      def relative?
        !!self[/\%\z/][0]
      end

      def relative
        gsub(/[\%\s]/, '').to_f
      end
    end
  end

  module NumericRefinements
    refine Numeric do
      def relative?
        false
      end

      # 25.percent_of(80)   #=> 20
      # 50.percent_of(1000) #=> 500
      # 110.percent_of(100) #=> 100
      def percent_of(whole_number)
        value = self > 100 ? 100 : self
        (whole_number * value * 0.01).to_i
      end
    end
  end
end
