%AppendError
%Appends Error to Error List

%DPG 13-OCT-2014
%Created Program
function [ NumErrors ] = AppendError( filename,text,description,linenumber,cleared )
global Errors

newindex = length(Errors)+1;
Errors(newindex).Index = 1;
Errors(newindex).FileName = filename;
Errors(newindex).LineNumber = linenumber;
Errors(newindex).Text = text;
Errors(newindex).Description = description;
Errors(newindex).Cleared = cleared;
Errors(newindex).Time = datestr(now);

end

