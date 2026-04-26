function MX = default_MX()
    MX.element_opts.format    = 'E4M3';
    MX.accumulator_opts.format = 's';
    MX.output_opts.format      = 's';
    MX.k                       = 32;  % block size
    MX.scale_bits = 8;
end