#upcase chars/ensure the object is of a string type for the upcase
#the unary operator + returns a mutable string if the original is frozen(ARGV)
vin         = +ARGV[0]
upcased_vin = vin.to_s.upcase

#checksum algorithm data constants
#on the original script the number 8 was not in place on the checksum map
#the checksum map plus the transliteration takes care of the 10 to 'X' substitution situation
#because of that there is no check for this on the code
CHECKSUM_MAP           = [0,1,2,3,4,5,6,7,8,9,10,'X'] 
CHECKSUM_WEIGHTS       = [8,7,6,5,4,3,2,10,0,9,8,7,6,5,4,3,2]
TRANSLITERATION_STRING = '0123456789.ABCDEFGH..JKLMN.P.R..STUVWXYZ'

# I like to have a 'prime'execute method that will emcompass all the steps for the execution of the script
#I find it easier to understand what the code is doing without having to look at each method
def execute(upcased_vin, vin)
  check_digit = calculate_check_digit(upcased_vin)
  status      = vin[8].to_i == check_digit ? 'VALID' : 'INVALID'
  
  # Letting this check run first will ascertain that there is no invalid char on VIN
  if invalid_characters?(upcased_vin) || invalid_checksum?(upcased_vin)
    vin_suggestion = build_vin_suggestion(upcased_vin, status, check_digit)
  end
  
  #this 'if' and the recalculation of the check_digit is here for VIN's like INKDLUOX33R385016
  #where the checksum caculation will be right after you substitute the I,O and Q chars.
  #These two checks gave me the oportunity to suggest only one reliable vin instead of multiple sugestions
  #This also makes improbable(given this script spectrum of checking) and the correction that I did earlier
  #a situation where I have a valid check_digit and a suggestion at the same time.
  if status == 'INVALID'
    recalculed_check_digit = calculate_check_digit(vin_suggestion)
    vin_suggestion         = checksum_suggestion(vin_suggestion, recalculed_check_digit)
  end

  response(status: status, inputed_vin: vin, suggestion: vin_suggestion)
end

# for this two regexp I could have opted to move them to a constant and give them meaningfull names
# but the regexp logic is pretty simple so I opted to have them in two boolean methods(with meaningfull names)

# I, O and Q are invalid vin chars
def invalid_characters?(vin)
  (/^[^IOQ]+$/ =~ vin).nil?
end

#Checks if the 9th char is a digit between 0 and 9 or an 'X'
def invalid_checksum?(vin)
  (/^[X0-9]$/ =~ vin[8]).nil? 
end

#Since the transliteration would be used only here, I choose to transgform it in a constant(redability)
#and incorporate it on the execution which gave me more control over it(executing de modoperation a little later) 
def calculate_check_digit(vin)
  sum = 0
  
  vin.split('').each_with_index do |char, i| 
    vin_char_index = TRANSLITERATION_STRING.split('').index(char)
    sum += (vin_char_index % 10) * CHECKSUM_WEIGHTS[i] unless vin_char_index.nil?
  end
  
  CHECKSUM_MAP[sum % 11]
end

# Suggest based on:
# - the substitution of invalid chars(to ones that can be visually alike)
def build_vin_suggestion(vin, status, check_digit)
  vin.gsub('I', '1').gsub('Q', '0').gsub('O', '0')
end

# Suggest based on:
# - the substitution of a wrong 9th char(the checksum)
def checksum_suggestion(vin, check_digit)
  vin[8] = check_digit.to_s
  vin
end

#There's not much going on here :)
def response(status:, inputed_vin:, suggestion:)
  puts "Provided VIN: #{inputed_vin}"
  puts "Check digit:  #{status}"

  if status == 'INVALID'
    puts "Suggested VIN:#{suggestion}"
  else
    puts "It looks like a valid VIN!!"
  end
end

execute(upcased_vin, vin)
