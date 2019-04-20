BEGIN{
     print "Searching for:" ,kxx
RS="\n##";
FS="\n";
ORS="\n";
IGNORECASE = 1
}
{
  if (NR == kxx || $1 ~ kxx) {
       ++x;
      #print "\033[1;34m---------------------------------------"
      print "\033[1;34m"
	   print NR"\t##"$1"\n---------------------------------------\033[0m\n##"$0
	   }
}
END{
#print "\n-------------------------------------\nTotal matches:", x
print "\n\033[33mTotal matches:\033[0m", x
}
