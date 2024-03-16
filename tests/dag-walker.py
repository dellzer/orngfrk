import re


# den som går på DAGarna


data = """
"lhs is dyn0" -> "method not found" [label=true];
"lhs is dyn0" -> "lhs is addr" [label=false];

"lhs is addr" -> "method not found" [label=true];
"lhs is addr" -> "method not found" [label=false];

"method not found" -> "-" [label=true];
"method not found" -> "has receiver" [label=false];

"has receiver" -> "lhs is dyn1" [label=true];
"has receiver" -> "+" [label=false];

"lhs is dyn1" -> "lhs is mut" [label=true];
"lhs is dyn1" -> "expanded_lhs is addr" [label=false];

"expanded_lhs is addr" -> "lhs is mut" [label=true];
"expanded_lhs is addr" -> "+" [label=false];

"lhs is mut" -> "receiver is mut" [label=true];
"lhs is mut" -> "+" [label=false];

"receiver is mut" -> "-" [label=true];
"receiver is mut" -> "+" [label=false];
"""


class Nodes_List:
    def __init__(self):
        self.nodes = []

    def add_node(self, name):
        for node in self.nodes:
            if node.name == name:
                return node
        else:
            retval = Node(name)
            self.nodes.append(retval)
            return retval


class Node:
    def __init__(self, name):
        self.name = name
        self.children = []

    def add_child(self, other_name, conn_type):
        self.children.append((other_name, conn_type))

    def output(self, fd, string):
        for child in self.children:
            (to_node, conn_type) = child
            my_string = string + f"({self.name}: {conn_type}),  "
            to_node.output(fd, my_string)
        if len(self.children) == 0:
            fd.write(string + f"{self.name}\n")


def main():
    node_list = Nodes_List()
    lines = data.split("\n")
    for line in lines:
        stripped = line.strip()
        tokens = re.split(" -> | \[label\=|];", stripped)
        if len(tokens) < 3:
            continue
        (from_name, to_name, conn_type) = (tokens[0], tokens[1], tokens[2])
        from_node = node_list.add_node(from_name)
        to_node = node_list.add_node(to_name)
        from_node.add_child(to_node, conn_type)

    with open("out.txt", "w") as fd:
        node_list.nodes[0].output(fd, "")

main()