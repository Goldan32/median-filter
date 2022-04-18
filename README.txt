Instructions on how to handle source controlled Vivado project.

Folder structure

median-filter/
    generate_project.tcl   - TCL script created by Vivado.        Checked in.
    sources/               - Your Verilog (or VHDL) source code.  All checked in.
    constraints/           - Your constraint files.               All checked in.
    project_1/             - Vivado project.                      Nothing here is checked in.



1. Clone the git repository

	$ git clone <repo_link>


2. Generate the project (this is only needed one time after a pull or clone or merge).

	$ vivado -source generate_project.tcl


3. Make changes in the project. It can be closed and opened and changed freely.
	Checking out your branch is done in this step.
	Branches should be your name and an incrementing number (eg. koren-1 for the first branch)
	Any new source files should be added to src/ folder NOT THE PROJECT
	There shouldn't be new constraint files, but they belong in con/ folder


4. Overwrite the .tcl script with the recent changes.
	Execute these commands in the TCL_CONSOLE and NOT your shell.
	Also do NOT type in the > character these only signal that these are commands.

	1. Check if you are in the parent directory

		> pwd

	2. This command shows your current directory. It the end is
	/median-filter/project1 then you are too deep, go up a level.

		> cd ..

	3. Now you should be at the level where the end of your path is
	/median-filter

	4. Create the new .tcl script.

		> write_project_tcl -force generate_project

5. Commit changes.

	$ git add .
	$ git commit -m "<branchname>: Describe your changes"
	$ git push

6. Talk to each other about merging development branches.
