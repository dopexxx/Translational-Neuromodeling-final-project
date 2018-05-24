function rel_time = time_abs_to_rel(abs_time, baseline)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Converts an absolute time into a relative one (w.r.t. to an baseline)
% Requires that abs_time is greater (later) than baseline. 
%
%   Parameters:
%   ---------------
%   ABS_TIME        {double} [3x1], absolute time in hh,min,sec
%   BASLINE         {double} [3x1], same format, baseline time (0 in
%                       relative terms)
%
%   Returns:
%   ---------------
%   REL_TIME        {double} [1x1], relative time, in ms w.r.t baseline


if baseline(1) > abs_time(1) || ...
        (baseline(1) == abs_time(1) && baseline(2) > abs_time(2)) || ...
        (baseline(1) == abs_time(1) && baseline(2) == abs_time(2) && ...
         baseline(3) > abs_time(3))
     
     rel_time = -1; % means that abs_time is before baseline.
else

    % sec diff.
    if baseline(3) <= abs_time(3)
        rel_ms = abs_time(3) - baseline(3);
    else
        rel_ms = (60-baseline(3)) + abs_time(3);
        baseline(2) = baseline(2) + 1; % correct minutes
        if baseline(2) > 59
            baseline(3) = baseline(3) + 1; % correct hour when min overflow
            baseline(2) = 0; % reset minutes
        end
    end

    % min diff
    if baseline(2) <= abs_time(2)
        rel_min = abs_time(2) - baseline(2);
    else
        rel_min = (60-baseline(2)) + abs_time(2);
        baseline(1) = baseline(1) + 1; % correct hour  
    end

    if baseline(1) ~= abs_time(1)
        error("Did this experiment really take longer than one hour?")
    end

    rel_time = rel_min*60 + rel_ms;

end