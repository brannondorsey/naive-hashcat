#!/bin/bash

HASH_FILE="${HASH_FILE:-hashcat-3.6.0/example0.hash}"
POT_FILE="${POT_FILE:-hashcat.pot}"
HASH_TYPE="${HASH_TYPE:-0}"
# WEIGHT="${WEIGHT:-"medium"}" # light, medium, heavy

if [ $(uname -m) == 'x86_64' ]; then
	HASHCAT="./hashcat-3.6.0/hashcat64.bin"
else
	HASHCAT="./hashcat-3.6.0/hashcat32.bin"
fi

# LIGHT
# DICTIONARY ATTACK-----------------------------------------------------------------------
# begin with a _very_ simple and naive dictionary attack. This is blazing fast and 
# I've seen it crack ~20% of hashes
"$HASHCAT" -m "$HASH_TYPE" -a 0 "$HASH_FILE" dicts/rockyou.txt --potfile-path "$POT_FILE" --opencl-devices 2 

# DICTIONARY ATTACK WITH RULES------------------------------------------------------------
# now lets move on to a rule based attack, d3ad0ne.rule is a great one to start with
"$HASHCAT" -m "$HASH_TYPE" -a 0 "$HASH_FILE" dicts/rockyou.txt -r hashcat-3.6.0/rules/d3ad0ne.rule --potfile-path "$POT_FILE" --opencl-devices 2

# rockyou is pretty good, and not too slow
"$HASHCAT" -m "$HASH_TYPE" -a 0 "$HASH_FILE" dicts/rockyou.txt -r hashcat-3.6.0/rules/rockyou-30000.rule --potfile-path "$POT_FILE" --opencl-devices 2


# MEDIUM
# dive is a great rule file, but it takes a bit longer to run, so we will run it after d3ad0ne and rockyou
"$HASHCAT" -m "$HASH_TYPE" -a 0 "$HASH_FILE" dicts/rockyou.txt -r hashcat-3.6.0/rules/dive.rule --potfile-path "$POT_FILE" --opencl-devices 2

# HEAVY
# MASK ATTACK (BRUTE-FORCE)---------------------------------------------------------------
"$HASHCAT" -m "$HASH_TYPE" -a 3 "$HASH_FILE" hashcat-3.6.0/masks/rockyou-1-60.hcmask --potfile-path "$POT_FILE" --opencl-devices 2

# COMBINATION ATTACK---------------------------------------------------------------------- 
# this one can take 12+ hours, don't use it by default
# "$HASHCAT" -m "$HASH_TYPE" -a 1 "$HASH_FILE" dicts/rockyou.txt dicts/rockyou.txt --potfile-path "POT_FILE" --opencl-devices 2 

# Session..........: hashcat
# Status...........: Exhausted
# Hash.Type........: MD5
# Hash.Target......: hashcat-3.6.0/example0.hash
# Time.Started.....: Sun Jul  9 22:28:27 2017 (12 hours, 24 mins)
# Time.Estimated...: Mon Jul 10 10:53:06 2017 (6 secs)
# Guess.Base.......: File (dicts/rockyou.txt), Left Side
# Guess.Mod........: File (dicts/rockyou.txt), Right Side
# Speed.Dev.#2.....:  4490.7 MH/s (6.68ms)
# Recovered........: 4120/6494 (63.44%) Digests, 0/1 (0.00%) Salts
# Recovered/Time...: CUR:0,13,N/A AVG:3,182,4372 (Min,Hour,Day)
# Progress.........: 205701367493846/205730140143616 (99.99%)
# Rejected.........: 2006/205701367493846 (0.00%)
# Restore.Point....: 14343296/14343296 (100.00%)
# Candidates.#2....: $HEX[3033323639346120627574746572666c79] -> $HEX[042a0337c2a156616d6f732103042a0337c2a156616d6f732103]
# HWMon.Dev.#2.....: Temp: 77c Fan: 85% Util: 95% Core:1911MHz Mem:3802MHz Bus:8

# Started: Sun Jul  9 22:28:27 2017
# Stopped: Mon Jul 10 10:53:01 2017