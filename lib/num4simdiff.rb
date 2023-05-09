require 'ffi'
require 'ffi-compiler/loader'
require 'fiddle'

module Num4SimDiffLib
    extend FFI::Library

    ffi_lib FFI::Compiler::Loader.find('num4simdiff')
    attach_function :eulerMethodFFI,
        :CNum4SimDiff_eulerMethod, [:int, :buffer_in, :double, :buffer_in], :pointer
    attach_function :heunMethodFFI,
        :CNum4SimDiff_heunMethod, [:int, :buffer_in, :double,  :buffer_in], :pointer
    attach_function :rungeKuttaMethodFFI,
        :CNum4SimDiff_rungeKuttaMethod, [:int, :buffer_in, :double, :buffer_in], :pointer
    class << self
        #
        # オイラー法による数値計算
        # @overload eulerMethod(yi, h, func)
        #   yi_1 = eulerMethod(yi, h, func)
        #   @param [double[]] yi xiに対するyiの値(配列)
        #   @param [double] h  刻み幅
        #   @param [callback] func xiに対する傾きを計算する関数
        #   @return [double[]] xi+hに対するyi_1の値(配列)
        # @example
        #   func = Proc.new do | n, yi |
        #     f = []
        #     f[0] = yi[0]
        #     f[1] = yi[1]
        #     next f
        #   end
        #   yi = [1.0, 1.0] 
        #   yi_1 =  Num4SimDiffLib.eulerMethod(yi, 0.001, func)
        #
        def eulerMethod(yi, h, func)
          n = yi.size
          f = func.call(n, yi)
          f_ptr = cnvRbAry2pt(n, f)
          yi_ptr = cnvRbAry2pt(n, yi)
          yi_1_ptr = eulerMethodFFI(n, yi_ptr, h, f_ptr)
          yi_1 = cnvPt2RbAry(n, yi_1_ptr)
          f_ptr.free()
          return yi_1
        end
        #
        # ホイン法による数値計算
        # @overload heunMethod(yi, h, func)
        #   yi_1 = heunMethod(yi, h, func)
        #   @param [double[]] yi xiに対するyiの値(配列)
        #   @param [double] h  刻み幅
        #   @param [callback] func xiに対する傾きを計算する関数
        #   @return [double[]] xi+hに対するyi_1の値(配列)
        # @example
        #   func = Proc.new do | n, yi |
        #     f = []
        #     f[0] = yi[0]
        #     f[1] = yi[1]
        #     next f
        #   end
        #   yi = [1.0, 1.0] 
        #   yi_1 =  Num4SimDiffLib.heunMethod(yi, 0.001, func)
        #
        def heunMethod(yi, h, func)
          n = yi.size
          f = func.call(n, yi)
          f_ptr = cnvRbAry2pt(n, f)
          yi_ptr = cnvRbAry2pt(n, yi)
          yi_1_ptr = heunMethodFFI(n, yi_ptr, h, f_ptr)
          yi_1 = cnvPt2RbAry(n, yi_1_ptr)
          f_ptr.free()
          return yi_1
        end
        #
        # 4次のルンゲ＝クッタ法による数値計算
        # @overload  rungeKuttaMethod(yi, h, func)
        #   yi_1 = rungeKuttaMethod(yi, h, func)
        #   @param [double[]] yi xiに対するyiの値(配列)
        #   @param [double] h  刻み幅
        #   @param [callback] func xiに対する傾きを計算する関数
        #   @return [double[]] xi+hに対するyi_1の値(配列)
        # @example
        #   func = Proc.new do | n, yi |
        #     f = []
        #     f[0] = yi[0]
        #     f[1] = yi[1]
        #     next f
        #   end
        #   yi = [1.0, 1.0] 
        #   yi_1 =  Num4SimDiffLib.rungeKuttaMethod(yi, 0.001, func)
        #
        def rungeKuttaMethod(yi, h, func)
          n = yi.size
          f = func.call(n, yi)
          f_ptr = cnvRbAry2pt(n, f)
          yi_ptr = cnvRbAry2pt(n, yi)
          yi_1_ptr = rungeKuttaMethodFFI(n, yi_ptr, h, f_ptr)
          yi_1 = cnvPt2RbAry(n, yi_1_ptr)
          f_ptr.free()
          return yi_1
        end

        #
        # @private
        def cnvRbAry2pt(n, ary)
            yi_ptr = FFI::MemoryPointer.new(:double, n)
            n.times.map { |i|
                yi_ptr.put_double(i * Fiddle::SIZEOF_DOUBLE, ary[i].to_f)
            }
            return yi_ptr   
        end
        #
        # @private
        def cnvPt2RbAry(n, pt)
          rbAry = n.times.map { |i|
             pt.get_double(i * Fiddle::SIZEOF_DOUBLE)
          }
          return rbAry  
        end
        private :cnvRbAry2pt
        private :cnvPt2RbAry
        private :eulerMethodFFI
        private :heunMethodFFI
        private :rungeKuttaMethodFFI
    end
end
