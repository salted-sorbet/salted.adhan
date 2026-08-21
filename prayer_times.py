from datetime import date
from praytimes import *

if __name__ == "__main__":
    script_date = date.today()
    times = prayTimes.getTimes(script_date, (36.75, 3.06, 0), 1)
    
    with open("prayer_times.txt", "w") as f:
        for i in ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha']:
            f.write(f"{times[i.lower()]}\n")
            
    print("Prayer times successfully saved to prayer_times.txt!")