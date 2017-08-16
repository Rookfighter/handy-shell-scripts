#!/bin/bash -e

PAGES=30

if [ "$1" = "" ]; then
    echo "usage: splitpdf.sh FILE"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "usage: splitpdf.sh FILE"
    echo "  err: '$1' is not a file"
    exit 1
fi

FNAME=$1
FNAMEBASE=$(echo "$FNAME" | sed 's|\.[^\.]*$||g')
TOTALPAGES=$(pdftk "$FNAME" dump_data | grep "NumberOfPages" | awk '{print $2}')

echo "Splitting '$FNAME' with $TOTALPAGES pages"

i=0
done="no"

while [ "$done" = "no" ]; do
    ofile=$(printf "${FNAMEBASE}_%.2d.pdf" $((i+1)))
    start=$((($i * $PAGES) + 1))
    end=$(($start + $PAGES - 1))
    i=$(($i+1))

    if (( end > TOTALPAGES )); then
        end="end"
        done="yes"
    fi

    echo "Creating file '$ofile' from $start to $end "
    pdftk "$FNAME" cat $start-$end output "$ofile"
done

echo "Done"
