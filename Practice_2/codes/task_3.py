import sys, math

# Funtions for valid date values
def is_valid_date(year, month, day):
    if not (1 <= month <= 12):
        return False
    if day < 1:
        return False
    # Days in each month
    month_lengths = [31, 29 if is_leap_year(year) else 28, 31, 30, 31, 30,
                     31, 31, 30, 31, 30, 31]
    if day > month_lengths[month - 1]:
        return False
    return True
def is_leap_year(year):
    # Gregorian calendar leap year rule
    return (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0)
def string_date(year, month, day):
    match month:
        case 1: return f'{day} January, {year}'
        case 2: return f'{day} February, {year}'
        case 3: return f'{day} March, {year}'
        case 4: return f'{day} April, {year}'
        case 5: return f'{day} May, {year}'
        case 6: return f'{day} June, {year}'
        case 7: return f'{day} July, {year}'
        case 8: return f'{day} August, {year}'
        case 9: return f'{day} September, {year}'
        case 10: return f'{day} October, {year}'
        case 11: return f'{day} November, {year}'
        case 12: return f'{day} December, {year}'

# Main code
if __name__ == "__main__":
    print('{:-^79}'.format('# Julian Date Calculator #'))
    # Outer loop: Responsible for ensuring a confirmed date.
    while True:
        # Ask for date in valid format
        print("\nEnter the date in the 'd/m/y' format: ")
        date = str(input('Date: '))
        # Check date value and format
        try:
            date_parts = None
            # Iterate through possible delimiters
            parts = date.split('/')
            # Check if splitting by this delimiter gives exactly 3 parts
            if len(parts) == 3:
                try:
                    date_parts = []
                    # Convert parts to integers
                    for part in parts:
                        part = int(part)
                        date_parts.append(part)
                    day, month, year = date_parts
                except:
                    raise ValueError('One or more parts are not numbers.')
            if date_parts is None: # No valid delimiter
                raise ValueError('Incorrect date format: Use d/m/y')
            if not is_valid_date(year, month, day):
                raise ValueError('Invalid date component values.')
        except ValueError as e:
            print(f"Error: {e}")
            continue # Go back to the outer loop to ask for a new date string
        # Inner loop: Responsible for confirming the entered date.
        while True:
            date_str = string_date(year, month, day)
            answer = input(f'\nYour date is {date} ({date_str}). Is this correct? (Y/n) ').strip().lower()
            if answer in ('','y','yes'): # Date confirmed
                break
            elif answer in ('n','no'): # Wrong date
                break
            else: # Invalid answer. Ask again
                print('\nWrong answer. Enter (Y/n).')
        # Check for date confirmation
        if answer in ('', 'y', 'yes'): # Correct date
            break
        # If wrong, re-enter date
    # Calculate the Julian date
    julian_day_number = math.floor(36525*year/100 + 306001*(month+1)/10000 + day + 1720981)
    print(f'\nThe Julian date for {date} is {julian_day_number}')