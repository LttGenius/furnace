function [ performance ] = performmodel( varargin )
%PERFORM Perform model with one dataset
%----------
%
% P = PERFORMMODEL( MODEL, DATA, GT, GLOBAL_ARG, LOCAL_ARG ) return the
% performance result of MODEL. 
% The PERFORMMODEL performs MODEL with two parameters GLOBAL_ARG and
% LOCAL_ARGon one dataset. 

    narginchk( 2, 7 );
    model = varargin{1};
    data = varargin{2};
    performance = model(data, varargin{3:end});
end

