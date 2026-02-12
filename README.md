BFP Simulator
--
This repository simulates BFP formats and hardware operations, particularly MX format operations, as specified in [1].

The toolbox can simulate the multiplication of two vectors or matrices on MX hardware with the following custom parameters: 
* Element datatype
* Block size
* Accumulation precision
* Output precision

When a vector is converted to a chosen BFP format, it is stored as a structure, containing an array of block vectors and their corresponding scale. The elements of each block vector simulate low precision, via [CPFloat](https://github.com/north-numerical-computing/cpfloat). The accumulation and output precision also simulate the chosen format in the same way. 


## Dependencies and Installation 
1. Install [CPFloat](https://github.com/north-numerical-computing/cpfloat), the custom floating point precision simulator.
2. Add [MXsim/](MXsim/) to MATLAB search path. 

## Configuration
The custom datatype must first be set by defining a structure with the required fields. The element, accumulation and output precision may be set to any datatype on the CPFloat menu. The following example shows the configuration for simulating MXFP8 (E5M2) formats, with a FP32 output and FP16 accumulation. 
```console
MX.element_opts.format = 'E5M2';
MX.k = 32;
MX.accumulation_opts.format = 'fp16';
MX.output_opts.format = 'fp32';
```



## References
[1] Open Compute Project Foundation. Ocp microscaling formats (mx) specification. Tech-
nical report, Open Compute Project, 2023. URL https://www.opencompute.org/
documents/ocp-microscaling-formats-mx-specification.

