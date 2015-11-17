#!/bin/bash

DOCKET_LINK="http://www.regulations.gov/exportdocket?docketId=ICEB-2015-0002"
DOCKET_FILE="docket.csv"
LINKS_FILE="links.txt"
TMP_COMMENT_FILE="comment.tmp"

MYSQL_CMD="mysql -u root opt"
SELECT_LINK="SELECT * FROM comments WHERE link"

# wget "$DOCKET_LINK" -O "$DOCKET_FILE"
tail -n +7 "$DOCKET_FILE" | awk -F, '{print $NF}' > $LINKS_FILE

while read link; do
    echo "Checking $link..."
    QUERY="$SELECT_LINK='$link'"
    echo "Executing: $QUERY"
    data=`$MYSQL_CMD -e "$QUERY"`

    if [[ ! -z "$data" ]]; then
        echo "Already found this link. Skipping."
    else
        echo "Fetching $link..."
        content=`phantomjs get_link.js "$link"`
        name=`echo -e "$content" | head -1`
        comment=`echo -e "$content" | tail -n +2`
        clean_comment=${comment//\'/\\\'}
        echo -e "$clean_comment" > "$TMP_COMMENT_FILE"
        echo "Predicting vote..."
        vote=`python predict.py "$TMP_COMMENT_FILE"`
        echo "Comment by $name. Vote=$vote."
        INSERT_QUERY="INSERT INTO comments VALUES (NULL, "\'$link\'", "\'$name\'", "\'$clean_comment\'", $vote, `date +%s`)";
        $MYSQL_CMD -e "$INSERT_QUERY" && echo "SUCCESSFULLY added $link"
    fi
    echo "*********************"
done < $LINKS_FILE
