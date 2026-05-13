function MX = merge_MX(MX)
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