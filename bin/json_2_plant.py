#!/usr/bin/python
# Allows from a json create a plantUML diagram so the json structure can be visualized in plant UML class diagram.

import json
import argparse
import os
import sys


def generate_plantuml_code(data):
    classes_definitions = []
    child_classes_definitions = []

    def process_node(node, parent=None):
        if isinstance(node, dict):
            class_name = parent.capitalize() if parent else 'Root'
            class_definition = f"class {class_name} {{"
            classes_definitions.append(class_definition)

            attributes = []
            nested_attributes = {}
            for key, value in node.items():

                if isinstance(value, dict):
                    nested_attributes[key] = value
                    child_class_name = key.capitalize()
                    child_classes_definitions.append({
                        'name': child_class_name,
                        'relationship': f"{class_name} -- {child_class_name}",
                        'attributes': []
                    })
                    attributes.append(f"- {key}: {child_class_name}")

                else:
                    value_type = type(value).__name__
                    attributes.append(f"- {key}: {value_type}")

            classes_definitions.extend(attributes)
            classes_definitions.append("}")

            for key, value in nested_attributes.items():
                process_node(value,  key.capitalize())

    json_data = json.loads(data)
    process_node(json_data)
    NEW_LINE = '\n'
    plantuml_code = ""
    plantuml_code += f"/* here are the classes definitions */\n"
    plantuml_code += "\n".join(classes_definitions)
    plantuml_code += "\n\n"
    plantuml_code += f"/* here are defined the class associations */\n"
    plantuml_code += "\n".join([class_def['relationship'] for class_def in child_classes_definitions])
    return plantuml_code


def main():
    if not sys.stdin.isatty():
        # Data is being piped into the script
        stdin_lines = [line.strip() for line in sys.stdin]

        json_data = '\n'.join(stdin_lines)

    else:
        parser = argparse.ArgumentParser(description='Json 2 PlantUml')
        parser.add_argument('jsonfile', help='Json file path')
        args = parser.parse_args()

        if not os.path.exists(args.jsonfile):
            raise argparse.ArgumentTypeError(f'file: {args.jsonfile} does not exists')

        with open(args.jsonfile, 'r') as file:
            json_data = file.read()

    plantuml_code = generate_plantuml_code(json_data)

    print(plantuml_code)


if __name__ == '__main__':

    try:
        main()
    except argparse.ArgumentTypeError as e:
        sys.stderr.write(str(e) + '\n')
        sys.exit(1)
