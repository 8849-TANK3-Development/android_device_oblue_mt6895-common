# Common device tree for OBLUE MT6895 devices.
## OBLUE is the creator and developer of Unihertz and 8849
```
#
# Copyright (C) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#
```

## Device tree images

The DTB and DTBO sources live in the kernel tree, so these are built there
and only the resulting images are packaged here:

| file | source | built with |
| --- | --- | --- |
| `dtb.img` | `arch/arm64/boot/dts/oblue/mediatek/mt6895.dts` | `dtb-$(CONFIG_ARCH_MEDIATEK)` |
| `dtbo.img` | `arch/arm64/boot/dts/oblue/mediatek/tank3.dts` | `dtbo-$(MACH_TANK3)` |

Both make variables have to be enabled in the kernel config; `tank3_defconfig`
is `gki_defconfig` plus `CONFIG_ARCH_MEDIATEK=y` and `CONFIG_MACH_TANK3=y`.

### dtb.img is a dt_table, not a bare FDT

`BOARD_PREBUILT_DTBIMAGE_DIR` in `build/make/core/Makefile` does
`cat $^ > $@`, which produces a bare concatenation of FDTs. The factory
`dtb.img` extracted from `vendor_boot` is a different container:

```
magic 0xd7b7ab1e (big endian)   total_size 318837
header_size 32                  entry_size 32
dt_entry_count 1                dt_entries_offset 32
page_size 2048                  version 0
entry[0]: dtb_size 318773, dtb_offset 64, id 0, rev 0
```

To keep the factory layout, wrap the compiled dtb:

```
python3 tools/mkdtbimg.py dtb.img dtbs/mt6895.dtb
```

`mkdtbimg.py` reproduces the factory container byte for byte (verified by
unpacking the factory image, repacking it and comparing with `cmp`).

### dtbo.img is a bare overlay

The factory `dtbo` partition starts with `d00dfeed`, i.e. it is a plain
overlay FDT, so `tank3.dtbo` can be shipped as `dtbo.img` unmodified.

`BOARD_DTBOIMG_PARTITION_SIZE` has to match the real `dtbo` partition, the
AVB hash footer is padded to that value.
