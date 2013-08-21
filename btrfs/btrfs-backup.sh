#!/bin/bash
################################
# Incremental Backups with BTRFS
# btrfs with send/receive patch
# compiled from 
# git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
# Date: 21.08.2013
# Author: David Kofler
################################
# btrfs volume path
DATAPATH=/mnt/data
# Data subvolume which will be backuped
SUBVOL=home
# backup path where snapshots will be stored
BACKUPDIR=/mnt/backup/$SUBVOL

if [ -d $DATAPATH/BACKUP -a -d $BACKUPDIR/BACKUP ] 
then
	echo "Create incremental backup..."
	# create incremental snapshot
	./btrfs sub snap -r $DATAPATH/$SUBVOL $DATAPATH/BACKUP-new
	sync
	./btrfs send -p $DATAPATH/BACKUP $DATAPATH/BACKUP-new | ./btrfs receive $BACKUPDIR
	# save snapshot for history
	./btrfs sub snap -r $BACKUPDIR/BACKUP $BACKUPDIR.$(date +%Y-%m-%d-%H-%M)
	# delete old snapshot and replace it with backup-new
	./btrfs sub del $DATAPATH/BACKUP
	mv $DATAPATH/BACKUP-new $DATAPATH/BACKUP
	./btrfs sub del $BACKUPDIR/BACKUP
	mv $BACKUPDIR/BACKUP-new $BACKUPDIR/BACKUP
else
	echo "Create first backup..."
#	./btrfs sub del $DATAPATH/BACKUP
#	./btrfs sub del $BACKUPDIR/BACKUP
	./btrfs sub snap -r $DATAPATH/$SUBVOL $DATAPATH/BACKUP
	sync
	./btrfs send $DATAPATH/BACKUP  | ./btrfs receive $BACKUPDIR 
fi
