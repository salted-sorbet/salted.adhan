# salted.adhan

A prayer times widget for [Omarchy](https://omarchy.org/) with a popup panel.

## Features

- Shows next prayer time in the bar
- Click to open prayer times panel
- Configurable location and calculation method

## Installation

```bash
omarchy plugin clone salted.adhan
```

Or manually copy to `~/.config/omarchy/plugins/salted.adhan/`.

## Removal

```bash
rm -rf ~/.config/omarchy/plugins/salted.adhan
```

## Configuration

Add to `~/.config/omarchy/shell.json`:

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

## License

MIT
