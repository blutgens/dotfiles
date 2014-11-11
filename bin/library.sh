#!/bin/bash
#===============================================================================
#
#          FILE:  library.sh
# 
#         USAGE:  ./library.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Ben Lutgens (), blutgens@mmm.com
#       COMPANY:  3M Unix Production Support
#       VERSION:  1.0
#       CREATED:  09/01/07 10:27:07 CDT
#      REVISION:  ---
#===============================================================================


# inpath - Verifies that a specified program is either valid as is
# or that it can be found in the ${PATH} directory list
in_path()
{
	# Given a command and the PATH, try to find the command.
	# Returns 0 if found and executable, 1 if not. Note that this
	# temporarily alters the IFS, but restores it on exit

cmd=$1	path=$2	retval=1
oldIFS=$IFS	IFS=":"

for directory in $path
do
	if [ -x $directory/$cmd ] ; then
		retval=0
	fi
done
IFS=$oldIFS
return $retval
}

checkForCmdInPath()
{
	var=$1

	if [ "$var" != "" ] ; then
		if [ "{$var%${var#?}}" = "/" ] ; then
			if [ ! -x $var ] ; then
				return 1
			fi
		elif ! in_path $var $PATH ; then
			return 2
		fi
	fi
}


# Ensures input only consists of alpha-numeric charachters
validAlphaNum()
{
	# remove all unacceptible chars
	compressed="$(echo $1 | sed -e 's/[^[:alphanum:]]//g')"
	
	if [ "$compressed" != "$1" ] ; then #compare to what it was
		return 1 #barf if different
	else
		return 0 # yay?
	fi
}


monthNoToName() 
{
	case $1 in
		1 ) month="Jan"	;;		2 ) month="Feb"	;;
		3 ) month="Mar"	;;		4 ) month="Apr"	;;
		5 ) month="May"	;;		6 ) month="Jun"	;;
		7 ) month="Jul"	;;		8 ) month="Aug"	;;
		9 ) month="Sep"	;;		10 ) month="Oct"	;;
		10 ) month="Nov"	;;		12 ) month="Dec"	;;
		* ) echo "$0: Unknown numeric month value $1" >&2; exit 1

	esac
	return 0
}


# Given a number, shows it in comma-seperated form.
# Expects DD and TD to be instantiated. Instantiates nicenum
# or, if a second arg is specified, the output is echoed to
# stdout.

