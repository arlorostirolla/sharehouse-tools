import pandas as pd
import calendar
from datetime import datetime, timedelta
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import numpy as np

# Load the CSV data
csv_file = 'yearly_roster.csv'
data = pd.read_csv(csv_file)

# Function to generate a list of dates within the specified month and week
def generate_dates(year, month, week):
    dates = []
    c = calendar.Calendar(firstweekday=calendar.MONDAY)
    month_days = [d for d in c.itermonthdates(year, month) if d.month == month]
    week_start = (week - 1) * 7
    week_dates = month_days[week_start : week_start + 7]

    # Only include weekdays
    for date in week_dates:
        if date.weekday() < 5:
            dates.append(date)

    return dates

def plot_calendar(calendar_data, year, month):
    fig, ax = plt.subplots(figsize=(10, 6))

    # Create a blank calendar grid (limited to 4 weeks)
    month_days = calendar.monthcalendar(year, month)[:4]
    month_grid = np.zeros((len(month_days), 7), dtype=object)

    # Fill the calendar grid with person and chore information
    for date, task in calendar_data.items():
        if date.month == month:
            week_indices = [i for i, week in enumerate(month_days) if date.day in week]
            if not week_indices:  # Skip dates not in the first 4 weeks
                continue
            week_num = week_indices[0]
            day_num = [i for i, day in enumerate(month_days[week_num]) if day == date.day][0]
            month_grid[week_num][day_num] = f"{task['Person']} - {task['Chore']}"

    # Set column and row labels
    column_labels = ['S', 'M', 'T', 'W', 'T', 'F', 'S']
    row_labels = [f"Week {i+1}" for i in range(len(month_days))]

    # Create a table with the calendar grid
    ax.table(cellText=month_grid, colLabels=column_labels, rowLabels=row_labels, loc='center', cellLoc='center')

    # Set plot properties
    ax.axis('off')
    ax.set_title(f'Monthly Roster: {calendar.month_name[month]} {year}', fontsize=16)

    # Save and display the plot
    plt.tight_layout()
    plt.savefig(f'roster_{year}_{month}.png')
    plt.show()

# Define the year and create an empty calendar dictionary
year = 2023
calendar_data = {}

# Iterate through the data and create the calendar
for index, row in data.iterrows():
    person = row['Person']
    chore = row['Chore']
    month = row['Month']
    week = row['Week']

    # Generate dates for the specified month and week
    dates = generate_dates(year, month, week)

    # Assign chores to dates, ensuring no two chores are on the same day
    for date in dates:
        if date not in calendar_data:
            calendar_data[date] = {"Person": person, "Chore": chore}
            break
        elif calendar_data[date]["Chore"] != chore:
            continue
        else:
            break

# Add the visualization function calls to the previous code
for month in range(1, 13):
    plot_calendar(calendar_data, year, month)

