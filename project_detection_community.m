function modular_mapping_surface = project_detection_community(detected_community, modularity, parcellation, S, figure_open)

% addpath('/data/noel/noel2/local/matlab/surfstat_chicago');
detected_community_temp = detected_community;
if(size(detected_community, 2) == 1)
    detected_community_temp = detected_community';
end

detected_community_surface = zeros(1, size(parcellation, 2));

communities = unique(detected_community_temp);

for i = 1 : size(communities, 2)
    community = find(detected_community_temp == communities(i));
    ia = [];
    for j = 1 : size(community, 2)
        ia = [ ia find(parcellation==community(j)) ];
    end    
    detected_community_surface(ia) = communities(i);    
end

mask=SurfStatMaskCut(S);
if(figure_open)
    figure; SurfStatView(detected_community_surface.*mask, S, [ 'Q = ' num2str(modularity) ]);
end

modular_mapping_surface = detected_community_surface;