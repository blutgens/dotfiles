#!/bin/sh
TODAY=$(date +%d-%b-%Y)
BACKUPDIR="backup-${TODAY}"
DOTFILES=".bashrc .bash_profile .vimrc .kshrc .profile .exrc .xsession \
					.Xresources .screenrc .perltidyrc .smallprof .lftprc"
DOTDIRS=".irssi .vim .purple .lftp .ssh .gnupg .fluxbox .ion3 .public_html"
DIRS="bin Documents scripts perl spyux Pictures"
if [ -d "/media/maxt0r" ]; then
    cd /media/maxt0r
else
    cd /tmp
fi

echo "pre-cleaning destination"
[ -f $BACKUPDIR.tar.bz2 ] && rm ${BACKUPDIR}.tar.bz2
[ -d ${BACKUPDIR} ] && rm -rf ${BACKUPDIR}
mkdir -p ${BACKUPDIR}
echo -n "backing up: "
echo -n "dotfiles "
for file in ${DOTFILES} ; do
	[ -f ${HOME}/$file ] && cp ${HOME}/$file ${BACKUPDIR}/
done

echo -n "dotdirs "
for dir in ${DOTDIRS} ${DIRS} ; do
	[ -d ${HOME}/$dir ] && cp -ax ${HOME}/$dir ${BACKUPDIR}/
done

echo ; echo -n "creating tarball ${BACKUPDIR}.tar.bz2 "
tar -cjf ${BACKUPDIR}.tar.bz2 ${BACKUPDIR}
if [ $? = "0" ]; then
	echo "[OK]"
	rm -rf ${BACKUPDIR}
fi
