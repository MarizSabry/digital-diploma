set FH [open rtl.txt r+]
set designs [list [read $FH]]
regsub -all {\n[\n]*} $designs " " designs
puts $designs
close $FH