#!/bin/bash

# Simple rebuild script, I will modify it in the future...

cd modified_ramdisk

find . | cpio --create --format='newc' > ../tmp/E2303_26.1.A.2.99.ramdisk.cpio

cd ..

gzip -f tmp/E2303_26.1.A.2.99.ramdisk.cpio

./bin/mkbootimg --base 0x00000000 --kernel tmp/E2303_26.1.A.2.99.zImage --ramdisk tmp/E2303_26.1.A.2.99.ramdisk.cpio.gz --ramdisk_offset 0x02000000 --dt tmp/E2303_26.1.A.2.99.qcdt.img --tags_offset 0x01E00000 --pagesize 2048 --cmdline "`cat tmp/E2303_26.1.A.2.99.boot.cmd`" --output out/M4boot.img
