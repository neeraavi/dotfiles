dirname="$(dirname "$1")" 
filename=$(basename -- "$1")
extension="${filename##*.}"
filenameonly="${filename%.*}"

cd $dirname
gpg --output $filenameonly --decrypt $filename && rm $filename
