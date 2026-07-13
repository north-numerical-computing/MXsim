function MX = merge_MX(MX)
% MERGE_MX Merges a user-defined MX struct with default MX values.
%
%   MX = MERGE_MX(MX) takes a user-defined MX configuration struct and
%   fills in any missing fields with their default values, as defined by
%   DEFAULT_MX. Fields that are already set by the user are preserved.

    defaults = default_MX();
    MX = mergeStructs(defaults, MX);

end


function base = mergeStructs(base, override)
 fields = fieldnames(override);
 for i = 1:numel(fields)
    f = fields{i};
    if isstruct(override.(f)) && isfield(base, f) && isstruct(base.(f))
       base.(f) = mergeStructs(base.(f), override.(f));
    else
       base.(f) = override.(f);
    end
  end
end

