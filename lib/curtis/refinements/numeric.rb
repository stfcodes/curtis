module Curtis
  module NumericRefinements
    refine Numeric do
      # 80.percent(25)    #=> 20
      # 100.percent(50)   #=> 50
      # 100.percent(100)  #=> 100
      def percent(relative)
        (self * relative / 100.0).to_i
      end
    end
  end
end
