#!/bin/bash
echo -e "
DMARCscan - Bulk DMARC Scanner
Codename : Asuka\n"

if ! command -v dig &> /dev/null
        then
        echo "This tool use dig to check DMARC. Please make sure dig is installed."
        exit 1
fi
# Color definition
reset="\033[0m"			# Normal Colour
red="\033[0;31m" 		# Error / Issues
green="\033[0;32m"		# Successful
#Function
process=5
showHelp()
{
   # Display Help
   echo "Example: bash $0 -l domain.txt -t 30"
   echo "options:"
   echo "-l     Files contain lists of domain."
   echo "-d     Single domain check"
   echo "-t     Adjust multi process. Default is 15"
   echo "-h     Print this Help."
   echo
}


if [ -z "$1" ] || [[ ! $@ =~ ^\-.+ ]]; then
    showHelp
    exit 0
fi
while getopts ":hl:d:t:" opt; do
    case $opt in
        h)  showHelp
            exit 0
            ;;
        l)  domainlists=$OPTARG
            ;;
        d)  singledomain=$OPTARG
            ;;
        t)  if ! [[ "$OPTARG" =~ ^[0-9]+$ && "$OPTARG" -gt 0 ]]; then
            echo "Error: invalid thread value"  >&2
            exit 1 # failure
            fi
            process="$OPTARG"
            ;;
        \?) echo "invalid option: -$OPTARG"
            exit 1
            ;;
        :)  echo "option -$OPTARG requires an argument."
            exit 1
            ;;    
    esac
done
shift "$((OPTIND-1))"

# Options validation
if [[ ! -z "$domainlists" && ! -z "$singledomain" ]]; then
    echo "Option -l and -d cannot be used together." >&2
    exit 1
fi
# Domain input validation
domainListCheck(){
	if [[ -z "$domainlists" || ! -f "$domainlists" ]]; then
    	echo "Please provide valid domain or domain list." >&2
    	exit 1
	fi
}
if [[ -z "$singledomain" ]]; then
	domainListCheck
fi
bulkDMARC() {
	if [[ $(dig +short _dmarc.$hostlists TXT) =~ 'DMARC' ]]; then
		printf "$hostlists - ${green}DMARC Exist${reset}\n"
	else
		printf "$hostlists - ${red}DMARC not Exist${reset}\n"
	fi
}
singleDMARC() {
	if [[ $(dig +short _dmarc.$singledomain TXT) =~ 'DMARC' ]]; then
		printf "$singledomain - ${green}DMARC Exist${reset}\n"
	else
		printf "$singledomain - ${red}DMARC not Exist${reset}\n"
	fi
}
# Do the jobs
if [[ ! -z "$singledomain" ]]; then
    singleDMARC
    else
    while read hostlists; do
    bulkDMARC &
    background=( $(jobs -p) )
    	if (( ${#background[@]} == process )); then
        	wait -n
    	fi
   done < "$domainlists"
wait
fi

echo  -e "\nAll jobs done. Thank you!"
