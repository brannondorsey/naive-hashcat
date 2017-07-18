# Naive Hashcat

Crack password hashes without the fuss. Naive hashcat is a plug-and-play script that is pre-configured with naive, emperically-tested, "good enough" parameters/attack types. Run hashcat attacks using `./naive-hashcat.sh` without having to know what is going on "under the hood".

__DISCLAIMER: This software is for educational purposes only. This software should not be used for illegal activity. The author is not responsible for its use. Don't be a dick.__

## Getting started

```bash
git clone https://github.com/brannondorsey/naive-hashcat
cd naive-hashcat

# download the 134MB rockyou dictionary file
curl -L -o dicts/rockyou.txt https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt

# cracks md5 hashes in hashcat-3.6.0/example0.hash by default
./naive-hashcat.sh
```

## What it do?

`./naive-hashcat.sh` assumes that you have hashed passwords that you would like to know the plaintext equivalent of. Likely, you've come across a text file that contains leaked accounts/emails/usernames matched with a cryptographic hash of a corresponding password. Esentially something that looks like:

```
neli_dayanti@yahoo.co.id:01e870ebb01160f881ffaa6764acd01f
hastomoanggi@gmail.com:f15a413c1835014679a286ee84a212d4
yogipandu86@gmail.com:e4fdf3291654751def4e6816fddce608
fadlilamegy1@gmail.com:8ebd79c9b13240ab3767a64b4faae7be
ridho6kr@gmail.com:33816712db4f3913ee967469fe7ee982
yogaardamanta17@gmail.com:3e46fb7125915cdf34df21342004f82f
yogahadikusuma@gmail.com:bf0e20a03a01ae215deb9b36e173cd9a
```

