puts "*** Reporting Files types & change files paths ***"
array set Files {}
set Files(uart_tx_top.v) /users/alieltemsah/projects/rtl
set Files(Serializer.v) /users/alieltemsah/projects/rtl
set Files(fsm_ctrl.v) /users/alieltemsah/projects/rtl
set Files(synth.tcl) /users/alieltemsah/projects/scripts
set Files(timing.rpt) /users/alieltemsah/projects/reports
set Files(power.rpt) /users/alieltemsah/projects/reports
set Files(area.rpt) /users/alieltemsah/projects/reports

set Array_keys [array names Files]

proc pfiletype {Arg} {
foreach i $Arg {
if {[string match -nocase *.v $i]==1} {
puts "$i is Verilog file"
} elseif {[string match -nocase *.tcl $i]==1} {
puts "$i is TCL file"
} elseif {[string match -nocase *.rpt $i]==1} {
puts "$i is report file"
}
}
}

pfiletype $Array_keys

set values_new ""
foreach x $Array_keys {
set value $Files($x)
regsub -nocase "alieltemsah" $value "MarizSabry" value
set Files($x) $value
lappend values_new \n$value
}
puts $values_new
array get Files
