% Restore model property 
%
% INPUTS
% -------------------------------------------------------------------------
% obs:  Observed value
% mod:  Model value
% tau:  restoring timescale

function [dT] = restore(obs,mod,tau)

dT = (obs-mod)./tau;