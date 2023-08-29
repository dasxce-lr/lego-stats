# Usage: python3 generate_schedule.py
import calendar

def print_schedule(year, month):
    # Get the total number of days in the specified month
    num_days = calendar.monthrange(year, month)[1]
    
    # Iterate through each day in the month
    for day in range(1, num_days + 1):
        # Calculate the day of the week (0: Monday, 6: Sunday)
        day_of_week = calendar.weekday(year, month, day)
        print(f"{month:02d}/{day:02d} Morning")
        if day_of_week >= 4:
            print(f"{month:02d}/{day:02d} Mid-day")
        print(f"{month:02d}/{day:02d} Night")

# Input: Year and month
year = int(input("Enter the year: "))
month = int(input("Enter the month: "))

print_schedule(year, month)
