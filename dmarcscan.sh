#!/bin/bash
trap "exit" INT TERM ERR SIGINT
trap "kill 0" EXIT

# Color definition
blue="\033[0;34m"
cyan="\033[0;36m"
reset="\033[0m"
red="\033[0;31m"
green="\033[0;32m"
orange="\033[0;33m"
bold="\033[1m"
b_green="\033[1;32m"
b_red="\033[1;31m"
b_orange="\033[1;33m"

echo -e "
█▀▄ █▀▄▀█ ▄▀█ █▀█ █▀▀ █▀ █▀▀ ▄▀█ █▄░█
█▄▀ █░▀░█ █▀█ █▀▄ █▄▄ ▄█ █▄▄ █▀█ █░▀█
   ${bold}Domain-based Message Authentication, Reporting and Conformance Scanner${reset}
"
if ! command -v dig &> /dev/null
        then
        echo "This tool use dig to check DMARC. Please make sure dig is installed."
        exit 1
fi

#Variable
datenow=$(date +'%m/%d/%Y %r')
process=5

function showHelp(){
   echo "Example: bash $0 -l domain.txt -t 30"
   echo "options:"
   echo "-l     Files contain lists of domain."
   echo "-d     Single domain check"
   echo "-t     Adjust multi process. Default is 15"
   echo "-h     Print this Help."
   echo
}

if [ -z "$1" ] || [[ ! $1 =~ ^\-.+ ]]; then
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
if [[ -n "$domainlists" && -n "$singledomain" ]]; then
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

if [[ -z "$domainlists" ]]; then
	hostlists="$singledomain"
fi

dmarcscan() {
	if [[ $(dig +short _dmarc."$hostlists" TXT) =~ 'DMARC' ]]; then
        if [[ $(dig +short _dmarc."$hostlists" TXT) =~ 'p=none' ]]; then
            echo -e "${hostlists} --> ${b_orange}p=none Found ${reset}"
	    else
        echo -e "${hostlists} --> ${b_green}Found${reset}"
        fi
	else
		echo -e "${hostlists} --> ${b_red}Not Found${reset}"
	fi
}

# Do the jobs
echo -e "${bold}[${datenow}] - Program Start${reset}\n"
if [[ -n "$singledomain" ]]; then
    dmarcscan
elif [[ -n "$domainlists" ]]; then
    while IFS= read -r hostlists; do
    dmarcscan &
    if test "$(jobs | wc -l)" -ge "$process"; then
      wait -n
    fi
   done < "$domainlists"
fi
wait
echo -e "\n${bold}[${datenow}] - Program End${reset}"