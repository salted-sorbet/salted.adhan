import json
import os
import urllib.request
from datetime import date
from praytimes import PrayTimes

CONFIG_DIR = os.path.expanduser("~/.config/omarchy/salted.adhan")
CONFIG_FILE = os.path.join(CONFIG_DIR, "config.json")


def get_location_from_ip():
    """Get coordinates from IP geolocation."""
    try:
        with urllib.request.urlopen("http://ip-api.com/json/", timeout=5) as response:
            data = json.loads(response.read().decode())
            if data.get("status") == "success":
                return (data["lat"], data["lon"], 0)
    except Exception:
        pass
    return None


def load_config():
    """Load saved config or create default."""
    if os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE, "r") as f:
            return json.load(f)
    return {"coordinates": None}


def save_config(config):
    """Save config to file."""
    os.makedirs(CONFIG_DIR, exist_ok=True)
    with open(CONFIG_FILE, "w") as f:
        json.dump(config, f, indent=2)


def get_coordinates():
    """Get coordinates from config, IP, or prompt user."""
    config = load_config()

    # Use saved coordinates if available
    if config.get("coordinates"):
        return tuple(config["coordinates"])

    # Try IP geolocation
    coords = get_location_from_ip()
    if coords:
        config["coordinates"] = list(coords)
        save_config(config)
        return coords

    # Fallback: ask user
    print("Could not detect location automatically.")
    lat = float(input("Enter latitude: "))
    lon = float(input("Enter longitude: "))
    coords = (lat, lon, 0)
    config["coordinates"] = list(coords)
    save_config(config)
    return coords


if __name__ == "__main__":
    script_date = date.today()
    coordinates = get_coordinates()
    pt = PrayTimes('Egypt')
    times = pt.getTimes(script_date, coordinates, 1)
    
    output_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "prayer_times.txt")
    with open(output_path, "w") as f:
        for i in ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha']:
            f.write(f"{times[i.lower()]}\n")
            
    print("Prayer times successfully saved to " + output_path)