(⬆⬆⬆ not real hashes btw, don't get any ideas...)

If you don't have such a file, [pastebin.com](http://pastebin.com) is a popular text paste site that black-hat hackers 💙 love 💙 posting leaked account credentials to. And lucky 4 u, they have a [trending feature](https://pastebin.com/trends) that makes "interesting content" bubble to the top. If you can't find leaked creds atm, I've written a [tool that archives trending pastes](https://github.com/brannondorsey/pastebin-mirror) each hour.

Once you've got some hashes, save them to a file with one hash per line. For example, `hashes.txt`:

```
01e870ebb01160f881ffaa6764acd01f
f15a413c1835014679a286ee84a212d4
e4fdf3291654751def4e6816fddce608
8ebd79c9b13240ab3767a64b4faae7be
33816712db4f3913ee967469fe7ee982
3e46fb7125915cdf34df21342004f82f
bf0e20a03a01ae215deb9b36e173cd9a
```

To crack your hashes, pass this file as `HASH_FILE=hashes.txt` to the command below.

## Usage

`naive-hashcat.sh` takes, at most, three parameters. All parameters are expressed using unix environment variables. The command below shows the default values set for each of the configurable environment variables that `naive-hashcat.sh` uses:

```bash
HASH_FILE=hashcat-3.6.0/examples0.hash POT_FILE=hashcat.pot HASH_MODE=0 ./naive-hashcat.sh
```

- `HASH_FILE` is a text file with one hash per line. These are the password hashes to be cracked.
- `POT_FILE` is the name of the output file that `hashcat` will write cracked password hashes to.
- `HASH_TYPE` is the hash-type code. It describes the type of hash to be cracked. `0` is [md5](https://en.wikipedia.org/wiki/MD5). See the [Hash types](#hash-types) section below for a full list of hash type codes.

## What naive-hashcat does

[`naive-hashcat.sh`](naive-hashcat.sh) includes a small variety of [dictionary](https://hashcat.net/wiki/doku.php?id=dictionary_attack), [combination](https://hashcat.net/wiki/doku.php?id=combinator_attack), [rule-based](https://hashcat.net/wiki/doku.php?id=rule_based_attack), and [mask](https://hashcat.net/wiki/doku.php?id=mask_attack) (brute-force) attacks. If that sounds overwhelming, don't worry about it! The point of naive hashcat is that you don't have to know how it works. In this case, ignorance is bliss! In fact, I barely know what I'm doing here. The attacks I chose for `naive-hashcat.sh` are very naive, one-size-kinda-fits-all solutions. If you are having trouble cracking your hashes, I suggest checking out the __awesome__ [hashcat wiki](https://hashcat.net/wiki/), and using the `hashcat` tool directly.

At the time of this writing, `naive-hashcat` cracks ~60% of the hashes in `examples0.hash`.

## Ok, I think its working... what do I do now?

So you've run `./naive-hashcat.sh` on your `HASH_FILE`, and you see some passwords printing to the screen. These `hash:password` pairs are saved to the `POT_FILE` (`hashcat.pot` by default). Now you need to match the hashes from the original file you... um... found (the with lines like `neli_dayanti@yahoo.co.id:01e870ebb01160f881ffaa6764acd01f`) to the `hash:password` pairs in your pot file.

Run `python match-creds.py --accounts original_file.txt --potfile hashcat.pot > creds.txt` to do just that! This tool matches usernames/emails in `original_file.txt` with their corresponding cracked passwords in `hashcat.pot` and prints `username:password`:

```
neli_dayanti@yahoo.co.id:Password1
hastomoanggi@gmail.com:Qwerty1234
yogipandu86@gmail.com:PleaseForHeavenSakeUseAPasswordManager
```

Congratulations, you just hacked the private passwords/account information of many poor souls. And because everyone still uses the same password for everything you likely have the "master" password to tons of accounts.

And remember
  1. use a [password manager](https://www.lastpass.com/)
  2. don't pwn people
  3. don't go to jail

🏴‍ Happy hacking ☠

P.S. `./naive-hashcat.sh` can take anywhere from a few minutes to a few hours to terminate depending on your hardware. It will constantly stream results to the `POT_FILE`, and you are free to use the contents of that file for further processing with `match-creds.py` before cracking is finished.

## GPU Cracking

Hashcat ships with OpenCL and runs on available GPU hardware automatically when available.

## Hash types

Below is a list of hash-type codes supported by hashcat. If you don't know the type of hash you have, you can use [`hashid`](https://github.com/psypanda/hashID) to try and identify it. Include the appropriate hash-type using the `HASH_TYPE` environment variable.

```
    #   | Name                                             | Category
  ======+==================================================+======================================
    900 | MD4                                              | Raw Hash
      0 | MD5                                              | Raw Hash
   5100 | Half MD5                                         | Raw Hash
    100 | SHA1                                             | Raw Hash
   1300 | SHA-224                                          | Raw Hash
   1400 | SHA-256                                          | Raw Hash
  10800 | SHA-384                                          | Raw Hash
   1700 | SHA-512                                          | Raw Hash
   5000 | SHA-3 (Keccak)                                   | Raw Hash
    600 | BLAKE2b-512                                      | Raw Hash
  10100 | SipHash                                          | Raw Hash
   6000 | RIPEMD-160                                       | Raw Hash
   6100 | Whirlpool                                        | Raw Hash
   6900 | GOST R 34.11-94                                  | Raw Hash
  11700 | GOST R 34.11-2012 (Streebog) 256-bit             | Raw Hash
  11800 | GOST R 34.11-2012 (Streebog) 512-bit             | Raw Hash
     10 | md5($pass.$salt)                                 | Raw Hash, Salted and/or Iterated
     20 | md5($salt.$pass)                                 | Raw Hash, Salted and/or Iterated
     30 | md5(utf16le($pass).$salt)                        | Raw Hash, Salted and/or Iterated
     40 | md5($salt.utf16le($pass))                        | Raw Hash, Salted and/or Iterated
   3800 | md5($salt.$pass.$salt)                           | Raw Hash, Salted and/or Iterated
   3710 | md5($salt.md5($pass))                            | Raw Hash, Salted and/or Iterated
   4010 | md5($salt.md5($salt.$pass))                      | Raw Hash, Salted and/or Iterated
   4110 | md5($salt.md5($pass.$salt))                      | Raw Hash, Salted and/or Iterated
   2600 | md5(md5($pass))                                  | Raw Hash, Salted and/or Iterated
   3910 | md5(md5($pass).md5($salt))                       | Raw Hash, Salted and/or Iterated
   4300 | md5(strtoupper(md5($pass)))                      | Raw Hash, Salted and/or Iterated
   4400 | md5(sha1($pass))                                 | Raw Hash, Salted and/or Iterated
    110 | sha1($pass.$salt)                                | Raw Hash, Salted and/or Iterated
    120 | sha1($salt.$pass)                                | Raw Hash, Salted and/or Iterated
    130 | sha1(utf16le($pass).$salt)                       | Raw Hash, Salted and/or Iterated
    140 | sha1($salt.utf16le($pass))                       | Raw Hash, Salted and/or Iterated
   4500 | sha1(sha1($pass))                                | Raw Hash, Salted and/or Iterated
   4520 | sha1($salt.sha1($pass))                          | Raw Hash, Salted and/or Iterated
   4700 | sha1(md5($pass))                                 | Raw Hash, Salted and/or Iterated
   4900 | sha1($salt.$pass.$salt)                          | Raw Hash, Salted and/or Iterated
  14400 | sha1(CX)                                         | Raw Hash, Salted and/or Iterated
   1410 | sha256($pass.$salt)                              | Raw Hash, Salted and/or Iterated
   1420 | sha256($salt.$pass)                              | Raw Hash, Salted and/or Iterated
   1430 | sha256(utf16le($pass).$salt)                     | Raw Hash, Salted and/or Iterated
   1440 | sha256($salt.utf16le($pass))                     | Raw Hash, Salted and/or Iterated
   1710 | sha512($pass.$salt)                              | Raw Hash, Salted and/or Iterated
   1720 | sha512($salt.$pass)                              | Raw Hash, Salted and/or Iterated
   1730 | sha512(utf16le($pass).$salt)                     | Raw Hash, Salted and/or Iterated
   1740 | sha512($salt.utf16le($pass))                     | Raw Hash, Salted and/or Iterated
     50 | HMAC-MD5 (key = $pass)                           | Raw Hash, Authenticated
     60 | HMAC-MD5 (key = $salt)                           | Raw Hash, Authenticated
    150 | HMAC-SHA1 (key = $pass)                          | Raw Hash, Authenticated
    160 | HMAC-SHA1 (key = $salt)                          | Raw Hash, Authenticated
   1450 | HMAC-SHA256 (key = $pass)                        | Raw Hash, Authenticated
   1460 | HMAC-SHA256 (key = $salt)                        | Raw Hash, Authenticated
   1750 | HMAC-SHA512 (key = $pass)                        | Raw Hash, Authenticated
   1760 | HMAC-SHA512 (key = $salt)                        | Raw Hash, Authenticated
  14000 | DES (PT = $salt, key = $pass)                    | Raw Cipher, Known-Plaintext attack
  14100 | 3DES (PT = $salt, key = $pass)                   | Raw Cipher, Known-Plaintext attack
  14900 | Skip32 (PT = $salt, key = $pass)                 | Raw Cipher, Known-Plaintext attack
  15400 | ChaCha20                                         | Raw Cipher, Known-Plaintext attack
    400 | phpass                                           | Generic KDF
   8900 | scrypt                                           | Generic KDF
  11900 | PBKDF2-HMAC-MD5                                  | Generic KDF
  12000 | PBKDF2-HMAC-SHA1                                 | Generic KDF
  10900 | PBKDF2-HMAC-SHA256                               | Generic KDF
  12100 | PBKDF2-HMAC-SHA512                               | Generic KDF
     23 | Skype                                            | Network Protocols
   2500 | WPA/WPA2                                         | Network Protocols
   4800 | iSCSI CHAP authentication, MD5(CHAP)             | Network Protocols
   5300 | IKE-PSK MD5                                      | Network Protocols
   5400 | IKE-PSK SHA1                                     | Network Protocols
   5500 | NetNTLMv1                                        | Network Protocols
   5500 | NetNTLMv1+ESS                                    | Network Protocols
   5600 | NetNTLMv2                                        | Network Protocols
   7300 | IPMI2 RAKP HMAC-SHA1                             | Network Protocols
   7500 | Kerberos 5 AS-REQ Pre-Auth etype 23              | Network Protocols
   8300 | DNSSEC (NSEC3)                                   | Network Protocols
  10200 | CRAM-MD5                                         | Network Protocols
  11100 | PostgreSQL CRAM (MD5)                            | Network Protocols
  11200 | MySQL CRAM (SHA1)                                | Network Protocols
  11400 | SIP digest authentication (MD5)                  | Network Protocols
  13100 | Kerberos 5 TGS-REP etype 23                      | Network Protocols
    121 | SMF (Simple Machines Forum) > v1.1               | Forums, CMS, E-Commerce, Frameworks
    400 | phpBB3 (MD5)                                     | Forums, CMS, E-Commerce, Frameworks
   2611 | vBulletin < v3.8.5                               | Forums, CMS, E-Commerce, Frameworks
   2711 | vBulletin >= v3.8.5                              | Forums, CMS, E-Commerce, Frameworks
   2811 | MyBB 1.2+                                        | Forums, CMS, E-Commerce, Frameworks
   2811 | IPB2+ (Invision Power Board)                     | Forums, CMS, E-Commerce, Frameworks
   8400 | WBB3 (Woltlab Burning Board)                     | Forums, CMS, E-Commerce, Frameworks
     11 | Joomla < 2.5.18                                  | Forums, CMS, E-Commerce, Frameworks
    400 | Joomla >= 2.5.18 (MD5)                           | Forums, CMS, E-Commerce, Frameworks
    400 | WordPress (MD5)                                  | Forums, CMS, E-Commerce, Frameworks
   2612 | PHPS                                             | Forums, CMS, E-Commerce, Frameworks
   7900 | Drupal7                                          | Forums, CMS, E-Commerce, Frameworks
     21 | osCommerce                                       | Forums, CMS, E-Commerce, Frameworks
     21 | xt:Commerce                                      | Forums, CMS, E-Commerce, Frameworks
  11000 | PrestaShop                                       | Forums, CMS, E-Commerce, Frameworks
    124 | Django (SHA-1)                                   | Forums, CMS, E-Commerce, Frameworks
  10000 | Django (PBKDF2-SHA256)                           | Forums, CMS, E-Commerce, Frameworks
   3711 | MediaWiki B type                                 | Forums, CMS, E-Commerce, Frameworks
  13900 | OpenCart                                         | Forums, CMS, E-Commerce, Frameworks
   4521 | Redmine                                          | Forums, CMS, E-Commerce, Frameworks
   4522 | PunBB                                            | Forums, CMS, E-Commerce, Frameworks
  12001 | Atlassian (PBKDF2-HMAC-SHA1)                     | Forums, CMS, E-Commerce, Frameworks
     12 | PostgreSQL                                       | Database Server
    131 | MSSQL (2000)                                     | Database Server
    132 | MSSQL (2005)                                     | Database Server
   1731 | MSSQL (2012, 2014)                               | Database Server
    200 | MySQL323                                         | Database Server
    300 | MySQL4.1/MySQL5                                  | Database Server
   3100 | Oracle H: Type (Oracle 7+)                       | Database Server
    112 | Oracle S: Type (Oracle 11+)                      | Database Server
  12300 | Oracle T: Type (Oracle 12+)                      | Database Server
   8000 | Sybase ASE                                       | Database Server
    141 | Episerver 6.x < .NET 4                           | HTTP, SMTP, LDAP Server
   1441 | Episerver 6.x >= .NET 4                          | HTTP, SMTP, LDAP Server
   1600 | Apache $apr1$ MD5, md5apr1, MD5 (APR)            | HTTP, SMTP, LDAP Server
  12600 | ColdFusion 10+                                   | HTTP, SMTP, LDAP Server
   1421 | hMailServer                                      | HTTP, SMTP, LDAP Server
    101 | nsldap, SHA-1(Base64), Netscape LDAP SHA         | HTTP, SMTP, LDAP Server
    111 | nsldaps, SSHA-1(Base64), Netscape LDAP SSHA      | HTTP, SMTP, LDAP Server
   1411 | SSHA-256(Base64), LDAP {SSHA256}                 | HTTP, SMTP, LDAP Server
   1711 | SSHA-512(Base64), LDAP {SSHA512}                 | HTTP, SMTP, LDAP Server
  15000 | FileZilla Server >= 0.9.55                       | FTP Server
  11500 | CRC32                                            | Checksums
   3000 | LM                                               | Operating Systems
   1000 | NTLM                                             | Operating Systems
   1100 | Domain Cached Credentials (DCC), MS Cache        | Operating Systems
   2100 | Domain Cached Credentials 2 (DCC2), MS Cache 2   | Operating Systems
  15300 | DPAPI masterkey file v1 and v2                   | Operating Systems
  12800 | MS-AzureSync  PBKDF2-HMAC-SHA256                 | Operating Systems
   1500 | descrypt, DES (Unix), Traditional DES            | Operating Systems
  12400 | BSDi Crypt, Extended DES                         | Operating Systems
    500 | md5crypt, MD5 (Unix), Cisco-IOS $1$ (MD5)        | Operating Systems
   3200 | bcrypt $2*$, Blowfish (Unix)                     | Operating Systems
   7400 | sha256crypt $5$, SHA256 (Unix)                   | Operating Systems
   1800 | sha512crypt $6$, SHA512 (Unix)                   | Operating Systems
    122 | OSX v10.4, OSX v10.5, OSX v10.6                  | Operating Systems
   1722 | OSX v10.7                                        | Operating Systems
   7100 | OSX v10.8+ (PBKDF2-SHA512)                       | Operating Systems
   6300 | AIX {smd5}                                       | Operating Systems
   6700 | AIX {ssha1}                                      | Operating Systems
   6400 | AIX {ssha256}                                    | Operating Systems
   6500 | AIX {ssha512}                                    | Operating Systems
   2400 | Cisco-PIX MD5                                    | Operating Systems
   2410 | Cisco-ASA MD5                                    | Operating Systems
    500 | Cisco-IOS $1$ (MD5)                              | Operating Systems
   5700 | Cisco-IOS type 4 (SHA256)                        | Operating Systems
   9200 | Cisco-IOS $8$ (PBKDF2-SHA256)                    | Operating Systems
   9300 | Cisco-IOS $9$ (scrypt)                           | Operating Systems
     22 | Juniper NetScreen/SSG (ScreenOS)                 | Operating Systems
    501 | Juniper IVE                                      | Operating Systems
  15100 | Juniper/NetBSD sha1crypt                         | Operating Systems
   7000 | FortiGate (FortiOS)                              | Operating Systems
   5800 | Samsung Android Password/PIN                     | Operating Systems
  13800 | Windows Phone 8+ PIN/password                    | Operating Systems
   8100 | Citrix NetScaler                                 | Operating Systems
   8500 | RACF                                             | Operating Systems
   7200 | GRUB 2                                           | Operating Systems
   9900 | Radmin2                                          | Operating Systems
    125 | ArubaOS                                          | Operating Systems
   7700 | SAP CODVN B (BCODE)                              | Enterprise Application Software (EAS)
   7800 | SAP CODVN F/G (PASSCODE)                         | Enterprise Application Software (EAS)
  10300 | SAP CODVN H (PWDSALTEDHASH) iSSHA-1              | Enterprise Application Software (EAS)
   8600 | Lotus Notes/Domino 5                             | Enterprise Application Software (EAS)
   8700 | Lotus Notes/Domino 6                             | Enterprise Application Software (EAS)
   9100 | Lotus Notes/Domino 8                             | Enterprise Application Software (EAS)
    133 | PeopleSoft                                       | Enterprise Application Software (EAS)
  13500 | PeopleSoft PS_TOKEN                              | Enterprise Application Software (EAS)
  11600 | 7-Zip                                            | Archives
  12500 | RAR3-hp                                          | Archives
  13000 | RAR5                                             | Archives
  13200 | AxCrypt                                          | Archives
  13300 | AxCrypt in-memory SHA1                           | Archives
  13600 | WinZip                                           | Archives
  14700 | iTunes backup < 10.0                             | Backup
  14800 | iTunes backup >= 10.0                            | Backup
   62XY | TrueCrypt                                        | Full-Disk Encryption (FDE)
     X  | 1 = PBKDF2-HMAC-RIPEMD160                        | Full-Disk Encryption (FDE)
     X  | 2 = PBKDF2-HMAC-SHA512                           | Full-Disk Encryption (FDE)
     X  | 3 = PBKDF2-HMAC-Whirlpool                        | Full-Disk Encryption (FDE)
     X  | 4 = PBKDF2-HMAC-RIPEMD160 + boot-mode            | Full-Disk Encryption (FDE)
      Y | 1 = XTS  512 bit pure AES                        | Full-Disk Encryption (FDE)
      Y | 1 = XTS  512 bit pure Serpent                    | Full-Disk Encryption (FDE)
      Y | 1 = XTS  512 bit pure Twofish                    | Full-Disk Encryption (FDE)
      Y | 2 = XTS 1024 bit pure AES                        | Full-Disk Encryption (FDE)
      Y | 2 = XTS 1024 bit pure Serpent                    | Full-Disk Encryption (FDE)
      Y | 2 = XTS 1024 bit pure Twofish                    | Full-Disk Encryption (FDE)
      Y | 2 = XTS 1024 bit cascaded AES-Twofish            | Full-Disk Encryption (FDE)
      Y | 2 = XTS 1024 bit cascaded Serpent-AES            | Full-Disk Encryption (FDE)
      Y | 2 = XTS 1024 bit cascaded Twofish-Serpent        | Full-Disk Encryption (FDE)
      Y | 3 = XTS 1536 bit all                             | Full-Disk Encryption (FDE)
   8800 | Android FDE <= 4.3                               | Full-Disk Encryption (FDE)
  12900 | Android FDE (Samsung DEK)                        | Full-Disk Encryption (FDE)
  12200 | eCryptfs                                         | Full-Disk Encryption (FDE)
  137XY | VeraCrypt                                        | Full-Disk Encryption (FDE)
     X  | 1 = PBKDF2-HMAC-RIPEMD160                        | Full-Disk Encryption (FDE)
     X  | 2 = PBKDF2-HMAC-SHA512                           | Full-Disk Encryption (FDE)
     X  | 3 = PBKDF2-HMAC-Whirlpool                        | Full-Disk Encryption (FDE)
     X  | 4 = PBKDF2-HMAC-RIPEMD160 + boot-mode            | Full-Disk Encryption (FDE)
     X  | 5 = PBKDF2-HMAC-SHA256                           | Full-Disk Encryption (FDE)
     X  | 6 = PBKDF2-HMAC-SHA256 + boot-mode               | Full-Disk Encryption (FDE)
      Y | 1 = XTS  512 bit pure AES                        | Full-Disk Encryption (FDE)
      Y | 1 = XTS  512 bit pure Serpent                    | Full-Disk Encryption (FDE)
      Y | 1 = XTS  512 bit pure Twofish                    | Full-Disk Encryption (FDE)
      Y | 2 = XTS 1024 bit pure AES                        | Full-Disk Encryption (FDE)
      Y | 2 = XTS 1024 bit pure Serpent                    | Full-Disk Encryption (FDE)
      Y | 2 = XTS 1024 bit pure Twofish                    | Full-Disk Encryption (FDE)
      Y | 2 = XTS 1024 bit cascaded AES-Twofish            | Full-Disk Encryption (FDE)
      Y | 2 = XTS 1024 bit cascaded Serpent-AES            | Full-Disk Encryption (FDE)
      Y | 2 = XTS 1024 bit cascaded Twofish-Serpent        | Full-Disk Encryption (FDE)
      Y | 3 = XTS 1536 bit all                             | Full-Disk Encryption (FDE)
  14600 | LUKS                                             | Full-Disk Encryption (FDE)
   9700 | MS Office <= 2003 $0/$1, MD5 + RC4               | Documents
   9710 | MS Office <= 2003 $0/$1, MD5 + RC4, collider #1  | Documents
   9720 | MS Office <= 2003 $0/$1, MD5 + RC4, collider #2  | Documents
   9800 | MS Office <= 2003 $3/$4, SHA1 + RC4              | Documents
   9810 | MS Office <= 2003 $3, SHA1 + RC4, collider #1    | Documents
   9820 | MS Office <= 2003 $3, SHA1 + RC4, collider #2    | Documents
   9400 | MS Office 2007                                   | Documents
   9500 | MS Office 2010                                   | Documents
   9600 | MS Office 2013                                   | Documents
  10400 | PDF 1.1 - 1.3 (Acrobat 2 - 4)                    | Documents
  10410 | PDF 1.1 - 1.3 (Acrobat 2 - 4), collider #1       | Documents
  10420 | PDF 1.1 - 1.3 (Acrobat 2 - 4), collider #2       | Documents
  10500 | PDF 1.4 - 1.6 (Acrobat 5 - 8)                    | Documents
  10600 | PDF 1.7 Level 3 (Acrobat 9)                      | Documents
  10700 | PDF 1.7 Level 8 (Acrobat 10 - 11)                | Documents
   9000 | Password Safe v2                                 | Password Managers
   5200 | Password Safe v3                                 | Password Managers
   6800 | LastPass + LastPass sniffed                      | Password Managers
   6600 | 1Password, agilekeychain                         | Password Managers
   8200 | 1Password, cloudkeychain                         | Password Managers
  11300 | Bitcoin/Litecoin wallet.dat                      | Password Managers
  12700 | Blockchain, My Wallet                            | Password Managers
  15200 | Blockchain, My Wallet, V2                        | Password Managers
  13400 | KeePass 1 (AES/Twofish) and KeePass 2 (AES)      | Password Managers
  15500 | JKS Java Key Store Private Keys (SHA1)           | Password Managers
  15600 | Ethereum Wallet, PBKDF2-HMAC-SHA256              | Password Managers
  15700 | Ethereum Wallet, SCRYPT                          | Password Managers
  99999 | Plaintext                                        | Plaintext
``` 