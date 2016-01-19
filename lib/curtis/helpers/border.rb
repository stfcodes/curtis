module Curtis
  module Helpers
    module Border
      def box(ns: 0, we: 0)
        super ns.ord, we.ord
      end

      def border(n: 0, ne: 0, e: 0, se: 0, s: 0, sw: 0, w: 0, nw: 0)
        borders = [w, e, n, s, nw, ne, sw, se].map(&:ord)
        super *borders
      end
    end
  end
end
