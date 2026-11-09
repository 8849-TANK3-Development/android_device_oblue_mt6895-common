#!/usr/bin/env python3
"""把裸 dtb 打包成 MTK 启动链能识别的 dtb.img（Android dt_table, 大端）。

原厂 vendor_boot 里解出来的 dtb.img 不是裸 FDT 拼接，而是：
    magic 0xd7b7ab1e(BE) | total_size | header_size=32 | entry_size=32
    count | entries_offset=32 | page_size=2048 | version
    entry[0]: dtb_size | dtb_offset | id | rev | custom[16]
所以 AOSP 里 BOARD_PREBUILT_DTBIMAGE_DIR 那条 `cat *.dtb > dtb.img` 出来的
东西和原厂不是一个格式。

用法: mkdtbimg.py out.img a.dtb [b.dtb ...] [--page-size 2048] [--id 0] [--rev 0]
"""
import struct, sys, os

MAGIC = 0xd7b7ab1e          # 0xd7b7ab1e 是 dt_table 双端合法魔数
HDR = 32
ENT = 32


def build(dtbs, page_size=2048, dtb_id=0, dtb_rev=0):
    n = len(dtbs)
    off = HDR + n * ENT
    body = off
    entries = []
    for data in dtbs:
        entries.append((len(data), body, dtb_id, dtb_rev))
        body += len(data)          # 原厂不按 page 补齐, total_size 就是实际字节数
    total = body
    out = struct.pack(">8I", MAGIC, total, HDR, ENT, n, HDR, page_size, 0)
    for size, start, i, r in entries:
        out += struct.pack(">4I", size, start, i, r) + b"\x00" * 16
    cur = off
    for data in dtbs:
        assert len(out) == cur, (len(out), cur)
        out += data
        cur = len(out)
    return out


def main(argv):
    page, dtb_id, rev = 2048, 0, 0
    args = []
    it = iter(argv)
    for a in it:
        if a == "--page-size":
            page = int(next(it)); continue
        if a == "--id":
            dtb_id = int(next(it)); continue
        if a == "--rev":
            rev = int(next(it)); continue
        args.append(a)
    if len(args) < 2:
        print(__doc__); return 2
    out_path, srcs = args[0], args[1:]
    blob = build([open(p, "rb").read() for p in srcs], page, dtb_id, rev)
    open(out_path, "wb").write(blob)
    print(f"{out_path}: {len(blob)} bytes, {len(srcs)} dtb, page {page}")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
