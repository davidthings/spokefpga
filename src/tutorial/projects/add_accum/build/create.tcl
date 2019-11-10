prj_project new -name "add_accum" -lpf "../projects/add_accum/add_accum.lpf" -impl "impl1" -dev LFE5UM5G-85F-8BG381C -synthesis "lse"

prj_src add "../rtl/add_accum.v"

prj_impl option top "add_accum"

prj_project save


