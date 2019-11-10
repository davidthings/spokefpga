
prj_project new -name "add_sat" -lpf "../projects/add_sat/add_sat.lpf" -impl "impl1" -dev LFE5UM5G-85F-8BG381C -synthesis "lse"

prj_src add "../rtl/add_sat.v"

prj_impl option top "add_sat"

prj_project save


