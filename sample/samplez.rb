require 'num4simdiff'

class Num4SimDiffTest
    def initialize
        @a = 1.0
        @h = 0.001
        @y0 = [1.0, 1.0] 
        @e = Math.exp(@a)
        @func1 = Proc.new do | x, dx |
          next 1 + @a * x
        end
        @func2 = Proc.new do | x, dx |
          next 1 + x
        end
    end
    #
    # オイラー法のテスト
    def eulerMethodTest
        @yi = [1.0, 1.0]
        yi_1 = 0.0
        0.step(1, @h) { |x|
            yi_1 =  Num4SimDiffLib.eulerMethod(@yi, x, @h, @func1, @func2)
            yi = yi_1
        }
        print "exp(", @a, "):", @e
        print " "
        print "1.0:", yi_1             # yi_1 = 2.504002
        puts
    end
    #
    # ホイン法のテスト
    def heunMethodTest
        @yi = [1.0, 1.0]
        yi_1 = 0.0
        0.step(1, @h) { |x|
            yi_1 =  Num4SimDiffLib.heunMethod(@yi, x, @h, @func1, @func2)
            yi = yi_1
        }
        print "exp(", @a, "):", @e
        print " "
        print "1.0:", yi_1             # yi_1 = 2.5030031265005004
        puts
    end
    #
    # 4次のルンゲクッタ法のテスト
    def rungeKuttaMethodtest
        @yi = [1.0, 1.0]
        yi_1 = 0.0
        0.step(1, @h) { |x|
            yi_1 =  Num4SimDiffLib.rungeKuttaMethod(@yi, x, @h, @func1, @func2)
            yi = yi_1
        }
        print "exp(", @a, "):", @e
        print " "
        print "1.0:", yi_1             # yi_1 = 2.5023353485006807
        puts
    end
end
tst = Num4SimDiffTest.new
tst.eulerMethodTest()
tst.heunMethodTest()
tst.rungeKuttaMethodtest()
