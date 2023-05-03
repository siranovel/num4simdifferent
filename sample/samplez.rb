require 'num4simdiff'

class Num4SimDiffTest
    def initialize
        @a = 1.0
        @h = 0.001
        @y0 = [1.0, 1.0] 
        @e = Math.exp(@a)
        @funcDmy = Proc.new do | n, yi_ptr |
          f = []
          yi = Num4SimDiffLib.cnvPt2RbAry(n, yi_ptr)
          f[0] = yi[0]
          f[1] = yi[1]
          next Num4SimDiffLib.cnvRbAry2pt(n, f)
        end
        @func = Proc.new do | n, yi_ptr |
          f = []
          yi = Num4SimDiffLib.cnvPt2RbAry(n, yi_ptr)
          f[0] = yi[0]
          f[1] = yi[1]
          next Num4SimDiffLib.cnvRbAry2pt(n, f)
        end
    end
    def dmyTest
        yi = @y0
        yi_1 = Num4SimDiffLib.dmy(yi, @h, @funcDmy)
        print yi_1[0]
        puts 
    end
    #
    # オイラー法のテスト
    def eulerMethodTest
        yi = @y0
        yi_1 = []
        0.step(1, @h) { |x|
            yi_1 =  Num4SimDiffLib.eulerMethod(yi, @h, @func)
            yi = yi_1
        }
        print "exp(", @a, "):", @e
        print " "
        print "1.0:", yi_1[0], ",", yi_1[1]      # yi_1[0] = 2.719640856168132
        puts
    end
    #
    # ホイン法のテスト
    def heunMethodTest
        yi = @y0
        yi_1 = []
        0.step(1, @h) { |x|
            yi_1 =  Num4SimDiffLib.heunMethod(yi, @h, @func)
            yi = yi_1
        }
        print "exp(", @a, "):", @e
        print " "
        print "1.0:", yi_1[0], ",", yi_1[1]      # yi_1[0] = 2.7210010162682026
        puts
    end
    #
    # 4次のルンゲクッタ法のテスト
    def rungeKuttaMethodtest
        yi = @y0
        yi_1 = []
        0.step(1, @h) { |x|
            yi_1 =  Num4SimDiffLib.rungeKuttaMethod(yi, @h, @func)
            yi = yi_1
        }
        print "exp(", @a, "):", @e
        print " "
        print "1.0:", yi_1[0], ",", yi_1[1]      # yi_1[0] = 2.7210014698815583
        puts
    end
end
# 1.0
# exp(1.0):2.718281828459045 1.0:2.719640856168132,2.719640856168132
# exp(1.0):2.718281828459045 1.0:2.7210010162682026,2.7210010162682026
# exp(1.0):2.718281828459045 1.0:2.7210014698815583,2.7210014698815583
tst = Num4SimDiffTest.new
tst.dmyTest()
tst.eulerMethodTest()
tst.heunMethodTest()
tst.rungeKuttaMethodtest()
