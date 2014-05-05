alias l='ls -alF'
alias ll='ls -alF'
alias la='ls -Fa'
alias ld='ls -al -d * | egrep "^d"' # only subdirectories
alias lt='ls -alt | head -20' # recently changed files
alias watchtcp='watch -n 1 "sudo netstat -tpanl | grep ESTABLISHED"'
alias rpmqa='rpm -qa --queryformat "%{NAME}-%{VERSION}.%{RELEASE} (%{ARCH})\n"'
export TODAY=$(date +%d-%b-%Y)
alias unix2dos="perl -i -pe 's/\r//g'"
alias dos2unix="perl -i -pe 's/\n/\r\n/'"
alias ssh="ssh -X -A -t"
alias rsync="rsync -av --stats --progress"
alias myip="links -dump http://www.formyip.com/ | grep \"Your IP\" | \
    sed 's/^[ \t]*//'"
if [ $(uname) == "Linux" ] ; then
    complete -cf sudo
    alias du="du -sch"
    alias ls="ls --color"
    alias mv="mv -v"
    alias cp="cp -v"
    alias ln="ln -v"
    alias tar="tar -v"
    alias untar="tar -xvf"
    alias ll="ls -lh"
    alias la="ls -a"
    alias lla="ls -lah"
    alias rm="rm -v"
    alias more='less'
    alias grep='grep --color'
elif [ $(uname) == "SunOS" ] ; then
    alias ls="ls -F"
fi
alias cd..='cd ..'
alias servethis="python -c 'import SimpleHTTPServer; SimpleHTTPServer.test()'"
alias change_date='date +"%a %b %d %Y"'
alias rot13='perl -pe "y/n-za-mN-ZA-M/a-zA-Z/"'
alias scramble='perl -Mlocale -pe "s|\B\w+\B|join q(),sort{rand 2}$&=~/./g|ge"'
alias base64enc='perl -MMIME::Base64 -e "print encode_base64(join(q(),<>),q())"'
alias base64dec='perl -MMIME::Base64 -e "print decode_base64(join(q(),<>))"'
alias pmver="perl -le '\$m = shift; eval qq(require \$m) or die qq(module \"\$m\" is not installed\\n); print \$m->VERSION'"



alias nwm-res="sudo restart network-manager"
# handy du
alias dux='du -sk ./* | sort -n | awk '\''BEGIN{ pref[1]="K"; pref[2]="M"; pref[3]="G";} { total = total + $1; x = $1; y = 1; while( x > 1024 ) { x = (x + 1023)/1024; y++; } printf("%g%s\t%s\n",int(x*10)/10,pref[y],$2); } END { y = 1; while( total > 1024 ) { total = (total + 1023)/1024; y++; } printf("Total: %g%s\n",int(total*10)/10,pref[y]); }'\'''

# vim:set ft=sh:
