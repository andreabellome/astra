# ASTRA
ASTRA (Automatic Swing-by TRAjectories) is a MATLAB-based toolbox for optimally build multi-gravity assist (MGA) trajectories. This has been built as a result of Andrea Bellome's Ph.D. thesis [[1]](#1). ASTRA is based on Dynamic Programming (DP) to optimize MGA trajectories, both in single-objective (SODP) and multi-objective (MODP).

To cite this folder please use the references [[1]](#1) and [[2]](#2).

## Installation & Requirements

To work with ASTRA, one can simply clone the repository in the local machine:


```bash
git clone "https://github.com/andreabellome/MRPLP_DACE_python"
```

To run a full exploration of MGA trajectories, the following system requirements are recommended:
+ CPU six-core from 2.6 GHz to 3.6 GHz
+ RAM minimum 16 GB
+ Any version of [MATLAB](https://it.mathworks.com/products/matlab.html)>2021b <!-- with [Optimization Toolbox](https://it.mathworks.com/products/optimization.html) (this need will be eliminated in the future) -->

Lighter requirements will be required in future releases, as ASTRA will be able to optimize one launch year at a time, and even one date at a time. The price will be the computational time. 

## Usage and test cases

To use the repository, one finds different test scripts. These are listed here:

1. Test script 1: [st_astra_main.m](/st1_astra_main.m), to optimize MGA missions. Refer to [this section](#Section_1).

### Test script 1: Run DP optimization with ASTRA  <a id="Section_1"></a> 

TBD

## Contributing

Currently, only invited developers can contribute to the repository.

## License

The work is under license [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc/4.0/), that is an Attribution Non-Commercial license.


## References
<a id="1">[1]</a> 
Bellome, A., “Trajectory design of multi-target missions via graph transcription and dynamic programming,” Ph.D. thesis, Cranfield University, 2023.
https://dspace.lib.cranfield.ac.uk/items/711f45c8-e6e4-4f27-909d-94170df400e3

<a id="2">[2]</a> 
Bellome, A., et al. "Multiobjective design of gravity-assist trajectories via graph transcription and dynamic programming." Journal of Spacecraft and Rockets 60.5 (2023): 1381-1399.
https://doi.org/10.2514/1.A35472.
