function wf = closeHeader(wf)
%CLOSEHEADER write header to disk and reopen file in append mode
%
%  f=CLOSEHEADER(f) closes the header for further modifications, writes
%  the header to disk and reopens the file in append mode.
%
%  Example
%    f = mwlwaveformfile('test.dat', 'write')
%    f = closeHeader(f);
%
%  See also HEADER
%

%  Copyright 2005-2006 Fabian Kloosterman

hdr = get(wf, 'header');

if len(header) == 0
    sh = subheader();
else
    sh  = hdr(1);
end

sh = setParam(sh, 'File Format', 'waveform');
sh = setParam(sh, 'nelect_chan', wf.nchannels);

hdr(1) = sh;

wf = set(wf, 'header', hdr);

wf.mwlfixedrecordfile = closeHeader(wf.mwlfixedrecordfile);
