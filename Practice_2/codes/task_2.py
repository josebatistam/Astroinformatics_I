import sys
# Get temperature value from command line and ensure it's a valid number
if len(sys.argv) < 2:
    print('No input provided. Use: python3 task_2.py <temperature>')
    sys.exit(1)
try:
    temperature = float(sys.argv[1])
except ValueError:
    print('ValueError: The input argument must be a number.')
    sys.exit(1)
# Make sure the value is within the valid star temperature range [2000, 60000] K
if temperature < 2000.0 or temperature > 60000.0:
    print('ValueError: The given star temperature is invalid.')
    print('Enter a temperature in the range [2000.0, 60000.0] K.')
    sys.exit(1)
# Classify the star according to its temperature
if 2000.0 <= temperature <= 3500.0:
    star_type = 'an M-type'
elif 3500.0 < temperature <= 5000.0:
    star_type = 'a K-type'
elif 5000.0 < temperature <= 6000.0:
    star_type = 'a G-type'
elif 6000.0 < temperature <= 7500.0:
    star_type = 'an F-type'
elif 7500.0 < temperature <= 10000.0:
    star_type = 'an A-type'
elif 10000.0 < temperature <= 30000.0:
    star_type = 'a B-type'
else: # 30000.0 < temperature <= 60000.0
    star_type = 'an O-type'
print(f'With a temperature of {temperature:.2f} K, this is {star_type} star.')