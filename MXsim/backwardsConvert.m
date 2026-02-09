function result = backwardsConvert(a)
%This function works on a single block
%argument a should be a structure in BlockConvert format, with a.vector and 
%a.scale defined

result = (a.scale*a.vector); 

end 