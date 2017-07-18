import os
import argparse

def parse_args():
    parser = argparse.ArgumentParser(description='Match credentials in a leaked username:hash formatted'
                                                 ' file with cracked passwords in a potfile')
    parser.add_argument('-a', '--accounts', type=str, required=True, 
                        help='leaked accounts file with one "username:hash" per line')
    parser.add_argument('-p', '--potfile', type=str, required=True, 
                        help='hashcat potfile')
    parser.add_argument('-d', '--delimiter', type=str, default=':', 
                        help='character or string that seperates usernames from passwords')
    args = parser.parse_args()
    if not os.path.exists(args.accounts):
        parser.error('{} file does not exist'.format(args.accounts))
    if not os.path.exists(args.potfile):
        parser.error('{} file does not exist'.format(args.potfile))
    return args

if __name__ == '__main__':

    args = parse_args()
    with open(args.accounts, 'r') as f:
        hash_to_username = { hsh: username for username, hsh in \
                         [l.split(args.delimiter) for l in f.read().split('\n') \
                          if len(l.split(args.delimiter)) > 1] }
    # print(hash_to_username)
    with open(args.potfile, 'r') as f:
        hash_to_pw = { hsh: pw for hsh, pw in [l.split(':') for l in f.read().split('\n') \
                                               if len(l.split(':')) > 1]}

    for hsh, username in hash_to_username.items():
        if hsh in hash_to_pw:
            print('{}:{}'.format(username, hash_to_pw[hsh]))
