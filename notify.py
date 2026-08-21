#!/usr/bin/env python3
"""
Check current time against prayer_times.txt and send notification if match.
Exits after checking once.
"""
import os
import sys
import subprocess
from datetime import datetime

CONFIG_DIR = os.path.expanduser("~/.config/omarchy/salted.adhan")
TIMES_FILE = os.path.join(CONFIG_DIR, "prayer_times.txt")
SENT_FILE = os.path.join(CONFIG_DIR, "sent_today.txt")

PRAYER_NAMES = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"]


def read_times():
    if not os.path.exists(TIMES_FILE):
        return []
    with open(TIMES_FILE, "r") as f:
        lines = f.read().strip().split("\n")
    times = []
    for i, line in enumerate(lines):
        if i < len(PRAYER_NAMES):
            times.append((PRAYER_NAMES[i], line.strip()))
    return times


def get_sent_today():
    if not os.path.exists(SENT_FILE):
        return set()
    with open(SENT_FILE, "r") as f:
        content = f.read().strip()
    if not content:
        return set()
    return set(content.split("\n"))


def mark_sent(name):
    with open(SENT_FILE, "a") as f:
        f.write(name + "\n")


def reset_sent_if_new_day():
    if not os.path.exists(SENT_FILE):
        return
    import os as _os
    mtime = _os.path.getmtime(SENT_FILE)
    from datetime import date as _date
    file_date = datetime.fromtimestamp(mtime).date()
    if file_date != _date.today():
        with open(SENT_FILE, "w") as f:
            pass


def send_notification(name):
    subprocess.run([
        "notify-send",
        "--urgency=critical",
        "--app-name=Adhan",
        "--icon=preferences-system-time",
        f"{name} Prayer Time",
        f"It is now time for {name} prayer.",
    ], check=False)


def main():
    reset_sent_if_new_day()
    prayer_times = read_times()
    sent = get_sent_today()
    current_time = datetime.now().strftime("%H:%M")

    for name, time_str in prayer_times:
        if name in sent:
            continue
        if time_str == current_time:
            send_notification(name)
            mark_sent(name)


if __name__ == "__main__":
    main()
