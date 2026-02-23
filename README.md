BFP Simulator
--
This repository simulates OCP MX formats, as specified in [1], as well as custom formats following the MX structure. 

The toolbox can simulate the multiplication of two vectors or matrices with the following custom parameters: 
* Element datatype
* Block size
* Accumulation precision
* Output precision

When a vector is converted to a chosen BFP format, it is stored as a structure, containing an array of block vectors and their corresponding scales. The elements of each block vector simulate low precision, via [CPFloat](https://github.com/north-numerical-computing/cpfloat). The accumulation and output precision also simulate the chosen format using CPFloat. 


## Dependencies and Installation 
1. Install [CPFloat](https://github.com/north-numerical-computing/cpfloat), the custom floating point precision simulator.
2. Add [MXsim/](MXsim/) to MATLAB search path. 

## Configuration
The custom datatype must first be set by defining a structure with the required fields. The element, accumulation and output precision may be set to any datatype on that CPFloat supports. The following example shows the configuration for simulating MXFP8 (E5M2) formats, with a double output and FP32 accumulation. 
```console
MX.element_opts.format = 'E5M2'; % Set element datatype to E5M2
MX.k = 32; % Set block size to 32
MX.accumulator_opts.format = 's'; % Set accumulation format to FP32 (single precision)
MX.output_opts.format = 'd'; % Set output format to FP64 (double precision)
```

## Examples

Here's an example GeneralDot usage, computing the dot product of two double precision vectors of size 10^4, using the MX format configuration described above.
 The configuration in the above section was used. 
```console
>> rng(500);

%Choose two random vectors 
A = (rand(10^4,1) - 0.5) * 2 * 10^4;
B = (rand(10^4,1) - 0.5) * 2 * 10^4;

>> GeneralDot(A,B,MX)

ans =

   -60685376
```
Below is an example of BlockMatMul usage with the same configuration.
```console
>> C = (rand(8,8) - 0.5) * 2 * 10^4;
>> D = (rand(8,8) - 0.5) * 2 * 10^4;

>> BlockMatMul(C,D,MX)

ans =

  -200278016    12550144   -54853632   104660992    20316160    92798976   -56885248    41680896
   -47120384    -1933312   -15204352    -4849664   -16777216   -28114944    70254592    24297472
     7110656    38621184    23580416   -23683072   -87117824    78557184   -19804160   -84746240
    45350912  -132579328   -17956864    34209792   151912448   239861760   -17039360   -10158080
    77332480   -13828096    -1572864   -43122688   -30801920   -40108032    49020928    -8847360
   -72876032    38338560   -74711040   -28704768  -159514624     3670016   -14221312  -158597120
    20447232   108331008   153649152    57933824   -31129600     5505024   -36831232    -2818048
   148897792    72941568   135790592   -76152832    -2097152  -158334976    63176704    74186752


```


## OCP Compliance

### OCP MX Specification Compliant Aspects 
* MX vectors are stored as a set of k sized blocks with their corresponding shared scales, as specified on page 9 of the MX specification.
* Conversion of a k sized vector to MX follows the algorithm specified on page 15. This is implemented as the function BlockConvert.
* The basic operations specified on page 14 and 15 are supported. Section 6.1 mentions the dot product between two MX compliant blocks, which is implemented as the function BlockDot. The general dot product specified in section 6.2 is implemented as the function GeneralDot. 

### OCP Unspecified Aspects
#### Accumulation Precision
The accumulation Precision for the general dot product between two vectors is not specified by OCP. Hence, the accumulation precision has been made customisable. 

### Accumulation Method
Accumulation is performed recursively by default. 

### NaNs
When converting to MX, if a vector contains NaNs, they are ignored when computing the scale and their corresponding values remain as NaNs. This allows vectors containing NaNs to be converted to MX. However, performing a general dot product with a vector containing NaNs will result in a NaN. 

### MX Conversion 
A function named MXconvert is included, which goes beyond the OCP specified conversion algorithm. The OCP method exclusively converts a vector containing a single block and scale factor. Although the exact OCP algorithm is included as the function BlockConvert, the function MX convert is also included. This function will convert a vector of any length to MX, and return a structure containing multiple block vectors and their corresponding scales. 









## References
[1] Open Compute Project Foundation. OCP microscaling formats (mx) specification. Technical report, Open Compute Project, 2023. URL https://www.opencompute.org/
documents/ocp-microscaling-formats-mx-specification.

