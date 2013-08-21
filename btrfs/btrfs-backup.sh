#!/bin/bash
# Incremental Backups with BTRFS
DATADIR=/mnt/home
BACKUPDIR=/mnt/backup/home

# create bootstrap backup
if [ -d $DATADIR/BACKUP || -d $BACKUPDIR/BACKUP ] 
then
	./btrfs sub del $DATADIR/BACKUP
	./btrfs sub del $BACKUPDIR/BACKUP
	./btrfs sub snap -r $DATADIR $DATADIR/BACKUP
	sync
	./btrfs send $DATADIR/BACKUP  | ./btrfs receive $BACKUPDIR

else 


# create incremental snapshot
./btrfs sub snap -r $DATADIR $DATADIR/BACKUP-new
sync
./btrfs send -p $DATADIR/BACKUP $DATADIR/BACKUP-new | ./btrfs receive $BACKUPDIR

# delete old snapshots
./btrfs sub del $DATADIR/BACKUP
mv $DATADIR/BACKUP-new $DATADIR/BACKUP
./btrfs sub del $BACKUPDIR/BACKUP
mv $BACKUPDIR/BACKUP-new $BACKUPDIR/BACKUP
./btrfs sub snap -r $BACKUPDIR/BACKUP $BACKUPDIR.$(date +%Y-%m-%d)
fi