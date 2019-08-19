function DLC = load_DLC_data(csv_file)
% Loads csv file output from DLC into struct. 
% Tested on DLC 1.0 and 2.0. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET DLC DATA INTO MATLAB:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Tbl = readtable(csv_file);
numLabeledPoints = (size(Tbl.Properties.VariableNames,2)-1)/3; % number of labeled points
txtStr = repmat('%f',1,size(Tbl.Properties.VariableNames,2));

% GET header body label info from csv:
for bCount = 1:numLabeledPoints
    bodyLabel{bCount} = Tbl{1,(bCount-1)*3+2}{1};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD DATA and CREATE STRUCTURE:
fID = fopen(csv_file);
D = textscan(fID,txtStr,'Delimiter',',',...
    'EmptyValue',NaN,'HeaderLines',3);
fclose(fID);
D = cell2mat(D); % matrix of data points
DLC = struct;
for bCount = 1:size(bodyLabel,2)
    DLC.(bodyLabel{bCount}) = D(:,[(bCount-1)*3+2:(bCount-1)*3+4]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





