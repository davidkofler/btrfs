#!/bin/bash
# test disk performance with btrfs compression options
# none
partition=/dev/sda5
mountpoint=/mnt
configdir=/root/btrfs-test
mount $partition $mountpoint
phoronix-test-suite install dbench iozone fs-mark fio compilebench
cd $mountpoint
phoronix-test-suite run dbench < $configdir/dbench1
phoronix-test-suite run iozone < $configdir/iozone1
phoronix-test-suite run fs-mark < $configdir/fs-mark1
phoronix-test-suite run fio < $configdir/fio1
phoronix-test-suite run compilebench < $configdir/compilebench1
echo "test btrfs successfull"
# lzo
cd $configdir
umount $mountpoint
mount -o compress=lzo $partition $mountpoint
cd $mountpoint
phoronix-test-suite run dbench < $configdir/dbench2
phoronix-test-suite run iozone < $configdir/iozone2
phoronix-test-suite run fs-mark < $configdir/fs-mark2
phoronix-test-suite run fio < $configdir/fio2
phoronix-test-suite run compilebench < $configdir/compilebench2
echo "test btrfs-lzo successful"
# zlib
cd $configdir
umount $mountpoint
mount -o compress=zlib $partition $mountpoint
cd $mountpoint
phoronix-test-suite run dbench < $configdir/dbench3
phoronix-test-suite run iozone < $configdir/iozone3
phoronix-test-suite run fs-mark < $configdir/fs-mark3
phoronix-test-suite run fio < $configdir/fio3
phoronix-test-suite run compilebench < $configdir/compilebench3
echo "test btrfs-zlib successful"
cd $configdir
umount $partition
