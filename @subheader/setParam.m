function sh = setParam(sh, parm, val)
%SETPARAM set the value of a subheader parameter
%
%  sh=SETPARAM(sh, param, val) sets the value of a parameter in
%  subheader. If the parameter does not exist it will be created.
%

%  Copyright 2005-2006 Fabian Kloosterman

if nargin<3
  help(mfilename)
  retunr
end

if ~ischar(parm) || strcmp(parm, '')
  error('subheader:setParam:invalidParameter', ...
        'Parameter name should be non-empty string')
end

if isempty(val)
  error('subheader:setParam:invalidValue', 'Value cannot be empty')
end

id = find( strcmp(sh.parms(:,1), parm) );

if (length(id)>1)
  error('subheader:setParam:Error', ...
        'Internal error: same parameter present multiple times')
end

%convert parameter
if ischar(val)
  %fine
elseif isnumeric(val)
  val = num2str(val, 8);
elseif iscell(val)
  val = char(val);
else
  error('subheader:setParam:invalidValue', ...
        'Conversion of value to string is not possible')
end

if isempty(id)
  %no such parameter yet, append
  sh.parms(end+1,1:2) = {parm val};
else
  sh.parms(id,1:2) = {parm val};
end


