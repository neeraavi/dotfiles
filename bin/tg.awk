BEGIN{
     print "Searching for:" ,kxx
RS="\n##";
FS="\n";
ORS="\n";
IGNORECASE = 1
}
{
  if ($0 ~ kxx) {print NR"\t##"$1}
} 
