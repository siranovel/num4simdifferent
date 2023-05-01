require 'ffi'
require 'ffi-compiler/loader'
require 'fiddle'

module Num4SimDiffLib
    extend FFI::Library

    ffi_lib FFI::Compiler::Loader.find('num4simdiff')

    # @overload f(x, dx)
    #   dy = f(x, dx)
    #   @yield [x, dx] dy = f(x, dx)
    #   @yieldparam [double] x xiの値
    #   @yieldparam [double] dx xiの値
    #   @return [double] xiに対するyの値
    callback   :f, [:double, :double], :double

    attach_function :eulerMethodFFI,
        :CNum4SimDiff_eulerMethod, [:buffer_in, :double, :double, :f, :f], :pointer
    attach_function :heunMethodFFI,
        :CNum4SimDiff_heunMethod, [:buffer_in, :double, :double, :f, :f], :pointer
    attach_function :rungeKuttaMethodFFI,
        :CNum4SimDiff_rungeKuttaMethod, [:buffer_in, :double, :double, :f, :f], :pointer
    class << self
        #
        # オイラー法による数値計算
        # @overload eulerMethod(yi, xi, h, func1, func2)
        #   yi_1 = eulerMethod(yi, xi, h, func1, func2)
        #   @param [double] yi xiに対するyiの値(配列)
        #   @param [double] xi xiの値
        #   @param [double] h  刻み幅
        #   @param [callback] func1 xiに対する傾きを計算する関数
        #   @param [callback] func2 xiに対する傾きを計算する関数
        #   @return [double] xi+hに対するyi_1の値(配列)
        #
        def eulerMethod(yi, xi, h, func1, func2)
          yi_ptr = cnvRbAry2pt(2, yi)
          yi_1_ptr = eulerMethodFFI(yi_ptr, xi, h, func1, func2)
          yi_1 = cnvPt2RbAry(2, yi_1_ptr)
          return 1 + yi_1[0] + 0.5 * yi_1[1]
        end
        #
        # ホイン法による数値計算
        # @overload heunMethod(yi, xi, h, func1, func2)
        #   yi_1 = heunMethod(yi, xi, h, func1, func2)
        #   @param [double] yi xiに対するyiの値(配列)
        #   @param [double] xi xiの値
        #   @param [double] h  刻み幅
        #   @param [callback] func1 xiに対する傾きを計算する関数
        #   @param [callback] func2 xiに対する傾きを計算する関数
        #   @return [double] xi+hに対するyi_1の値(配列)
        #
        def heunMethod(yi, xi, h, func1, func2)
          yi_ptr = cnvRbAry2pt(2, yi)
          yi_1_ptr = heunMethodFFI(yi_ptr, xi, h, func1, func2)
          yi_1 = cnvPt2RbAry(2, yi_1_ptr)
          return 1 + yi_1[0] + 0.5 * yi_1[1] 
        end
        #
        # 4次のルンゲ＝クッタ法による数値計算
        # @overload  rungeKuttaMethod(yi, xi, h, func1, func2)
        #   yi_1 = rungeKuttaMethod(yi, xi, h, func1, func2)
        #   @param [double] yi xiに対するyiの値(配列)
        #   @param [double] xi xiの値
        #   @param [double] h  刻み幅
        #   @param [callback] func1 xiに対する傾きを計算する関数
        #   @param [callback] func2 xiに対する傾きを計算する関数
        #   @return [double] xi+hに対するyi_1の値(配列)
        #
        def rungeKuttaMethod(yi, x, h, func1, func2)
          yi_ptr = cnvRbAry2pt(2, yi)
          yi_1_ptr = rungeKuttaMethodFFI(yi_ptr, x, h, func1, func2)
          yi_1 = cnvPt2RbAry(2, yi_1_ptr)
          return 1 + yi_1[0] + 0.5 * yi_1[1]
        end

        #
        # @private
        #
        def cnvRbAry2pt(n, ary)
            yi_ptr = FFI::MemoryPointer.new(:double, n)
            n.times.map { |i|
                yi_ptr.put_double(i * Fiddle::SIZEOF_DOUBLE, ary[i].to_f)
            }
            return yi_ptr   
        end
        #
        # @private
        #
        def cnvPt2RbAry(n, pt)
          rbAry = n.times.map { |i|
             pt.get_double(i * Fiddle::SIZEOF_DOUBLE)
          }
          return rbAry  
        end
        private :eulerMethodFFI
        private :heunMethodFFI
        private :rungeKuttaMethodFFI
        private :cnvRbAry2pt
        private :cnvPt2RbAry
    end
end
