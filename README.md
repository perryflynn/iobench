# iobench
Simple shell script for disk benchmarks

**Requires root privileges!**

Usage:

```sh
./iobench.sh --dir /some/directory --megabytes 4096 [--sync] [--skipwrite] [--skipread]
```

Defaults:

- `--dir` -> Current directory
- `--megabytes` -> 1024
