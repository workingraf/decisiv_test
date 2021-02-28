# decisiv_test

Considerations:

1. I'm sending you two copies of my script, one is the test code itself nothing else, the other has some personal comments about some decisions I made to help understand my train of thought on those cases.

2. On the test pdf the VIN 'INKDLUOX33R385016' appears twice. If I may, I would suggest adding this vin '1M8GDM9XKP042788'  in place of one of the repetitions, it is a valid VIN with an 'X' as the checksum digit.

3. This was a pretty fun test to do.


Bonus activities:
1. Are you able to provide any suggested attributes based upon the decoding of the VIN given your newfound knowledge of this identifier?

On a pure knowledge standpoint, I can explain all of the suggested attributes that come within a vin:

- The first char is used to indicate the country of origin to this vehicle.
- The second one is used to indicate the manufacturer.
- The third one is used with the first and second char acts as a disambiguation factor, and would indicate the vehicle's type or the manufacturer's division.  https://en.wikibooks.org/wiki/Vehicle_Identification_Numbers_(VIN_codes)/World_Manufacturer_Identifier_(WMI) here is a list of WNI codes
- From the fourth char until the eighth we will be able to retrieve information such as model, body type, restraint system, transmission type and engine code.
- The ninth one is the check digit used to validate the VIN's numbers.
- The tenth one is used to indicate the model year
- The eleventh one is used to indicate the manufacturing plant where the vehicle was assembled.
- The last 6 digits are the production sequence numbers.

Programmatically, assuming that I would have a database with the necessary data to cross the information(or an API who serves the same)
I could probably suggest any information about the attributes listed above.


2. If we wanted to replicate or enhance behavior in our GET /vins/:vin endpoint in Global Assets how might this script help us? Do you see any opportunities in the API contract to allow this when a consumer receives an HTTP 400 - Bad Request response.

Generally speaking it is a good practice not to give too much information about a HTTP 400 error on a public API,
the other party must be aware of the API contract and parameters formats.
Giving too much information can make the endpoint exploitable to brute force predictions.

But assuming this is a controlled environment, used only within the company and it's associates with a authentication requirement

A way to enhance the api would be letting the response give some advice based on the most core elements of the vin, using the test code as a reference:

- we could run the regexp responsible for checking I, O and Q's presence, and the one responsible
  right range of enable characters for the check_digit, to give a more certain response about what has gone wrong.
- we could combine the two steps above with a simple length check to validate the general structure even if there is one or more characters missing
