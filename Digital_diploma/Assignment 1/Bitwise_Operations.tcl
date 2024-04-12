puts "****Bitwise Operations****"
set a 20
set b 5
set c 9
set var0 [expr $a & $c]
set var1 [expr $a | $b]
set var2 [expr $a ^ $a]
puts "The result of bitwise AND between a and c is $var0"
puts "The result of bitwise OR between a and b is $var1"
puts "The result of bitwise XOR between a and a is $var2"
