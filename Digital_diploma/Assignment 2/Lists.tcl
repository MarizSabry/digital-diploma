puts "****Assignment 2.0****"
set cities [list cairo alexandria damietta dakahlia faiyum sohag aswan]

foreach city $cities {
set City [string toupper $city 0]
lappend Cities_New $City
}
puts "$Cities_New"
