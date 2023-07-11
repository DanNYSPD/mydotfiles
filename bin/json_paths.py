#!/usr/bin/python
#allows to print a json paths using dot notation.


import json
import sys
import os
import argparse


def print_json_paths(data, parent=''):
    # print("_")
    if isinstance(data, dict):
        for key, value in data.items():
            if parent:
                path = parent + '.' + key
            else:
                path = key
            print(path)
            print_json_paths(value, path)
    elif isinstance(data, list):
        for i, value in enumerate(data):
            path = parent + '.' + str(i)
            print(path)
            print_json_paths(value, path)
    else:
        pass
        #raise argparse.ArgumentTypeError(f'is not json:{data}')
        # Example usage


def main():
    if not sys.stdin.isatty():
        # Data is being piped into the script
        stdin_lines = [line.strip() for line in sys.stdin]

        json_data = '\n'.join(stdin_lines)

    else:
        parser = argparse.ArgumentParser(description='JsonPath')
        parser.add_argument('jsonpath', help='Json file path')
        args = parser.parse_args()

        if not os.path.exists(args.jsonpath):
            raise argparse.ArgumentTypeError(f'file: {args.jsonpath} does not exists')

        with open(args.jsonpath, 'r') as file:
            json_data = file.read()
    print(json_data)
    data = json.loads(json_data)
    print_json_paths(data)


if __name__ == '__main__':

    try:
        main()
    except argparse.ArgumentTypeError as e:
        sys.stderr.write(str(e) + '\n')
        sys.exit(1)
