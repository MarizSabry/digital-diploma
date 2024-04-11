puts "****Logical Operations****"
set a 5
set b -1
set c 0
set var0 [expr $a && $c]
set var1 [expr $a || $b]
puts "The result of logical AND between a and c is $var0"
puts "The result of logical OR between a and b is $var1"