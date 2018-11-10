#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os

def find_dir(string, path='..'):
    print('cur dir:%s' % os.path.abspath(path))
    for filename in os.listdir(path):
        deeper_dir = os.path.join(path, filename)
        if os.path.isfile(deeper_dir) and string in filename:
            print('%s with \'t\' in its name' % filename)
        if os.path.isdir(deeper_dir):
            find_dir(string, deeper_dir)

if __name__ == '__main__':
    find_dir('t')

import os

def detect_walk(dir_path):
    for root, dirs, files in os.walk(dir_path):
        for filename in files:        
            print "file:%s\n" % filename
        for dirname in dirs:
            print "dir:%s\n" % dirname

if __name__ == "__main__":
    detect_walk(".")
