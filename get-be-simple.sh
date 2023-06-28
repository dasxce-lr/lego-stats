# epoch="example-output/$(date +%s)"; bash get-be-simple.sh example-input/data.csv $epoch
# data.csv is expected to just be a file where each line is the set number. The first line is a header

sleeptime=2
epoch="$2"

date
mkdir -p $epoch

OLDIFS=$IFS
IFS=$'\n'

echo setnum,name,retailp,benew,bused,releasedDate,retiredDate,theme,subtheme,pieces,minifign,growth,annualgrow,futuregrow,usedrange,minifigval,retirepop,link > $epoch/timeline-be.csv;

for line in $(tail -n +2 $1 ); do
    f=$(echo $line)
    if [[ $f != *"-"* ]]; then
        f="${f}-1"
    fi

    if [[ ! -f "$epoch/$f.html" ]]; then
        wget --user-agent="Mozilla" -q -O $epoch/$f.html https://www.brickeconomy.com/set/${f}/
        sleep $sleeptime
    fi

    bef=$epoch/$f.html

    benew=$(grep -A1 'New/Sealed</span></div>' $bef | tail -1 | rev | cut -d'>' -f4 | rev | cut -d'<' -f1 | sed 's/,//g' | sed -e "s/\r//g" );
    if [[ "$benew" == "" ]]; then
        benew=$(grep  '>Value</span></div>' $bef | rev | cut -d'>' -f4 | rev | cut -d'<' -f1 | sed 's/,//g' | sed -e "s/\r//g");
    fi
    benewg=$(grep -A2 'New/Sealed</span></div>' $bef | tail -1 | cut -d'>' -f5 | cut -d'&' -f1 | cut -d'+' -f2 | cut -d'<' -f1 | sed -e "s/\r//g" );
    if [[ "$benewg" == "" ]]; then
        benewg=$(grep '>Growth</div>' $bef | rev | cut -d'>' -f3 | rev | cut -d'&' -f1 | cut -d'+' -f2 | cut -d'<' -f1 | sed -e "s/\r//g");
    fi
    bag=$(grep  '>Annual growth</span>' $bef  | rev | cut -d'>' -f3 | rev | cut -d'<' -f1 | cut -d'+' -f2 | sed -e "s/\r//g")
    if [[ "$bag" == "" ]]; then
        bag=$(grep  '>Annual growth</span>' $bef | grep -v "(first year)" | rev | cut -d'>' -f5 | rev | cut -d'<' -f1 | cut -d'&' -f1 | cut -d'+' -f2 | sed -e "s/\r//g" | cut -d' ' -f1 );
    fi
    bfg=$(grep  '>Future growth</span>' $bef  | cut -d'>' -f7 | cut -d'&' -f1 | cut -d'+' -f2 | cut -d'<' -f1 | sed -e "s/\r//g" )
    bused=$(grep -A1 '>Used</span></div>' $bef | tail -1 | rev | cut -d'>' -f3 | rev | cut -d'<' -f1 | sed 's/,//g' | sed -e "s/\r//g" );
    busedr=$(grep -A2 '>Used</span></div>' $bef | tail -1 | rev | cut -d'>' -f3 | rev | cut -d'<' -f1 | sed 's/,//g' | sed -e "s/\r//g" );
    bmfv=$(grep  '>Minifigs</div>' $bef  | cut -d'>' -f9 | cut -d'&' -f1 | cut -d'+' -f2 | cut -d'<' -f1 | cut -d' ' -f2 | cut -d')' -f1 | sed -e "s/\r//g" | sed 's/,//g');
    retire=$(grep '>Retirement<' $bef | rev | cut -d'>' -f5 | rev | cut -d'<' -f1  | sed -e "s/\r//g" | sed  -e's/[ \t]*$//')
    retireperc=$(grep '>Retirement<' $bef | rev | cut -d'>' -f4 | rev | cut -d'<' -f1  | sed -e "s/\r//g")
    retirep=$(grep  '>Retirement pop<' $bef | rev | cut -d'>' -f4 | rev | cut -d'&' -f1 | cut -d'+' -f2 | cut -d'<' -f1 | sed -e "s/\r//g")
    retirep=$(grep  '>Retirement pop<' $bef | rev | cut -d'>' -f4 | rev | cut -d'&' -f1 | cut -d'+' -f2 | cut -d'<' -f1 | sed -e "s/\r//g")

    retailp=$(grep  '>Retail price<' $bef  | rev | cut -d'>' -f3 | rev | cut -d'&' -f1 | cut -d'+' -f2 | cut -d'<' -f1 | sed -e "s/\r//g" | sed -r 's/,/;/g')
    retiredDate=$(grep  '>Retired<' $bef  | grep -v '>Availability<' | rev | cut -d'>' -f3 | rev | cut -d'&' -f1 | cut -d'+' -f2 | cut -d'<' -f1 | sed -e "s/\r//g"  | sed 's/,//g')
    if [[ "$retiredDate" == "" ]]; then
        retiredDate="$retire ($retireperc)"
    fi
    releasedDate=$(grep  '>Released<' $bef  | rev | cut -d'>' -f3 | rev | cut -d'&' -f1 | cut -d'+' -f2 | cut -d'<' -f1 | sed -e "s/\r//g"  | sed 's/,//g')
    pieces=$(grep  '>Pieces</div>' $bef  | cut -d'>' -f5 | cut -d'&' -f1 | cut -d'+' -f2 | cut -d'<' -f1 | cut -d' ' -f2 | cut -d')' -f1 | sed -e "s/\r//g" | sed 's/,//g')
    minifign=$(grep  '>Minifigs</div>' $bef  | cut -d'>' -f6 | cut -d'&' -f1 | cut -d'+' -f2 | cut -d'<' -f1 | cut -d' ' -f2 | cut -d')' -f1 | sed -e "s/\r//g" | sed 's/,//g');
    if [[ "$minifign" == "" ]]; then
        minifign=$(grep  '>Minifigs</div>' $bef  | cut -d'>' -f5 | cut -d'&' -f1 | cut -d'+' -f2 | cut -d'<' -f1 | cut -d' ' -f2 | cut -d')' -f1 | sed -e "s/\r//g" | sed 's/,//g');
    fi
    subtheme=$(grep  '>Subtheme<' $bef | rev | cut -d'>' -f4 | rev | cut -d'&' -f1 | cut -d'+' -f2 | cut -d'<' -f1 | sed -e "s/\r//g"  | sed -r 's/,/;/g')
    theme=$(grep  '>Theme<' $bef | tail -1 | rev | cut -d'>' -f4 | rev | cut -d'&' -f1 | cut -d'+' -f2 | cut -d'<' -f1 | sed -e "s/\r//g"  | sed -r 's/,/;/g')
    name=$(grep  '>Name<' $bef  | rev | cut -d'>' -f3 | rev | cut -d'+' -f2 | cut -d'<' -f1 | sed -e "s/\r//g"  | sed -r 's/,/;/g')

    echo $f,$name,$retailp,$benew,$bused,$releasedDate,$retiredDate,$theme,$subtheme,$pieces,$minifign,$benewg,$bag,$bfg,$busedr,$bmfv,$retirep,https://www.brickeconomy.com/set/${f}/ >> $epoch/timeline-be.csv;
done

cp $1 $epoch/

IFS=$OLDIFS

date
