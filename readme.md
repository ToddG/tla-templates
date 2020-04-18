# TLA+ Templates

A quick-and-dirty template for creating tla+ projects.


## Depends

* python
* git
* [cookiecutter](https://github.com/cookiecutter/cookiecutter)
* [tools](https://github.com/pmer/tla-bin)

## Install

    pip install cookiecutter

See [tools](https://github.com/pmer/tla-bin) for installation instructions.

## Usage

    cookicutter git@github.com:ToddG/tla-templates.git
    cd <<module name>>
    pcal <<module name>>
    tlc <<module name>>

## Example

Generate a new spec from a template

    $ cookiecutter tla-templates/ --no-input
    $ cd module_name_snake_case/
    $ ls
    module_name_snake_case.cfg
    module_name_snake_case.tla

Translate the `pluscal` to `tla+`

    $ pcal module_name_snake_case
    
    pcal.trans Version 1.9 of 10 July 2019
    Parsing completed.
    Translation completed.
    New file module_name_snake_case.tla written.
    New file module_name_snake_case.cfg written.

Run the spec

    $ tlc module_name_snake_case

    TLC2 Version 2.14 of 10 July 2019 (rev: 0cae24f)
    Running breadth-first search Model-Checking with fp 98 and seed -6541116177562875825 with 1 worker on 8 cores with 7134MB heap and 64MB offheap memory [pid: 15440] (Linux 4.15.0-96-generic amd64, Ubuntu 11.0.6 x86_64, MSBDiskFPSet, DiskStateQueue).
    Parsing file /home/todd/repos/personal/module_name_snake_case/module_name_snake_case.tla
    Parsing file /tmp/TLC.tla
    Parsing file /tmp/FiniteSets.tla
    Parsing file /tmp/Integers.tla
    Parsing file /tmp/Naturals.tla
    Parsing file /tmp/Sequences.tla
    Semantic processing of module Naturals
    Semantic processing of module Sequences
    Semantic processing of module FiniteSets
    Semantic processing of module TLC
    Semantic processing of module Integers
    Semantic processing of module module_name_snake_case
    Starting... (2020-04-18 11:08:10)
    Computing initial states...
    Finished computing initial states: 1 distinct state generated at 2020-04-18 11:08:10.
    Model checking completed. No error has been found.
      Estimates of the probability that TLC did not check all reachable states
      because two distinct states had the same fingerprint:
      calculated (optimistic):  val = 3.5E-17
    51 states generated, 25 distinct states found, 0 states left on queue.
    The depth of the complete state graph search is 9.
    The average outdegree of the complete state graph is 1 (minimum is 0, the maximum 2 and the 95th percentile is 2).
    Finished in 01s at (2020-04-18 11:08:10)


## Resources

* [article](https://medium.com/@bellmar/introduction-to-tla-model-checking-in-the-command-line-c6871700a6a2)
* [tools](https://github.com/pmer/tla-bin)
* [alt-tools](https://github.com/hwayne/tlacli) TODO: should I be using this tooling instead?

## Issues

* [config](https://github.com/pmer/tla-bin/issues/7)
* [constants](https://stackoverflow.com/questions/59101827/how-can-i-set-constants-in-tla-configuration-file-when-using-vs-code)
