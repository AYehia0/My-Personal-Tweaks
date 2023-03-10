#!/bin/sh

# getting today's date
CURRENT_YEAR=`date +"%Y"`
CURRENT_MONTH=`date '+%m'`
CURRENT_DAY=`date '+%d'`
CURRENT_TIME=`date +"%H:%M"`
PRAYER_TIMES_LOC=`pwd`/$CURRENT_MONTH.json
CITY="cairo"
COUNTRY="EG"
METHOD=5
API_URL="http://api.aladhan.com/v1/calendarByCity/$CURRENT_YEAR/$CURRENT_MONTH?city=$CITY&country=$COUNTRY&method=$METHOD&month=$CURRENT_MONTH&year=$CURRENT_YEAR"

# convert date
get_date() {
    date --date="$1" +"%H:%M"
}

# check if the data exists on location
if [[ -f "$PRAYER_TIMES_LOC" ]]; 
then
    #echo "Data exists at path : $PRAYER_TIMES_LOC"

    # get current day data
    IND=$CURRENT_DAY

    # read each item in the JSON array to an item in the Bash array
    readarray -t items < <(jq -c ".[${IND}] | to_entries | .[]" $PRAYER_TIMES_LOC )

    athans=()

    # Calculate the time difference for prayers
    for item in "${items[@]}"; do

        key=$(jq -r '.key' <<< $item)

        time=$(jq -r '.value' <<< $item)

        # Convert to epoch time and calculate difference.
        seconds=$(( $(date "+%s" -d "$time" ) - $(date "+%s" -d $CURRENT_TIME ) ))

        diffTime=$(date -d @${seconds} +"%H:%M" -u)
        
        #echo "$key time is : $time , remaining time : $diffTime , seconds : $seconds"

        athans+=($key","$diffTime)

    done

    first_val=${athans[0]}

    # splitting on comma
    prayer=(${first_val//,/ })
    min=${prayer[1]}
    p_min=${prayer[0]}
    for athan in "${athans[@]}"; do
        athan_value=(${athan//,/ })
        if [[ $(get_date "${athan_value[1]}") < $(get_date "$min") ]]; 
        then
            min=${athan_value[1]}
            p_min=${athan_value[0]}
        fi
    done

    # pip this output to polybar
    echo "$p_min : $min"
else
  # download and parse
  # to_entries | map_values(.value + {day: .key}) | map(.timings + {day : .day})
  echo "Monthly data doesn't exist, trying to fetch it..."
  curl $API_URL | jq '[.data | map(.timings) | .[] | to_entries | map({key, value: .value[:5]}) | from_entries | del(.Midnight,.Imsak,.Sunrise,.Sunset) ]' >> $PRAYER_TIMES_LOC
fi

