#!/bin/bash

HASH_FILE="${HASH_FILE:-hashcat-3.6.0/example0.hash}"
POT_FILE="${POT_FILE:-hashcat.pot}"
HASH_TYPE="${HASH_TYPE:-0}"
# WEIGHT="${WEIGHT:-"medium"}" # light, medium, heavy

# check already installed
if [ -x "$(command -v hashcat)" ] ; then
	HASHCAT="hashcat"
# check OSX
elif [ "$(uname)" == 'Darwin' ] ; then
	if [ -f hashcat-src/hashcat ] ; then
		HASHCAT="./hashcat-src/hashcat"
	else
		echo "You are running naive-hashcat on a MacOS/OSX machine but have not yet built the hashcat binary."
		echo "Please run ./build-hashcat-osx.sh and try again."
		exit 1
	fi
# check Linux
elif [ "$(uname)" == 'Linux' ] ; then
	if [ $(uname -m) == 'x86_64' ]; then
		HASHCAT="./hashcat-3.6.0/hashcat64.bin"
	else
		HASHCAT="./hashcat-3.6.0/hashcat32.bin"
	fi
# check Windows
elif [ "$(uname)" == 'MINGW64_NT-10.0' ] ; then
	if [ $(uname -m) == 'x86_64' ]; then
		HASHCAT="./hashcat-3.6.0/hashcat64.exe"
	else
		HASHCAT="./hashcat-3.6.0/hashcat32.exe"
	fi
fi

echo "$HASHCAT"
exit
# LIGHT
# DICTIONARY ATTACK-----------------------------------------------------------------------
# begin with a _very_ simple and naive dictionary attack. This is blazing fast and
# I've seen it crack ~20% of hashes
"$HASHCAT" -m "$HASH_TYPE" -a 0 "$HASH_FILE" dicts/rockyou.txt --potfile-path "$POT_FILE"

# DICTIONARY ATTACK WITH RULES------------------------------------------------------------
# now lets move on to a rule based attack, d3ad0ne.rule is a great one to start with
"$HASHCAT" -m "$HASH_TYPE" -a 0 "$HASH_FILE" dicts/rockyou.txt -r hashcat-3.6.0/rules/d3ad0ne.rule --potfile-path "$POT_FILE"

# rockyou is pretty good, and not too slow
"$HASHCAT" -m "$HASH_TYPE" -a 0 "$HASH_FILE" dicts/rockyou.txt -r hashcat-3.6.0/rules/rockyou-30000.rule --potfile-path "$POT_FILE"


# MEDIUM
# dive is a great rule file, but it takes a bit longer to run, so we will run it after d3ad0ne and rockyou
"$HASHCAT" -m "$HASH_TYPE" -a 0 "$HASH_FILE" dicts/rockyou.txt -r hashcat-3.6.0/rules/dive.rule --potfile-path "$POT_FILE"

# HEAVY
# MASK ATTACK (BRUTE-FORCE)---------------------------------------------------------------
"$HASHCAT" -m "$HASH_TYPE" -a 3 "$HASH_FILE" hashcat-3.6.0/masks/rockyou-1-60.hcmask --potfile-path "$POT_FILE"

# COMBINATION ATTACK----------------------------------------------------------------------
# this one can take 12+ hours, don't use it by default
# "$HASHCAT" -m "$HASH_TYPE" -a 1 "$HASH_FILE" dicts/rockyou.txt dicts/rockyou.txt --potfile-path "POT_FILE"
