# import json
import sys

if __name__ == '__main__':
    argvs = sys.argv 
    f = open(argvs[1], "r")
    s = f.read()
    print s
    # main()