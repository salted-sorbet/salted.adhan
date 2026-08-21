# Salted Adhan

Prayer times widget with popup panel for [Omarchy](https://omarchylinux.com).

## Features

- **Auto-detection**: Automatically detects your location via IP geolocation
- **Accurate times**: Uses MWL (Muslim World League) calculation method (Fajr 18°, Isha 17°)
- **Notifications**: Critical urgency notifications when prayer time arrives
- **Popup panel**: Click the widget to see all 5 daily prayer times
- **Refresh on demand**: Manually refresh times from the panel

## Installation

```bash
omarchy plugin install salted-sorbet/salted.adhan
```

Add to your shell layout:

```json
{
  "bar": {
    "layout": {
      "right": [
        { "id": "salted.adhan" }
      ]
    }
  }
}
```

## Usage

- The widget displays "A" in the bar
- Click to open the prayer times panel
- Click **Refresh** to update times from the network
- Notifications appear automatically at each prayer time

## Configuration

The plugin stores its config in `~/.config/omarchy/salted.adhan/`:

- `config.json` — Saved coordinates (auto-detected or manual)
- `prayer_times.txt` — Current prayer times
- `sent_today.txt` — Tracks sent notifications

To manually set coordinates, edit `config.json`:

```json
{
  "coordinates": [48.8566, 2.3522, 0]
}
```

## Prayer Times

| Prayer   | Description                    |
|----------|--------------------------------|
| Fajr     | Dawn prayer                    |
| Dhuhr    | Midday prayer                  |
| Asr      | Afternoon prayer               |
| Maghrib  | Sunset prayer                  |
| Isha     | Night prayer                   |

## Calculation Method

Uses **Muslim World League (MWL)** method:

- Fajr angle: 18°
- Isha angle: 17°
- Maghrib: Sunset (no offset)
- Asr: Standard (Shafi'i)

## License

MIT License — see [LICENSE](LICENSE) for details.
