# iobench
Simple shell script for disk benchmarks

**Requires root privileges!**

Usage:

```sh
./iobench.sh --dir /some/directory --megabytes 4096 [--sync] [--skipwrite] [--skipread]
```

Optional parameters:

- `--sync`: Force sync of benchmark io
- `--skipwrite`: Skip the write benchmark
- `--skipread`: Skip the read benchmark

Defaults:

- `--dir` -> Current directory
- `--megabytes` -> 1024

## Example

Output of `./iobench.sh --dir /zpoolprime/backup/ --megabytes 16384 --sync`:

```
Target directory: /zpoolprime/backup/
Testfile size: 16384 x 1 Megabyte

1. Write benchmark without cache
17179869184 bytes (17 GB, 16 GiB) copied, 4.89196 s, 3.5 GB/s

2. Write benchmark with cache
17179869184 bytes (17 GB, 16 GiB) copied, 4.92733 s, 3.5 GB/s

3. Read benchmark with droped cache
17179869184 bytes (17 GB, 16 GiB) copied, 1.44579 s, 11.9 GB/s

4. Read benchmark without cache drop

Start 1 of 5...
17179869184 bytes (17 GB, 16 GiB) copied, 1.34675 s, 12.8 GB/s

Start 2 of 5...
17179869184 bytes (17 GB, 16 GiB) copied, 1.36288 s, 12.6 GB/s

Start 3 of 5...
17179869184 bytes (17 GB, 16 GiB) copied, 1.42878 s, 12.0 GB/s

Start 4 of 5...
17179869184 bytes (17 GB, 16 GiB) copied, 1.37079 s, 12.5 GB/s

Start 5 of 5...
17179869184 bytes (17 GB, 16 GiB) copied, 1.35658 s, 12.7 GB/s

Done.
```
