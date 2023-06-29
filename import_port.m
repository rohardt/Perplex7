function Ports = import_port(filename, dataLines)
% Ports.txt is a file with port names and their corresponding location in
% latitude and longitude. e.g.
% Port; Latitude; Longitude
% Aalborg(da); 57.05; 9.9333
% Aarhus(da); 56.15; 10.2167
% Aberdeen(uk); 57.15; -2.0833
% Accra(gh); 5.5333; -0.2
% Admiralty bay(ay); -62.0833; -58
% and so on.
% Port.txt was used in app: DialogNew_Cruise.mlapp to create a new cruise

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

opts = delimitedTextImportOptions("NumVariables", 3);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ";";

% Specify column names and types
opts.VariableNames = ["Port", "Latitude", "Longitude"];
opts.VariableTypes = ["string", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "Port", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Port", "EmptyFieldRule", "auto");

% Import the data
Ports = readtable(filename, opts);

end