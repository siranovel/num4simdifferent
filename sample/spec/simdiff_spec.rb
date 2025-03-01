require 'spec_helper'
require 'num4simdiff'

RSpec.describe Num4SimDiffLib do
    before do
        @h = 0.001
        @y0 = [1.0, 1.0] 
        @func = Proc.new do | n, yi |
          f = []
          f[0] = yi[0]
          f[1] = yi[1]
          next f
        end
    end
    it '#eulerMethod' do
        yi = @y0
        yi_1 = []
        0.step(1, @h) { |x|
            yi_1 =  Num4SimDiffLib.eulerMethod(yi, @h, @func)
            yi = yi_1
        }
        res = [2.7196, 2.7196]
        expect(
            yi_1
        ).to is_rounds(res, 4)
    end
    it '#heunMethod' do
        yi = @y0
        yi_1 = []
        0.step(1, @h) { |x|
            yi_1 =  Num4SimDiffLib.heunMethod(yi, @h, @func)
            yi = yi_1
        }
        res = [2.7210, 2.7210]
        expect(
            yi_1
        ).to is_rounds(res, 4)
    end
    it '#rungeKuttaMethod' do
        yi = @y0
        yi_1 = []
        0.step(1, @h) { |x|
            yi_1 =  Num4SimDiffLib.rungeKuttaMethod(yi, @h, @func)
            yi = yi_1
        }
        res = [2.7210, 2.7210]
        expect(
            yi_1
        ).to is_rounds(res, 4)
    end
end

