#Example usage:
#gawk -f a.awk -v kxx=key notes.txt
BEGIN{
     print "Searching for:" ,kxx
RS="\n##";
FS="\n";
ORS="\n";
IGNORECASE = 1
}
{
  if ($1 ~ kxx) {print NR"\t##"$1}
} 
