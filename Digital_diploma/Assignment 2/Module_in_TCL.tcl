puts "***Writing Verilog Block Interface***"
set modname { Up_Dn_Counter}
set in_ports [list IN Load Up Down CLK]
set in_ports_width [list 4 1 1 1 1]
set out_ports [list High Counter Low]
set out_ports_width [list 1 4 1]
set length_in [llength $in_ports]
set length_out [llength $out_ports]

puts "module $modname ("

for {set i 0} {$i <= [expr $length_in - 1 ]} {incr i} {
if {[lindex $in_ports_width $i] == 1} {

puts "input           [lindex $in_ports $i],"

} else {

set width [lindex $in_ports_width $i]
set A_i [lindex $in_ports $i]
puts "input   \[[expr $width -1]:0]   $A_i,"

}
}

for {set x 0} {$x < [expr $length_out - 1 ]} {incr x} {


if {[lindex $out_ports_width $x] == 1} {

puts "output          [lindex $out_ports $x],"

} else {

set width_out [lindex $out_ports_width $x]
set A_x [lindex $out_ports $x]
puts "output   \[[expr $width_out -1]:0]  $A_x,"

} 
}

for {set y [expr $length_out - 1]} {$y == [expr $length_out - 1 ]} {incr y} {


if {[lindex $out_ports_width $y] == 1} {

puts "output          [lindex $out_ports $y]"

} else {

set width_out1 [lindex $out_ports_width $y]
set A_y [lindex $out_ports $y]
puts "output   \[[expr $width_out1 -1]:0]  $A_y"

} 
}

puts ");"


