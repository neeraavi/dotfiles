rm ~/tmp/a.txt

if [[ -d $1 ]]
then
    cd $1
    echo "cd $1" > ~/tmp/a.txt
fi

for item in "$@"
do
    if [[ -f $item ]]
    then
        filename=$(basename -- "$item")
        extension="${filename##*.}"
        filenameonly="${filename%.*}"
        echo "gpg --output $filenameonly --decrypt $filename && rm $filename" >> ~/tmp/a.txt
    fi  
done

