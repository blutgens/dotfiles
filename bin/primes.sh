#!/bin/bash
#===============================================================================
#
#          FILE:  primes.sh
# 
#         USAGE:  ./primes.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Ben Lutgens (), blutgens@mmm.com blutgens@gmail.com
#       COMPANY:  3M Unix Production Support
#       VERSION:  1.0
#       CREATED:  02/18/2008 01:46:00 PM CST
#      REVISION:  ---
#===============================================================================

#!/bin/bash
# primes.sh: Generate prime numbers, without using arrays.
# Script contributed by Stephane Chazelas.

#  This does *not* use the classic "Sieve of Eratosthenes" algorithm,
#+ but instead uses the more intuitive method of testing each candidate number
#+ for factors (divisors), using the "%" modulo operator.


LIMIT=10000                    # Primes 2 - 1000

Primes()
{
 (( n = $1 + 1 ))             # Bump to next integer.
 shift                        # Next parameter in list.
#  echo "_n=$n i=$i_"
 
 if (( n == LIMIT ))
 then echo $*
 return
 fi

 for i; do                    # "i" gets set to "@", previous values of $n.
#   echo "-n=$n i=$i-"
   (( i * i > n )) && break   # Optimization.
   (( n % i )) && continue    # Sift out non-primes using modulo operator.
   Primes $n $@               # Recursion inside loop.
   return
   done

   Primes $n $@ $n            # Recursion outside loop.
                              # Successively accumulate positional parameters.
                              # "$@" is the accumulating list of primes.
}

Primes 1

exit 0

#  Uncomment lines 16 and 24 to help figure out what is going on.

#  Compare the speed of this algorithm for generating primes
#+ with the Sieve of Eratosthenes (ex68.sh).

#  Exercise: Rewrite this script without recursion, for faster execution.
