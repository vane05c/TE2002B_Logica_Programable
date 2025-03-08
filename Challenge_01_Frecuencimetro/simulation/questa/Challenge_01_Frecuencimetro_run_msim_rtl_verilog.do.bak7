transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Documents/Tec/Profesional/4to\ Semestre/TE2002B\ Diseno\ con\ logica\ programable/Labs/Challenge_01_Frecuencimetro {D:/Documents/Tec/Profesional/4to Semestre/TE2002B Diseno con logica programable/Labs/Challenge_01_Frecuencimetro/frecuencimetro.v}
vlog -vlog01compat -work work +incdir+D:/Documents/Tec/Profesional/4to\ Semestre/TE2002B\ Diseno\ con\ logica\ programable/Labs/Challenge_01_Frecuencimetro {D:/Documents/Tec/Profesional/4to Semestre/TE2002B Diseno con logica programable/Labs/Challenge_01_Frecuencimetro/disp.v}
vlog -vlog01compat -work work +incdir+D:/Documents/Tec/Profesional/4to\ Semestre/TE2002B\ Diseno\ con\ logica\ programable/Labs/Challenge_01_Frecuencimetro {D:/Documents/Tec/Profesional/4to Semestre/TE2002B Diseno con logica programable/Labs/Challenge_01_Frecuencimetro/counterFm.v}
vlog -vlog01compat -work work +incdir+D:/Documents/Tec/Profesional/4to\ Semestre/TE2002B\ Diseno\ con\ logica\ programable/Labs/Challenge_01_Frecuencimetro {D:/Documents/Tec/Profesional/4to Semestre/TE2002B Diseno con logica programable/Labs/Challenge_01_Frecuencimetro/bcdFm.v}

vlog -sv -work work +incdir+D:/Documents/Tec/Profesional/4to\ Semestre/TE2002B\ Diseno\ con\ logica\ programable/Labs/Challenge_01_Frecuencimetro {D:/Documents/Tec/Profesional/4to Semestre/TE2002B Diseno con logica programable/Labs/Challenge_01_Frecuencimetro/frecuencimetro_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  frecuencimetro_tb

add wave *
view structure
view signals
run -all
