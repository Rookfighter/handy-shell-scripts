#!/bin/bash -e

# Parameters
IMG_SIZE="1080x1950"
IMG_EXT="jpg"
FILES_PER_PDF=30

ORIG_FILES=$(ls *.$IMG_EXT)
NEW_FILES=""
CURRENT_FILES=""
PDFS=""
i=0
TMP_DIR=$(mktemp -d "jpg2pdf.XXXXXX")

create_pdf()
{
    name=$(printf "%03d" $i)
    echo "Creating PDF $name ..."
    fpath="$TMP_DIR/$name.pdf"
    convert $CURRENT_FILES "$fpath"
    CURRENT_FILES=""
    PDFS="$PDFS $fpath"
}

echo "Resizing pictures ..."
for f in $ORIG_FILES
do
    convert -resize $IMG_SIZE "$f" "$TMP_DIR/$f"
done

echo "Creating PDFs from pictures ..."
NEW_FILES=$(ls "$TMP_DIR"/*.$IMG_EXT)
for f in $NEW_FILES
do
    CURRENT_FILES="$CURRENT_FILES $f"
    i=$(($i + 1))

    if [ $(($i % $FILES_PER_PDF)) = 0 ]
    then
        create_pdf
    fi
done

if [ ! -z "$CURRENT_FILES" ]
then
    create_pdf
fi

echo "Finalizing ..."
convert $PDFS result.pdf
rm -rf "$TMP_DIR"