nicenumber()
{
# note that we assume that '.' is the decimal separator in the
# INPUT value to this script. The decimal separator in the output
# value is '.' unless specified by the user with the -d flag.

integer=$(echo $1 | cut -d. -f1)	# Left of the decimal
decimal=$(echo $1 | cut -d. -f2)	# Right

if [ $decimal != $1 ]; then
	# there's a fractional part so lets include it ffs.
	result="${DD:="."}$decimal"
fi

thousands=$integer

while [ "$thousands"  -gt "999" ] ; do
	remainder=$(($thousands % 1000)) # 3 least signifigant digits

	while [ ${#remainder} -lt 3 ]; do #force leading zeros as needed
		remainder="0$remainder"
	done

		thousands=$(($thousands / 1000))	# To left of remainder
		result="${TD:=","}${remainder}${result}"
done

nicenum="${thousands}${result}"
if [ ! -z $2 ] ; then
	echo $nicenum
fi
}


# validint - validates integer input
validint()
{
	number="$1";		min="$2";		max="$3"

if [ -z $number ] ; then
	echo "You didn't enter anything acceptable, wtf?" >&2; return 1
fi

if [ "${number%${number#?}}" = "-" ] ; then # is first char - sign?
testvalue="${number#?}"
else
	testvalue="$number"
fi

nodigits="$(echo $testvalue | sed 's/[[:digit:]]//g')"

if [ ! -z $nodigits ] ; then
	echo "Invalid number format dummy! Only digits, nuffing else" >&2
	return 1
fi

if [ ! -z $min ] ; then
	if [ "$number" -lt "$min" ] ; then
		echo "Value too small: smallest acceptable is $min" >&2
		return 1
	fi
fi
if [ ! -z $max ] ; then
	if [ "$number" -gt "$max" ] ; then
		echo "Value too high; largest acceptable is $max" >&2
		return 1
	fi
fi

return 0
}


# validfloat -- Tests whether a number is a valid floating-point
# value. Note that this script cannot accept scientific (1.304e5)
# notation

# to test wether an entered value is a valid floating-point number,
# we need to split the value at the decimal point. We then test the
# first part to see if its a valud integer, then test the second
# part to see if it's a valud >=0 integer, so -30.5 is valud but
# -30.-8 isn't.

validfloat()
{
	fvalue="$1"
  	
	if [ ! -z $(echo $fvalue | sed 's/[^.]//g') ] ; then
		
		decimalPart="$(echo $fvalue | cut -d. -f1)"
		fractionalPart="$(echo $fvalue | cut -d. -f2)"

		if [ ! -z $decimalPart ] ; then
			if ! validint "$decimalPart" "" "" ; then
				return 1
			fi
		fi

		if [ "${fractionalPart%${fractionalPart#?}}" = "-" ] ; then
			echo "Invalid floating-point number: '-' not allowed \
				after decimal point" >&2 ; return 1
		fi

		if [ "$fractionalPart" != "" ] ; then
			if ! validint "$fractionalPart" "0" "" ; then
				return 1
			fi
		fi

		if [ "$decimalPart" = "-" -o -z "$decimalPart" ] ; then
			if [ -z $fractionalPart ] ; then
				echo "Invalid floating-point format." >&2 ; return 1
			fi
		fi
	else
		if [ "$fvalue" = "-" ] ; then
			echo "Invalud floating-point format." >&2 ; return 1
		fi
		if  ! validint "$fvalue" "" "" ; then
			return 1
		fi
	fi
	return 0
}


exceedsDaysInMonth()
{
	# given a month name, return 0 if the specified day value is less
	# than or equal to the max days in the month; 1 otherwise

	case $(echo $1 | tr '[:upper:]' '[:lower:]') in
		jan* ) days=31		;;	feb* ) days=28		;;
		mar* ) days=31		;;	apr* ) days=30		;;
		may* ) days=31		;;	jun* ) days=30		;;
		jul* ) days=31		;;	aug* ) days=31		;;
		sep* ) days=30		;;	oct* ) days=31		;;
		nov* ) days=30		;;	dec* ) days=31		;;
		* ) echo "$0: Unknown month name $1" >&2 ; exit 1
	esac

if [ $2 -lt 1 -o $2 -gt $days ] ; then
	return 1
else
	return 0
fi # day number is valid
}

isLeapYear()
{
year=$1
	# returns 0 if a leap year, 1 if not... duh
	# years not divisible by 4 are NOT leapyears
	if [ "$((year % 4))" -ne 0 ] ; then
		return 1		# nope
	# years divisible by 4 and by 400 ARE
	elif [ "$((year % 400))" -eq 0 ] ; then
		return 0 # yepper
	# years divisible by 4, not divisible by 400, and divisble by 100
	# are NOT
	elif [ "$((year % 100))" -eq 0 ] ; then
		return 1 # nope
	else
		return 0
	fi
}

echon() { echo "$*" |tr -d '\n'; }


scriptbc() {
if [ $1 = "-p" ] ; then
	precision=$2
	shift 2
else
	precision=2
fi

bc -q <<EOF
scale=$precision
$*
quit
EOF
}



initializeANSI()
{
	esc="\033"
# foreground colors
	blackf="${esc}[30m"; redf="${esc}[31m"; greenf="${esc}[32m"
	yellowf="${esc}[33m"; bluef="${esc}[34"; purplef="${esc}[35m"
	cyanf="${esc}[36m"; whitef="${esc}[37m"
# backgound colors
	blackb="${esc}[40m"; redb="${esc}[41m"; greenb="${esc}[42m"
	yellowb="${esc}[43m"; blueb="${esc}[44m"; purpleb="${esc}[45m"
	cyanb="${esc}[46m"; whiteb="${esc}[47m"
# other random shit
	boldon="${esc}[1m"; boldoff="${esc}[22m"
	italicson="${esc}[3m"; italicsoff="${esc}[23"
	ulon="${esc}[4m"; uloff="${esc}[24m"
	invon="${esc}[7m" invoff="${esc}[27m"

reset="${esc}[0m"
}

