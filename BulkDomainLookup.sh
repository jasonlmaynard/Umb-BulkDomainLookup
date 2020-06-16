#!/bin/bash
#
echo ---------------------------
echo - Author: Jason Maynard                                   
echo - Twitter: FE80CC1E  
echo - Version = 2.0
echo ---------------------------
echo
echo 
echo 
echo --------------------------------------------------------
echo - Evaluate domains against Umbrella Block Lists       
echo - Use this script at your own risk                    
echo - I accept no responsibilty whatsoever!               
echo --------------------------------------------------------
echo
echo 'You accept all responsibilty when using this script by choosing yes!' 
echo 
#
read -p "Are you sure you wish to continue? yes\no: "
if [ "$REPLY" != "yes" ]; then
   exit
fi
#
echo
#
echo -------------------------------------------------------------------------
echo - Downloading list and formating it for use in this script 
echo -------------------------------------------------------------------------
echo - wget: downloads the file from malwaredomainlist 
echo - awk: being used to grab only the domain - removes the 127.0.0.1 
echo - sed: used to remove the top 6 lines from the file 
echo -------------------------------------------------------------------------
wget http://www.malwaredomainlist.com/hostslist/hosts.txt && cat hosts.txt | awk '{print $2}' > domainlist && sed -i '1,6d' domainlist 
echo 
echo -------------------------------------------------------------------------
echo - Running Script Domains NOT blocked by Umbrella will be identified below
echo -------------------------------------------------------------------------
echo - dig: used to do the domain lookup
echo - grep: used to only focus on the blocked IPs from Umbrella
echo - awk: grabs only the domains from the results
echo - tr: used to remove the windows carriage returns at the end of each line
echo - sed: used to remove the dot. at the end of the domains to clean up the file 
echo - sed: also used to remove MS carriage return within the file 
echo - sort: used to sort the file by name
echo - uniq: used to only show domains that are not duplicate - not blocked by umbrella 
echo - Umbrella Block Page IPs: https://support.umbrella.com/hc/en-us/articles/115001357688-What-are-the-Cisco-Umbrella-Block-Page-IP-Addresses- 
echo -------------------------------------------------------------------------
dig -f domainlist | grep '146.112.61.104\|146.112.61.105\|146.112.61.106\|146.112.61.107\|146.112.61.110' | awk '{print $1}' > outblocked && cat outblocked | sed 's/\.$//' > outcleaned && cat outcleaned > domainlist1 && cat domainlist >> domainlist1 && sed $'s/\r//' -i domainlist1 && sort domainlist1 | uniq -u > DomainsNotBlocked.txt
echo
echo
echo ---------------------------------------------------------------------------
echo - Domains not blocked have been saved to "DomainsNotBlocked.txt"
echo ---------------------------------------------------------------------------
echo 
echo ------------------------------
echo - Listing domains not blocked
echo -----------------------------
cat DomainsNotBlocked.txt
echo 
echo --------------------------------------------
echo - Percentage of Domains Blocked in Umbrella
echo --------------------------------------------
value1=$(wc domainlist | awk '{print $1}')
value2=$(wc DomainsNotBlocked.txt | awk '{print $1}')
matheq1=$(($value1 - $value2))
matheq2=$(($matheq1*100/$value1))
echo -----------------------------------------------------------
echo - Note: lots of questions on the validity of the data 
echo - False Positives?
echo - NXDOMAIN?  
echo -
echo - This is a reminder that you may want to do some analysis
echo ------------------------------------------------------------
echo ~$matheq2% Blocked 
echo 
echo 
echo 
echo ------------------
echo - Cleaning Up!    
echo ------------------
#
rm outblocked && rm outcleaned && rm domainlist1 && rm hosts.txt && rm domainlist
echo
echo
echo
