transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Documents/Tec/Profesional/4to\ Semestre/TE2002B\ Diseno\ con\ logica\ programable/Labs/04_Password {D:/Documents/Tec/Profesional/4to Semestre/TE2002B Diseno con logica programable/Labs/04_Password/pwFSM.v}
vlog -vlog01compat -work work +incdir+D:/Documents/Tec/Profesional/4to\ Semestre/TE2002B\ Diseno\ con\ logica\ programable/Labs/04_Password {D:/Documents/Tec/Profesional/4to Semestre/TE2002B Diseno con logica programable/Labs/04_Password/password.v}
vlog -vlog01compat -work work +incdir+D:/Documents/Tec/Profesional/4to\ Semestre/TE2002B\ Diseno\ con\ logica\ programable/Labs/04_Password {D:/Documents/Tec/Profesional/4to Semestre/TE2002B Diseno con logica programable/Labs/04_Password/one_shot.v}

vlog -sv -work work +incdir+D:/Documents/Tec/Profesional/4to\ Semestre/TE2002B\ Diseno\ con\ logica\ programable/Labs/04_Password {D:/Documents/Tec/Profesional/4to Semestre/TE2002B Diseno con logica programable/Labs/04_Password/password_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  password_tb

add wave *
view structure
view signals
run -all
