function [a,cb]=BoSurfStatViewData(data,surf,title,background);

%BoSurfStatViewData is a simple viewer for surface data.
% 
% Usage: [a,cb]=BoSurfStatViewData(data, surf [,title [,background]]);
% 
% data        = 1 x v vector of data, v=#vertices
% surf.coord  = 3 x v matrix of coordinates.
% surf.tri    = 3 x t matrix of triangle indices, 1-based, t=#triangles.
% title       = any string, data name by default.
% background  = background colour, any matlab ColorSpec, such as 
%   'white' (default), 'black'=='k', 'r'==[1 0 0], [1 0.4 0.6] (pink) etc.
%   Letter and line colours are inverted if background is dark (mean<0.5).
%
% a  = vector of handles to the axes, left to right, top to bottom. 
% cb = handle to the colorbar.

if nargin<3 
    title=inputname(1);
end
if nargin<4
    background='white';
end

% find cut between hemispheres, assuming they are concatenated
t=size(surf.tri,1);
v=size(surf.coord,2);
tmax=max(surf.tri,[],2);
tmin=min(surf.tri,[],2);
% to save time, check that the cut is half way
if min(tmin(t/2+1:t))-max(tmax(1:t/2))==1
    cut=t/2;
    cuv=v/2;
else % check all cuts
    for i=1:t-1
        tmax(i+1)=max(tmax(i+1),tmax(i));
        tmin(t-i)=min(tmin(t-i),tmin(t-i+1));
    end
    cut=min([find((tmin(2:t)-tmax(1:t-1))==1) t]);
    cuv=tmax(cut);
end
tl=1:cut;
tr=(cut+1):t;
vl=1:cuv;
vr=(cuv+1):v;

clim=[min(data),max(data)];
if clim(1)==clim(2)
    clim=clim(1)+[-1 0];
end

clf;
colormap(spectral(256));


h=0.25;
w=0.20;

a(1)=axes('position',[0.1 0.3 w h]);
trisurf(surf.tri(tl,:),surf.coord(1,vl),surf.coord(2,vl),surf.coord(3,vl),...
    double(data(vl)),'EdgeColor','none');
view(-90,0); 
daspect([1 1 1]); axis tight; camlight; axis vis3d off;
lighting phong; material dull; shading interp;

a(2)=axes('position',[0.1+w 0.3 w h]);
trisurf(surf.tri(tl,:),surf.coord(1,vl),surf.coord(2,vl),surf.coord(3,vl),...
    double(data(vl)),'EdgeColor','none');
view(90,0); 
daspect([1 1 1]); axis tight; camlight; axis vis3d off;
lighting phong; material dull; shading interp;

a(3)=axes('position',[0.1+2*w 0.3 w h]);
trisurf(surf.tri(tr,:)-v/2,surf.coord(1,vr),surf.coord(2,vr),surf.coord(3,vr),...
    double(data(vr)),'EdgeColor','none');
view(-90,0); 
daspect([1 1 1]); axis tight; camlight; axis vis3d off;
lighting phong; material dull; shading interp;

a(4)=axes('position',[0.1+3*w 0.3 w h]);
trisurf(surf.tri(tr,:)-v/2,surf.coord(1,vr),surf.coord(2,vr),surf.coord(3,vr),...
    double(data(vr)),'EdgeColor','none');
view(90,0); 
daspect([1 1 1]); axis tight; camlight; axis vis3d off;
lighting phong; material dull; shading interp;

for i=1:length(a)
    set(a(i),'CLim',clim);
end

cb=colorbar('location','South');
set(cb,'Position',[0.35 0.22 0.3 0.03]);
set(cb,'XAxisLocation','bottom');
h=get(cb,'Title');
set(h,'String',title);

whitebg(gcf,background);
set(gcf,'Color',background,'InvertHardcopy','off');

dcm_obj=datacursormode(gcf);
set(dcm_obj,'UpdateFcn',@SurfStatDataCursor,'DisplayStyle','window');

return
end
