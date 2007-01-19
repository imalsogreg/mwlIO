function wf = mwlwaveformfile(varargin)
%MWLWAVEFORMFILE constructor
%
%  f=MWLWAVEFORMFILE default constructor, creates a new empty mwleegfile
%  object.
%
%  f=MWLWAVEFORMFILE(f) copy constructor
%
%  f=MWLWAVEFORMFILE(filename) opens the specified mwl waveform file in read mode.
%
%  f=MWLWAVEFORMFILE(filename, mode) opens the mwl waveform file in the specified
%  mode ('read', 'write', 'append', 'overwrite').
%
%  f=MWLWAVEFORMFILE(filename, mode, nchan) will set the number of channels
%  for a new mwl waveform file opened in 'write' or 'overwrite' mode (default
%  = 4).
%
%  f=MWLWAVEFORMFILE(filename, mode, nchan, nsamples) will set the number of
%  samples per channel in a waveform for a new file opened in 'write'
%  or 'overwrite' mode (default = 32);
%
%  Note: only binary mwl waveform files are supported.
%
%  Example
%    %open waveform file
%    f = mwlwaveformfile( 'data.tt' );
%
%    %create new waveform file, with 8 channels and 64 samples/channel
%    f = mwlwaveformfile( 'data.tt', 'write', 8, 64 );
%
%  See also MWLFIXEDRECORDFILE, MWLRECORDFILE, MWLFILEBASE
%

%  Copyright 2005-2006 Fabian Kloosterman

if nargin==0
    wf = struct('nsamples', 0, 'nchannels', 0);
    frf = mwlfixedrecordfile();
    wf = class(wf, 'mwlwaveformfile', frf);
elseif isa(varargin{1}, 'mwlwaveformfile')
    wf = varargin{1};
else
    
  frf = mwlfixedrecordfile(varargin{1:(min(end,2))});
  
  if strcmp(frf.format, 'ascii')
    error('mwlwaveformfile:mwlwaveformfile:invalidFile', ...
          'Ascii waveform files are not supported.')
  end    
  
  if ismember(frf.mode, {'read', 'append'})
    
    %waveform file?
    if ~strcmp( getFileType(frf), 'waveform')
      error('mwlwaveformfile:mwlwaveformfile:invalidFile', 'Invalid spike waveform file')
    end
    
    fields = frf.fields;
    if ~all(ismember(name(fields), {'timestamp', 'waveform'}))
      error('mwlwaveformfile:mwlwaveformfile:invalidFile', 'Invalid waveform file')
    end  
    
    wf.nsamples = length(fields(2));
    
    wf.nchannels = 0;
    
    hdr = get(frf, 'header');
    for h=1:len(hdr)
      sh = hdr(h);
      try
        wf.nchannels = str2double(getParam(sh, 'nelect_chan'));
      catch
        continue
      end
    end
    
    if wf.nchannels == 0
      error('mwlwaveformfile:mwlwaveformfile:invalidFile', 'Cannot determine number of channels in file')
    end
    
    wf.nsamples = wf.nsamples ./ wf.nchannels;
    
  else
    
    if nargin<4 || isempty(varargin{4})
      wf.nsamples = 32;
    else
      wf.nsamples = varargin{4};
    end
    
    if nargin<3 || isempty(varargin{3})
      wf.nchannels = 4;
    else
      wf.nchannels = varargin{3};
    end
    
    if ~isscalar(wf.nsamples) || ~isscalar(wf.nchannels) || ~isnumeric(wf.nchannels) || ~isnumeric(wf.nsamples)
      error('mwlwaveformfile:mwlwaveformfile:invalidFile', 'Invalid nsamples and/or nchannels parameters')
    end
    
  end
  
  wf = class(wf, 'mwlwaveformfile', frf);
  
end
