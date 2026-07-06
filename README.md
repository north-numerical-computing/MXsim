BFP Simulator
--
This repository simulates OCP MX formats, as specified in [1], as well as custom formats following the MX structure. 

The toolbox can simulate the multiplication of two vectors or matrices with the following custom parameters: 
* Element format
* Block size
* Accumulation format
* Output format

When a vector is converted to a chosen BFP format, it is stored as a structure, containing an array of block vectors and their corresponding scales. The elements of each block vector simulate low precision, via [CPFloat](https://github.com/north-numerical-computing/cpfloat). The accumulation and output format also simulate the chosen format using CPFloat. 


## Dependencies and Installation 
1. Install [CPFloat](https://github.com/north-numerical-computing/cpfloat), the custom floating point format simulator.
2. Add [MXsim/](MXsim/) to MATLAB search path. 

## Configuration
The custom format must first be set by defining a structure with the required fields. The element, accumulation and output format may be set to any format that CPFloat supports. The following example shows the configuration for simulating MXFP8 (E5M2) formats, with a output in FP16 (binary16 IEEE 754 format) and accumulation in FP32 (binary32 IEEE format). 
```console
MX.element_opts.format = 'E5M2'; % Set element datatype to E5M2
MX.k = 32; % Set block size to 32
MX.accumulator_opts.format = 's'; % Set accumulation format to FP32 (single precision)
MX.output_opts.format = 'h'; % Set output format to FP16 (half precision)
```

## Examples

Here's an example GeneralDot usage, computing the dot product of two FP64 (binary64 IEEE 754 format) vectors of size 10^4, using the MX format configuration described above.
```console
>> rng(500);

% Choose two random vectors 
A = (rand(10^4,1) - 0.5) * 2 ;
B = (rand(10^4,1) - 0.5) * 2 ;

>> GeneralDot(A,B,MX)


ans =

    4.4375

```
Below is an example of BlockMatMul usage with the same configuration.
```console
>> C = (rand(8,8) - 0.5) * 2 ;
>> D = (rand(8,8) - 0.5) * 2 ;

>> BlockMatMul(C,D,MX)


ans =

   -1.8018    0.8389   -1.9756   -1.9824    0.2939   -0.2362    0.3037    0.8809
   -0.3083    0.3704    0.8760   -0.1753    1.1543   -1.8662    0.0464    0.5381
   -2.1914    1.0625   -0.4531   -1.3789   -0.7656    1.0420    1.0859    1.8750
    0.0049    0.7988   -2.2500   -0.0273   -0.1914    1.1719   -0.9546   -1.2188
   -1.3203    0.0870   -1.9531   -1.3379    1.3154    0.7729   -1.0371    1.1367
   -1.0273    0.3818    0.3584   -1.1426    1.0957   -2.2422    0.2588    0.8477
   -0.2285    0.3354    0.8691   -0.3086   -0.4189    0.2656    0.0293   -0.2266
    0.7773    1.1338   -0.0391    1.7812    1.1875   -1.2617   -0.1084   -0.5000

```


## OCP Compliance

### OCP MX Specification Compliant Aspects 
* MX vectors are stored as a set of k sized blocks with their corresponding shared scales, as specified on page 9 of the MX specification.
* Conversion of a k sized vector to MX follows the algorithm specified on page 15. This is implemented as the function BlockConvert.
* The basic operations specified on page 14 and 15 are supported. Section 6.1 mentions the dot product between two MX compliant blocks, which is implemented as the function BlockDot. The general dot product specified in section 6.2 is implemented as the function GeneralDot. 
* CPFloat is used to convert element datatypes to OCP E5M2 and E4M3. NaNs and infinities are represented correctly by CPFLoat. The max value for E4M3 in CPFloat is 480, whereas the OCP specified max value is 448. Therefore, this has been corrected within the toolbox when the element format is E4M3. 


### OCP Unspecified Aspects
#### Accumulation Precision
The accumulation format for the general dot product between two vectors is not specified by OCP. Hence, the accumulation format has been made customisable. 

#### Accumulation Method
Accumulation within BlockDot is performed recursively, converting to the accumulation format at each step. The accumulation method is left implementation defined by OCP. BlockDot computes the dot product of a pair of single blocks. 

GeneralDot accumulates BlockDot results recursively, converting to the output precision at each step. 



#### NaNs
When converting to MX, if a vector contains NaNs, they are ignored when computing the scale and their corresponding values remain as NaNs. This allows vectors containing NaNs to be converted to MX. However, performing a general dot product with a vector containing NaNs will result in a NaN. 

#### MX Conversion 
A function named MXconvert is included, which goes beyond the OCP specified conversion algorithm. The OCP method exclusively converts a vector containing a single block and scale factor. Although the exact OCP algorithm is included as the function BlockConvert, the function MX convert is also included. This function will convert a vector of any length to MX, and return a structure containing multiple block vectors and their corresponding scales. 


## Tests

The simulator includes a test suite located in the `tests/` directory. 
Tests can be run from MATLAB using:

```matlab
runalltests
```

### Integration tests
Integration tests are located in `tests/integration/` and verify the correctness of the core functions `BlockConvert`, `BlockDot`, `MXconvert`, and `backwardsConvert` against hand-computed values and edge cases.

### Error bound tests
Error bound tests are located in `tests/expected_errors/` and verify that the results of `BlockDot`, `GeneralDot`, and `BlockMatMul` fall within theoretical error bounds derived from standard backward error analysis for recursive summation.





## References
[1] Open Compute Project Foundation. OCP microscaling formats (MX) specification. Technical report, Open Compute Project, 2023. URL https://www.opencompute.org/documents/ocp-microscaling-formats-mx-v1-0-spec-final-pdf
