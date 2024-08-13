function cb=BoSurfStatViewColLim(clim);

%SurfStatViewColLim sets the colour limits for SurfStatView.
%
% Usage: cb = SurfStatViewColLim(clim);
%
% clim = [min, max] values of data for colour limits.
%
% cb   = handle to new colorbar.

children=get(gcf,'Children');
n=length(children);
count = 0;
for i=1:n
    tempstruct = get(children(i));
    if(isfield(tempstruct, 'CLim'))
        set(children(i),'CLim',clim);
    end
    if(isfield(tempstruct, 'Title'))
        tempstruct_re = get(get(children(i),'Title'));
        if(isfield(tempstruct_re, 'String') && count == 0)
            count = i;
        end
    end
end

% title=get(get(children(count),'Title'),'String');
% colorbar off;
% cb=colorbar('location','South');
% set(cb,'Position',[0.35 0.22 0.3 0.03]);
% set(get(cb,'Title'),'String',title);

return
end
