function MX = default_MX()
% DEFAULT_MX Returns the default MX configuration struct.
%
%   MX = DEFAULT_MX() returns a struct containing the default MX format
%   configuration, corresponding to the OCP MXFP8 E4M3 format with
%   binary32 (FP32) accumulation and output precision.
%
    MX.element_opts.format    = 'E4M3';
    MX.element_opts.saturation = 1;
    MX.element_opts.round = 1;
    MX.accumulator_opts.format = 's';
    MX.output_opts.format      = 's';
    MX.k                       = 32;  % block size
    MX.scale_bits = 8;

end