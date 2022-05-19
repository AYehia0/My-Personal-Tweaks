# Time to prayer
Simple bash script used to get the time for the upcoming prayer.

## Requirements
- [curl](https://curl.se/) for fetching prayer timings.
- [jq](https://stedolan.github.io/jq/) for parsing json files.

## Usage
- `chmod +x prayer.sh`
- `./prayer`

output :
```
Maghrib : 01:30
```

## Integration with polybar
Since the script only prints, so it basically could be used with any bar i3 for ex, you can customize the output as you want.

- Add the module to your polybar config file under : `~/.config/polybar/config`
```
[module/prayer]

type = custom/script
exec = /path/to/prayer.sh 
tail = true
interval = 60
```

## Notes 
- The script uses this [api](https://aladhan.com/prayer-times-api) to get monthly timings, by default:
    - Data is fetched based on [city](https://aladhan.com/prayer-times-api#GetCalendarByCitys).
    - Method is `5` for EET timings.
    - Country is `EG`, the mehest place in the world lol.
- Timings are parsed and saved as `<month>.json`.
- The script automatically updates the timings every month and shows today's timings.

