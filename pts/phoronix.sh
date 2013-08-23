#!/bin/bash
# test disk speed with btrfs compression options
# none
partition=/dev/sda5
mountpoint=/mnt
mount $partition $mountpoint
cd $mountpoint
phoronix-test-suite run dbench < /root/btrfs-test/dbench1
phoronix-test-suite run iozone < /root/btrfs-test/iozone1
phoronix-test-suite run fs-mark < /root/btrfs-test/fs-mark1
phoronix-test-suite run fio < /root/btrfs-test/fio1
phoronix-test-suite run compilebench < /root/btrfs-test/compilebench1
echo "test btrfs successfull"
# lzo
cd /root/btrfs-test
umount $mountpoint
mount -o compress=lzo $partition $mountpoint
cd $mountpoint
phoronix-test-suite run dbench < /root/btrfs-test/dbench2
phoronix-test-suite run iozone < /root/btrfs-test/iozone2
phoronix-test-suite run fs-mark < /root/btrfs-test/fs-mark2
phoronix-test-suite run fio < /root/btrfs-test/fio2
phoronix-test-suite run compilebench < /root/btrfs-test/compilebench2
echo "test btrfs-lzo successful"
# zlib
cd /root/btrfs-test
umount $mountpoint
mount -o compress=zlib $partition $mountpoint
cd $mountpoint
phoronix-test-suite run dbench < /root/btrfs-test/dbench3
phoronix-test-suite run iozone < /root/btrfs-test/iozone3
phoronix-test-suite run fs-mark < /root/btrfs-test/fs-mark3
phoronix-test-suite run fio < /root/btrfs-test/fio3
phoronix-test-suite run compilebench < /root/btrfs-test/compilebench3
echo "test btrfs-zlib successful"
cd /root/btrfs-test
umount $partition
