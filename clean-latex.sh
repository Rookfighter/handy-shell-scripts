#!/bin/bash -e

find . \( -name "*.aux" -o -name "*.bbl" -o -name "*.blg" -o -name "*.log" -o -name "*.lol" -o -name "*.lot" -o -name "*.out" -o -name "*.synctex.gz" -o -name "*.toc" \) -delete
