require 'ffi'
require 'ffi-compiler/loader'
require 'fiddle'

module Num4SimDiffLib
    extend FFI::Library

    ffi_lib FFI::Compiler::Loader.find('num4simdiff')

    # @overload f(n, yn)
    #   dy = f(n, yn)
    #   @yield [n, yn] dy = f(n, yn)
    #   @yieldparam [int] n ynの個数
    #   @yieldparam [pointer] yn FFI::Pointer
    #   @return [pointer] xiに対するyの値(FFI::Pointer)
    callback   :f, [:int, :pointer], :pointer

    attach_function :dmyFFI,
        :CNum4SimDiff_dmy, [:int, :buffer_in, :double, :f], :pointer
    attach_function :eulerMethodFFI,
        :CNum4SimDiff_eulerMethod, [:int, :buffer_in, :double, :f], :pointer
    attach_function :heunMethodFFI,
        :CNum4SimDiff_heunMethod, [:int, :buffer_in, :double,  :f], :pointer
    attach_function :rungeKuttaMethodFFI,
        :CNum4SimDiff_rungeKuttaMethod, [:int, :buffer_in, :double, :f], :pointer
    class << self
        # @private
        def dmy(yi, h, func)
          n = yi.size
          yi_ptr = cnvRbAry2pt(n, yi)
          yi_1_ptr = dmyFFI(n, yi_ptr, h, func)
          yi_1 = cnvPt2RbAry(n, yi_1_ptr)
        end
        #
        # オイラー法による数値計算
        # @overload eulerMethod(yi, h, func)
        #   yi_1 = eulerMethod(yi, h, func)
        #   @param [double[]] yi xiに対するyiの値(配列)
        #   @param [double] h  刻み幅
        #   @param [callback] func xiに対する傾きを計算する関数
        #   @return [double[]] xi+hに対するyi_1の値(配列)
        #
        def eulerMethod(yi, h, func)
          n = yi.size
          yi_ptr = cnvRbAry2pt(n, yi)
          yi_1_ptr = eulerMethodFFI(n, yi_ptr, h, func)
          yi_1 = cnvPt2RbAry(n, yi_1_ptr)
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
        #
        def heunMethod(yi, h, func)
          n = yi.size
          yi_ptr = cnvRbAry2pt(n, yi)
          yi_1_ptr = heunMethodFFI(n, yi_ptr, h, func)
          yi_1 = cnvPt2RbAry(n, yi_1_ptr)
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
        #
        def rungeKuttaMethod(yi, h, func)
          n = yi.size
          yi_ptr = cnvRbAry2pt(n, yi)
          yi_1_ptr = rungeKuttaMethodFFI(n, yi_ptr, h, func)
          yi_1 = cnvPt2RbAry(n, yi_1_ptr)
          return yi_1
        end

        #
        # ruby配列からFFI::Pointer型に変換
        # @overload  cnvRbAry2pt(n, ary)
        # @param [int] n 配列の個数
        # @param [double[]] ary yiの値(配列)
        # @return [pointer] FFI::Pointer
        def cnvRbAry2pt(n, ary)
            yi_ptr = FFI::MemoryPointer.new(:double, n)
            n.times.map { |i|
                yi_ptr.put_double(i * Fiddle::SIZEOF_DOUBLE, ary[i].to_f)
            }
            return yi_ptr   
        end
        #
        # FFI::Pointer型からruby配列に変換
        # @overload  cnvPt2RbAry(n, pt)
        # @param [int] n 配列の個数
        # @param [pointer] pt FFI::Pointer
        # @return [double[]] yiの値(配列)
        def cnvPt2RbAry(n, pt)
          rbAry = n.times.map { |i|
             pt.get_double(i * Fiddle::SIZEOF_DOUBLE)
          }
          return rbAry  
        end
        private :eulerMethodFFI
        private :heunMethodFFI
        private :rungeKuttaMethodFFI
    end
end
