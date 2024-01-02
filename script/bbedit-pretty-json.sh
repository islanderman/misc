#!/usr/bin/env python3
import sys, json
print(json.dumps(json.load(sys.stdin), indent=2))
