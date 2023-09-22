#!/usr/bin/env python

import sys
import hashlib

def main(args):
    data = open(args[1], "rb").read()
    h = hashlib.sha256()
    h.update(data)
    with open(args[2], "wt") as f:
        print(h.hexdigest(), file=f)
    return 0

if __name__ == '__main__':
    sys.exit(main(sys.argv))
