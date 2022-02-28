#!/bin/bash
set -e

# exit when the command fails
set -o errexit;

# exit when try to use undeclared var
set -o nounset;

#GLOBALS
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
if [[ -z "${SCRIPT_DIR}" ]]; then
  error "Could not determine script path"
fi

readonly SCRIPT_DIR

function display_usage() {
  echo
  echo "********************************************************************************"
  echo
  echo "Execute console app in Kubernetes cluster"
  echo
  echo "Usage:"
  echo "  exec-console-app [flags]"
  echo
  echo "Flags:"
  echo "  -d|--days                       Argument 1"
  echo "  -p|--profile                    Argument 2"
  echo "  -h|--help                       Display help"
  echo
  echo "********************************************************************************"
  echo
}

function parse_args() {
  while (("$#")); do
    case "$1" in
    -h | --help)
      display_usage
      shift
      exit 0
      ;;

    -d | --days)
      if [ -n "$2" ]; then
        DAYS="$2"
        shift 2
      else
        display_usage
        error "Argument for $1 is missing"
        shift 2
      fi
      ;;

    -p | --profile)
      if [ -n "$2" ]; then
        PROFILE="$2"
        shift 2
      else
        display_usage
        error "Argument for $1 is missing"
        shift 2
      fi
      ;;

    -*|*) # unsupported flags
      display_usage
      error "Error: Unsupported flag $1"
      exit 1
      ;;
    esac
  done
}

function call_job() {
#"--seconds" | "-s") period=1;;
#"--minutes" | "-m") period=60;;
#"--hours" | "-h") period=$((60*60));;
#"--days" | "-d" | "") period=$((60*60*24));;

DAY_PERIOD=$((60*60*24))
DATE_FORMAT=$(date '+%Y%m%d')
NOW_DATE=$(date "+%s")
IAM_USER_ARRAY=$(aws iam list-users --query 'Users[*].UserName' --output text)

# First: UserName,AccesskeyId,CreateDate Output
for username in ${IAM_USER_ARRAY[@]}; do
    aws iam list-access-keys --user-name $username --query 'AccessKeyMetadata[*].[UserName,AccessKeyId,CreateDate]' --output text | sed 's/T[0-9]*:[0-9]*:[0-9]*Z//g' >> first_list_${DATE_FORMAT}.csv
done

# Second: CreateDate -> Epoch Conversion Output
for date in $(cat first_list_${DATE_FORMAT}.csv | awk '{print $3}' |while read x; do date -d "$x" +%s; done);do
  datediff=$(( ($NOW_DATE - $date)/($DAY_PERIOD) ))
  echo "$datediff" >> second_list_${DATE_FORMAT}.csv
done

# Final: Merge Files and Condition Filter Output
paste first_list_${DATE_FORMAT}.csv second_list_${DATE_FORMAT}.csv > final_list_${DATE_FORMAT}.csv

awk '{
 if ($4>'"$DAYS"') { print $1,$2,$3,$4 }
 else { "NO" }
 }' final_list_${DATE_FORMAT}.csv | tee /scrit/result/final_list_${DATE_FORMAT}.csv

rm -f first_list_${DATE_FORMAT}.csv second_list_${DATE_FORMAT}.csv
}

function main() {
  parse_args "$@"

  call_job
}

main "$@"
