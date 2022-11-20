import logging
import os
import argparse

from fpga.project import Project

logging.basicConfig()

prj = Project("quartus", "Relogio")
prj.set_part("5CEBA4F23C7")

parser = argparse.ArgumentParser()
parser.add_argument(
    "--action",
    choices=["generate", "transfer", "all"],
    default="generate",
)
args = parser.parse_args()

for path, subdirs, files in os.walk("./vhdl"):
    for name in files:
        subdir = os.path.basename(path)
        if subdir == "vhdl":
            subdir = None

        prj.add_files(os.path.join(path, name), library=subdir)

prj.set_top("TopLevel")
prj.add_files("board.sdc")
prj.add_files("board.tcl")

if args.action in ["generate", "all"]:
    try:
        prj.clean()
        prj.generate()
    except RuntimeError:
        print("ERROR:generate:Quartus not found")

if args.action in ["transfer", "all"]:
    try:
        prj.transfer()
    except RuntimeError:
        print("ERROR:transfer:Quartus not found")
