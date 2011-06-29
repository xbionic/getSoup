#!/bin/sh

LYNX="/usr/bin/lynx"
PSQL="/usr/bin/psql"


$LYNX --source http://www.soup.io/everyone | grep -i "permalink" | awk '{ print $4; }' | sed -e 's/href\=\"//' -e 's/"$//' >> soup.entries.tmp

sort -u soup.entries.tmp > soup.entries

rm soup.entries.tmp

while read url ; do echo "insert into soupurl (adress) (select '$url' where not exists (select adress from soupurl where adress='$url'));" | $PSQL -d soup ; done < soup.entries

rm soup.entries
