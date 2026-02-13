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
The custom datatype must first be set by defining a structure with the required fields. The element, accumulation and output precision may be set to any datatype on the CPFloat menu. The following example shows the configuration for simulating MXFP8 (E5M2) formats, with a double output and FP32 accumulation. 
```console
MX.element_opts.format = 'E5M2';
MX.k = 32;
MX.accumulation_opts.format = 's';
MX.output_opts.format = 'd';
```

## Examples

Here's an example GeneralDot usage, simulating double precision matrix multiplication. The configuration in the above section was used. 
```console
>> rng(500);
>> A = rand(10^4,1)*10^4;
>> B = rand(10^4,1)*10^4;
>> GeneralDot(A,B,MX);

ans =

     2.472741577560000e+11
```
Below is an example of BlockMatMul usage with the same configuration.
```console
>> C = rand(8, 8) * 10^4;
>> D = rand(8, 8) * 10^4;

>> BlockMatMul(C,D,MX)

ans =

   175046656   208535552   188743680   186646528   233701376   159924224   216268800   241303552
   287178752   272105472   336068608   304087040   339214336   186155008   281018368   315621376
   133562368   201588736   204275712   181927936   181665792   162234368   208404480   247726080
   170508288   145260544   121241600   181665792   161742848   143769600   129531904   126156800
   207814656   192151552   201588736   228589568   281804800   202022912   189792256   260571136
   201719808   210501632   253624320   218103808   262930432   113278976   217907200   245628928
   201981952   183107584   228917248   208142336   203554816   157093888   189792256   200015872
   284491776   261881856   281542656   328204288   306446336   174784512   251920384   252182528

```




## References
[1] Open Compute Project Foundation. Ocp microscaling formats (mx) specification. Tech-
nical report, Open Compute Project, 2023. URL https://www.opencompute.org/
documents/ocp-microscaling-formats-mx-specification.

