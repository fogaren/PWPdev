function [out] = naninterp1(x, Y, xi,varargin)
    szY = size(Y);
    out = nan(length(xi),szY(2));
    for ii = 1:szY(2)
        gd = ~isnan(Y(:,ii)) & ~isnan(x);
        % at least two points needed to interpolate
        if sum(gd) > 1
            out(:,ii) = interp1(x(gd),Y(gd,ii),xi,varargin{:});
        else
            out(:,ii) = nan.*xi;
        end
    end
end

