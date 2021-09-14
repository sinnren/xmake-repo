package("xsimd")

    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/xtensor-stack/xsimd/")
    set_description("C++ wrappers for SIMD intrinsics")
    set_license("BSD-3-Clause")

    add_urls("https://github.com/xtensor-stack/xsimd/archive/refs/tags/$(version).tar.gz")
    add_versions("7.6.0", "eaf47f1a316ef6c3287b266161eeafc5aa61226ce5ac6c13502546435b790252")

    if is_plat("windows") then
        add_cxxflags("/arch:AVX")
    else
        add_cxxflags("-march=native")
    end

    add_deps("cmake")
    on_install("windows", "macosx", "linux", "mingw@windows", function (package)
        import("package.tools.cmake").install(package)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <iostream>
            void test() {
                xsimd::batch<double, 4> a(1.5, 2.5, 3.5, 4.5);
                xsimd::batch<double, 4> b(2.5, 3.5, 4.5, 5.5);
                auto mean = (a + b) / 2;
                std::cout << mean << std::endl;
            }
        ]]}, {configs = {languages = "c++14"}, includes = "xsimd/xsimd.hpp"}))
    end)