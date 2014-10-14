function [ linenumber ] = GetLineNumber( )
     d=dbstack;
     loc=[{d.file}',{d.name}.',{d.line}.'];
     linenumber = loc{2,3};

end

