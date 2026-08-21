import json
import os
import sys
import urllib.request
from datetime import date, datetime, timezone, timedelta
from praytimes import PrayTimes

CONFIG_DIR = os.path.expanduser("~/.config/omarchy/salted.adhan")
CONFIG_FILE = os.path.join(CONFIG_DIR, "config.json")


def get_location_from_ip():
    """Get coordinates from IP geolocation."""
    try:
        with urllib.request.urlopen("https://ip-api.com/json/", timeout=5) as response:
            data = response.read(512)
            data = json.loads(data.decode())
            if data.get("status") == "success":
                lat = float(data.get("lat", 0))
                lon = float(data.get("lon", 0))
                if -90 <= lat <= 90 and -180 <= lon <= 180:
                    return (lat, lon, 0)
    except Exception:
        pass
    return None


def get_timezone_offset():
    """Get local timezone offset from UTC in hours."""
    now = datetime.now(timezone.utc)
    local = datetime.now()
    offset = local.utcoffset()
    if offset is not None:
        return offset.total_seconds() / 3600
    return 1  # Fallback to UTC+1


def load_config():
    """Load saved config or create default."""
    if os.path.exists(CONFIG_FILE):
        try:
            with open(CONFIG_FILE, "r") as f:
                config = json.load(f)
            coords = config.get("coordinates")
            if coords and len(coords) >= 2:
                lat, lon = float(coords[0]), float(coords[1])
                if -90 <= lat <= 90 and -180 <= lon <= 180:
                    return config
        except (json.JSONDecodeError, ValueError, TypeError):
            pass
    return {"coordinates": None}


def save_config(config):
    """Save config to file."""
    os.makedirs(CONFIG_DIR, exist_ok=True)
    with open(CONFIG_FILE, "w") as f:
        json.dump(config, f, indent=2)


def get_coordinates():
    """Get coordinates from config or IP. Returns None if unavailable."""
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

    return None


if __name__ == "__main__":
    coordinates = get_coordinates()
    if coordinates is None:
        print("Error: Could not determine location.", file=sys.stderr)
        print("Please set coordinates manually in " + CONFIG_FILE, file=sys.stderr)
        sys.exit(1)

    script_date = date.today()
    tz_offset = get_timezone_offset()
    pt = PrayTimes('MWL')
    times = pt.getTimes(script_date, coordinates, tz_offset)

    output_path = os.path.join(CONFIG_DIR, "prayer_times.txt")
    with open(output_path, "w") as f:
        for i in ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha']:
            f.write(f"{times[i.lower()]}\n")

    print("Prayer times successfully saved to " + output_path)