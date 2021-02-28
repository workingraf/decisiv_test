# '+' returns a mutable string for frozen ones
vin         = +ARGV[0]
upcased_vin = vin.to_s.upcase

#checksum algorithm data constants
CHECKSUM_MAP           = [0,1,2,3,4,5,6,7,8,9,10,'X'] 
CHECKSUM_WEIGHTS       = [8,7,6,5,4,3,2,10,0,9,8,7,6,5,4,3,2]
TRANSLITERATION_STRING = '0123456789.ABCDEFGH..JKLMN.P.R..STUVWXYZ'


def execute(upcased_vin, vin)
  check_digit = calculate_check_digit(upcased_vin)
  status      = vin[8].to_i == check_digit ? 'VALID' : 'INVALID'
  
  if invalid_characters?(upcased_vin) || invalid_checksum?(upcased_vin)
    vin_suggestion = build_vin_suggestion(upcased_vin, status, check_digit)
  end
  
  #re-execute calculation after the initial vin correction(I,Q,O)
  if status == 'INVALID'
    recalculed_check_digit = calculate_check_digit(vin_suggestion)
    vin_suggestion         = checksum_suggestion(vin_suggestion, recalculed_check_digit)
  end

  response(status: status, inputed_vin: vin, suggestion: vin_suggestion)
end

# I, O and Q are invalid vin chars
def invalid_characters?(vin)
  (/^[^IOQ]+$/ =~ vin).nil?
end

#Checks if the 9th char is a digit between 0 and 9 or an 'X'
def invalid_checksum?(vin)
  (/^[X0-9]$/ =~ vin[8]).nil? 
end

def calculate_check_digit(vin)
  sum = 0
  
  vin.split('').each_with_index do |char, i| 
    vin_char_index = TRANSLITERATION_STRING.split('').index(char)
    sum += (vin_char_index % 10) * CHECKSUM_WEIGHTS[i] unless vin_char_index.nil?
  end
  
  CHECKSUM_MAP[sum % 11]
end

def build_vin_suggestion(vin, status, check_digit)
  vin.gsub('I', '1').gsub('Q', '0').gsub('O', '0')
end

def checksum_suggestion(vin, check_digit)
  vin[8] = check_digit.to_s
  vin
end

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
