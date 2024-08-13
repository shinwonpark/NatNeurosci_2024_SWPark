function p = BoSurfStatPlotAllStats(slm, surf, mask, pclus, OUTPATH, prefix)

% colormaps 
bluered=[   ones(1,3)*0.8; ...
            [ones(128,1) linspace(0,253,128)'/254 zeros(128,1)]*0.8;...
            [ones(128,1) ones(128,1) linspace(0,253,128)'/254]*0.8;...
            ones(150,3)*0.8; ...
            [linspace(253,0,128)'/254 ones(128,1) ones(128,1)]*0.8;...
            [zeros(128,1) linspace(253,0,128)'/254 ones(128,1)]*0.8;...
        ];

blue =      [ones(1,3)*0.75; ...
             zeros(127,1)   (0:126)'/127   ones(127,1)];
blue =      flipud(blue);   
    
oldblue =      [zeros(1,3)*0.75; ...
             zeros(127,1)   (0:126)'/127   ones(127,1)];
oldblue =      flipud(oldblue);
          
red =       [ones(1,3)*0.75; ...
             ones(64,1) linspace(0,253,64)'/254 zeros(64,1); ...
             ones(64,1) ones(64,1) linspace(0,253,64)'/254];


% plotting                  
f = figure, 
    BoSurfStatViewData(slm.t,surf, num2str(slm.df))
    colormap(flipud(bluered)); 
    BoSurfStatColLim( [-5 5] );
    exportfigbo(f, [OUTPATH prefix 't.png'], 'png','10' );
close(f);


f = figure, 
    [pval,peak,clus]=SurfStatP(slm,mask, pclus )
    BoSurfStatView( pval, surf, num2str(slm.df) );
    exportfigbo(f, [OUTPATH prefix 'fwe.png'], 'png','10' );
close(f);


if isfield(pval,'C')
    f = figure, 
        BoSurfStatView( pval.C, surf, num2str(slm.df) );
        colormap(oldblue); 
        BoSurfStatColLim([0 0.05]);
        exportfigbo(f, [OUTPATH prefix 'fweclus.png'], 'png','10' ); 
    
end    
   
f = figure, 
    qval=SurfStatQ(slm,mask);
    BoSurfStatViewData( qval.Q, surf, num2str(slm.df) );
    colormap(blue); 
    cb = BoSurfStatColLim([0 0.05]);
    exportfigbo(f, [OUTPATH prefix 'fdr.png'], 'png','10' );
close(f);


p = 1 - tcdf(slm.t, slm.df); 
f = figure, 
    BoSurfStatViewData(p,surf,num2str(slm.df) );
    colormap(blue); 
    cb = BoSurfStatColLim([0 plcus]);
    exportfigbo(f, [OUTPATH prefix 'p.png'], 'png','10' );
close(f);


