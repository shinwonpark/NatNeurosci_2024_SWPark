%% Generative network modeling - Figures

%% -- Preparation ------------------------------------------
    %% 01) load toolboxes and define paths
    for pathtoolbox = 1

        %download the follwoing tools
        % surfstat
        % brainspace
        % cifti-matlab
        % BCT 
        % HCPPipelines
        % generative network modeling code - github: https://github.com/StuartJO/GenerativeNetworkModel
        
        WB_COMMAND = [ 'wb_command' ];
        addpath(genpath('/local_raid1/01_software/toolboxes/surfstat/'));   %SurfStatView
        addpath(genpath('/local_raid1/01_software/toolboxes/npy-matlab/')); %upload hcp_colormap
        addpath(genpath('/local_raid1/01_software/toolboxes/matlab_util/')); %BoSurfStatView
        addpath(genpath('/local_raid1/01_software/toolboxes/cifti-matlab/')); %used for gifti (uploading surfaces)
        addpath(genpath('./files'));
        addpath(genpath('/local_raid2/03_user/shinwon/03_software/BrainSpace/matlab')); %Brainspace
        
        addpath('/local_raid1/01_software/toolboxes/BCT_20190303/') %BCT
        %addpath('/local_raid3/03_user/shinwon/generative_network_model_analysis/01_analysis/0_reference/GenerativeNetworkModel_Oldham/GenerativeNetworkModel/data/Networks/')
        %addpath '/local_raid3/03_user/shinwon/generative_network_model_analysis/01_analysis/0_reference/GenerativeNetworkModel_Oldham/GenerativeNetworkModel/code/analysis'


    end

    %addpath '/local_raid2/03_user/shinwon/01_project/01_thalamusgradient/05_analysis_cmap_pmap'
    load('./files/yeo7_in_sch200_label.mat', 'yeo7_in_sch200')
    %figure; imagesc(yeo7_in_sch200); colormap(yeo_colormap)        
    %% 02) read phenotypic info
    for for_readdata=1
        %space_flag = '_10k' %'_10k' %_32k
        data = importfile_demo(['./files/demo_dHCP,HCPD_allAges_qcgrad.xlsx']);
        
    end    
    for for_demo_vars = 1
        age_w = data.age_in_weeks;
        age_y = data.age_in_years;
        sex = data.sex;
        subid = data.sub_id;
        study = data.dataset;    
        session = data.session;
        taskrest = data.task_rest;
        meanFD = data.meanFD;
        meanFD04 = data.MeanFD04;
        qc_grad = data.qc_grad;

        idx_hcpd = find( (study == 'HCPD') & (session == 'session1') & (qc_grad == 1) & (meanFD04 == 1));

        age_w_hcpd = age_w(idx_hcpd);
        age_y_hcpd = age_y(idx_hcpd);
        sex_hcpd = sex(idx_hcpd);
        sex_hcpd = cellstr(sex_hcpd);
        subid_hcpd = subid(idx_hcpd);
        meanFD_hcpd = meanFD(idx_hcpd);        

        idx_hcpd_8_10y = find (age_y_hcpd < 10) ;  
        idx_hcpd_10_13y = find (age_y_hcpd >= 10 & age_y_hcpd < 13) ;  
        idx_hcpd_13_16y = find (age_y_hcpd >= 13 & age_y_hcpd < 16) ;  
        idx_hcpd_16_20y = find (age_y_hcpd >= 16 & age_y_hcpd < 20) ;  
        idx_hcpd_20_22y = find (age_y_hcpd >= 20) ;  


        idx_age_8_12y =find(age_y_hcpd<12);
        idx_age_12_18y =find(age_y_hcpd>=12 & age_y_hcpd<18);
        idx_age_18_22y =find(age_y_hcpd>18);     

    end
    %% 03) Load surfaces & parcellations & colormaps

    for for_load_surfaces = 1

        %upload 10k surfaces: fsLR space         
        temp = gifti(['./files/S900.R.midthickness_MSMAll.10k_fs_LR.surf.gii']);
        surfR.coord = temp.vertices';
        surfR.tri   = temp.faces;   

        temp = gifti(['./files/S900.L.midthickness_MSMAll.10k_fs_LR.surf.gii']);
        %temp = gifti([ PATH '01_analysis/03_surface/MNI152_T1_1mm.L.very_inflated.10k_fs_LR.surf.gii']);
        surfL.coord = temp.vertices';
        surfL.tri   = temp.faces;

        surf.coord = [ surfL.coord surfR.coord ];
        surf.tri   = [ surfL.tri; surfR.tri+10242; ];

        %temp = gifti('/local_raid1/01_software/HCPpipelines/global/templates/standard_mesh_atlases/L.atlasroi.10k_fs_LR.shape.gii');
        temp = gifti(['./files/L.atlasroi.10k_fs_LR.shape.gii']);
        surfL_roi = temp.cdata';     
        temp = gifti(['./files/R.atlasroi.10k_fs_LR.shape.gii']);
        surfR_roi = temp.cdata'; 

        surf_roi = cat(2,surfL_roi, surfR_roi);
        figure; SurfStatView(surf_roi,surf);        

        for parcel_10k = 1
            for load_schaefers_400_parcel = 1
                schaefer_400 = ciftiopen(['./files/Schaefer2018_400Parcels_7Networks_order_10k.dlabel.nii'],  WB_COMMAND); 
                schaefer_400_label = schaefer_400.cdata;  
                schaefer_400_full = zeros(20482,1); 
                schaefer_400_full(logical(surf_roi)) = schaefer_400_label;
               
                figure; SurfStatView(schaefer_400_full,surf);
                schaefer_400_label = schaefer_400_full;                      
            end      
            for load_yeo_7networks_cortex = 1
               cii_yeo = ciftiopen( ['./files/RSN-networks.10k_fs_LR.dlabel.nii'],  WB_COMMAND);
               cii_yeo_label = cii_yeo.cdata;       

                yeo_7_label = cii_yeo_label(:,1);
                yeo_7_label(yeo_7_label==37) = 0;
                yeo_7_label(yeo_7_label==38) = 3;
                yeo_7_label(yeo_7_label==39) = 6;
                yeo_7_label(yeo_7_label==40) = 7;
                yeo_7_label(yeo_7_label==41) = 1;
                yeo_7_label(yeo_7_label==42) = 5;
                yeo_7_label(yeo_7_label==43) = 2;
                yeo_7_label(yeo_7_label==44) = 4;      

                yeo_17_label = cii_yeo_label(:,2);
                yeo_17_label(yeo_17_label==37) = 0;   
                yeo_17_label(yeo_17_label==45) = 2;   
                yeo_17_label(yeo_17_label==46) = 16;   
                yeo_17_label(yeo_17_label==47) = 6;   
                yeo_17_label(yeo_17_label==48) = 12;   
                yeo_17_label(yeo_17_label==49) = 10;   
                yeo_17_label(yeo_17_label==50) = 5;   
                yeo_17_label(yeo_17_label==51) = 13;   
                yeo_17_label(yeo_17_label==52) = 17;   
                yeo_17_label(yeo_17_label==53) = 15;   
                yeo_17_label(yeo_17_label==54) = 1;   
                yeo_17_label(yeo_17_label==55) = 4;   
                yeo_17_label(yeo_17_label==56) = 9;   
                yeo_17_label(yeo_17_label==57) = 11;   
                yeo_17_label(yeo_17_label==58) = 3;   
                yeo_17_label(yeo_17_label==59) = 8;   
                yeo_17_label(yeo_17_label==60) = 7;   
                yeo_17_label(yeo_17_label==61) = 14;   

                yeo_7_label_full = zeros(1,20484); 
                yeo_7_label_full(logical(surf_roi)) = yeo_7_label'
                figure; SurfStatView(yeo_7_label_full,surf);

            end    
            for load_schaefers_200_parcel = 1
                schaefer_200 = ciftiopen([ './files/Schaefer2018_200Parcels_7Networks_order.10k.dlabel.nii'],  WB_COMMAND); 
                %figure; plot_hemispheres(schaefer_400.cdata, {surf_lh,surf_rh});
                %figure; SurfStatView(schaefer_400.cdata,surf);
                schaefer_200_label = schaefer_200.cdata;  


                schaefer_200_full = zeros(20482,1); 
                schaefer_200_full(logical(surf_roi)) = schaefer_200_label;

                figure; SurfStatView(schaefer_200_full,surf);
                schaefer_200_label = schaefer_200_full;                    


        end      
        end   

    end    
    for for_colormap_load=1
        defaultCmap = [102,103,171;...
        204,185,126;...
        210,147,128;]./255;
    
        videenmap = videen(20); videenmap(1:19,:)
        videenmap = [ videenmap; 0.7 0.7 0.7 ];
        hcp_colormap = readNPY([ './files/hcp_colormap.npy' ]);
        yeo_colormap = [ 200 200 200;    
                     120 18 134;
                     70 130 180;
                     0 118 14;
                     196 58 250;
                     220 248 164;
                     230 148 34;
                     205 62 78 ]/255;
        yeo_colormap_1=yeo_colormap(2:end,:);

    %
        values = [...
            'CC'; '10'; '33'; %_rbgyr20_01
            '99'; '20'; '66'; %_rbgyr20_02
            '66'; '31'; '99'; %_rbgyr20_03
            '34'; '41'; 'CC'; %_rbgyr20_04
            '00'; '51'; 'FF'; %_rbgyr20_05
            '00'; '74'; 'CC'; %_rbgyr20_06
            '00'; '97'; '99'; %_rbgyr20_07
            '00'; 'B9'; '66'; %_rbgyr20_08
            '00'; 'DC'; '33'; %_rbgyr20_09
            '00'; 'FF'; '00'; %_rbgyr20_10
            '33'; 'FF'; '00'; %_rbgyr20_11
            '66'; 'FF'; '00'; %_rbgyr20_12
            '99'; 'FF'; '00'; %_rbgyr20_13
            'CC'; 'FF'; '00'; %_rbgyr20_14
            'FF'; 'FF'; '00'; %_rbgyr20_15
            'FF'; 'CC'; '00'; %_rbgyr20_16
            'FF'; '99'; '00'; %_rbgyr20_17
            'FF'; '66'; '00'; %_rbgyr20_18
            'FF'; '33'; '00'; %_rbgyr20_19
            'FF'; '00'; '00';]; %_rbgyr20_20

        values = reshape(hex2dec(values), [3 numel(values)/6])' ./ 255;

        P = size(values,1); 
        rbgyr20_colormap = interp1(1:size(values,1), values, linspace(1,P,200), 'linear');    


         values2 = [ 158,1,66;    
                     213,62,79;
                     244,109,67;
                     253,174,97;
                     254,224,139; 
                     255,255,191;
                     230,245,152;
                     171,221,164;
                     102,194,165;
                     50,136,189;
                     94,79,162;
                     ]/255;   

        P = size(values2,1); 
        spectral_colormap = interp1(1:size(values2,1), values2, linspace(1,P,200), 'linear');      


        addpath(genpath('./files/customcolormap'));

        pasteljet=customcolormap_preset('pasteljet');
        rdylbl=customcolormap_preset('red-yellow-blue');
        rdwhbl=customcolormap_preset('red-white-blue');


    end
    
%% Generative network modeling - analysis
% prepare input files -> refer to code_Fig5_prepare_inputs_HCPD.m script
% run GNM scripts from https://github.com/StuartJO/GenerativeNetworkModel
    
%% Figure 5: upload data

% load results from generative network modeling analysis 
load('sourceData_Fig5_ExtFig7_HCPD_GNM.mat')

%using OptimMdl
for i=1:603 % #subjects 
    
    temp1(:,:,i) = a.OptimMdl{1, 1}.min_maxKS.adjmat{1, i};
    temp2(:,:,i) = a.OptimMdl{1, 2}.min_maxKS.adjmat{1, i};
    temp3(:,:,i) = a.OptimMdl{1, 3}.min_maxKS.adjmat{1, i};
    temp4(:,:,i) = a.OptimMdl{1, 4}.min_maxKS.adjmat{1, i};
    temp5(:,:,i) = a.OptimMdl{1, 5}.min_maxKS.adjmat{1, i};
    temp6(:,:,i) = a.OptimMdl{1, 6}.min_maxKS.adjmat{1, i};
    temp7(:,:,i) = a.OptimMdl{1, 7}.min_maxKS.adjmat{1, i};
    
end

%'Spatial','Spatial+ThalCort','ThalCort','Spatial+uCGE','uCGE','Thalcort+uCGE','Matching'
    adjmat_mdl1_mean = mean(temp1, 3);
    adjmat_mdl2_mean = mean(temp2, 3);
    adjmat_mdl3_mean = mean(temp3, 3);
    adjmat_mdl4_mean = mean(temp4, 3);
    adjmat_mdl5_mean = mean(temp5, 3);
    adjmat_mdl6_mean = mean(temp6, 3);
    adjmat_mdl7_mean = mean(temp7, 3);  
    
    %% Figure 5A: Model performance (& Ext Figure 7)
    % code adopted from https://github.com/StuartJO/GenerativeNetworkModel/code/figures:
   
    for for_main_3_models=1

        LABELS = {'Spatial','ThalCort','uCGE',};
        MDLTYPES = {'Spatial','Thal-Cort','uCGE'};

        phys_nStatisticalComparisons = (3*2)/2;

        figure('Position',[233 364 1388 566])
        ax1 = axes('Position',[0.0891    0.3888    0.9015    0.4593]);
        
        %'Spatial','Spatial+ThalCort','ThalCort','Spatial+uCGE','uCGE','Thalcort+uCGE','Matching'
        DATA = a.min_maxKS;
        MAIN3 = DATA([1,3,5]);

        %change color in PlotMdlResults_spark and then run
        [ordered_mdl_data,V,mdl_order,~,~,lgd1,lgd2] = PlotMdlResults_spark(MAIN3,LABELS,'GrpNames',{'Static'},...
        'DataLabel','\it{KS_{max}}','SigLvl',phys_nStatisticalComparisons,'MdlTypesInd',[1 2 3],'MdlTypesNames',MDLTYPES);
        lgd1.Position(2) = 0.91;
        lgd2.Position(2) = 0.8399;
        ax1.Position(2) = 0.3717;
        ax1.XLabel.Position = [10.5000 -0.17 1];
        set(gcf,'color','w'); %grid on
        %exportgraphics(gcf,[FIGURE_LOCATION,'/Figure_HCPD1_3models.png'],'resolution',1000)

        %close all

        sig=0.001
        Ncorr=3
        %ordered_mdl_data = 'ThalCort','uCGE','Spatial'
        % FIGURE 5A -> significance testing
        [h,p,ci,stats] =ttest(ordered_mdl_data{1}, ordered_mdl_data{2},'Alpha',sig/Ncorr) %thal vs. gene
        [h,p,ci,stats] =ttest(ordered_mdl_data{1}, ordered_mdl_data{3},'Alpha',sig/Ncorr) %thal vs spatial
        [h,p,ci,stats] =ttest(ordered_mdl_data{2}, ordered_mdl_data{3},'Alpha',sig/Ncorr) %gene vs spatial

    end
    for for_all_models=1
        % change the color map in PlotMdlResults_spark.m

        LABELS = {'Spatial','Spatial+ThalCort','ThalCort','Spatial+uCGE','uCGE','Thalcort+uCGE','Matching'};
        MDLTYPES = {'Spatial','Homophilly','Thal-Cort','uCGE'};

        phys_nStatisticalComparisons = (7*6)/2;

        figure('Position',[233 364 1388 566])
        ax1 = axes('Position',[0.0891    0.3888    0.9015    0.4593]);
        DATA_ALL = a.min_maxKS;

        [ordered_mdl_data,V,mdl_order,~,~,lgd1,lgd2] = PlotMdlResults_spark(DATA_ALL,LABELS,'GrpNames',{'Static'},...
        'DataLabel','\it{KS_{max}}','SigLvl',phys_nStatisticalComparisons,'MdlTypesInd',[1 3 3 4 4 3 2],'MdlTypesNames',MDLTYPES);

        lgd1.Position(2) = 0.91;
        lgd2.Position(2) = 0.8399;
        ax1.Position(2) = 0.3717;
        ax1.XLabel.Position = [10.5000 -0.17 1];
        set(gcf,'color','w'); %grid on
        %exportgraphics(gcf,[FIGURE_LOCATION,'/Figure_HCPD1.png'],'resolution',1000)

        %close all
        
    end    
    
    %% Figure 5B: surface gradient

    %using Spatial
    conn_matrix1=adjmat_mdl1_mean;
    %figure;imagesc(conn_matrix1)
    
    gm_typ = GradientMaps('kernel', 'cs', 'approach', 'dm');
    gm_typ = gm_typ.fit(conn_matrix1,'sparsity', 90 );
    scree_plot(gm_typ.lambda{1});

    project_detection_community_boview(gm_typ.gradients{1}(:,1)*-1,'', schaefer_200_label(1:10242,1),surfL,1);
    BoSurfStatColLim([prctile(gm_typ.gradients{1}(:,1)*-1,1) prctile(gm_typ.gradients{1}(:,1)*-1,99)]); colormap(flipud(hcp_colormap(:,1:3)));
    project_detection_community_boview(gm_typ.gradients{1}(:,2),'', schaefer_200_label(1:10242,1),surfL,1);
    BoSurfStatColLim([prctile(gm_typ.gradients{1}(:,2)*-1,10) prctile(gm_typ.gradients{1}(:,2)*-1,90)]); colormap((hcp_colormap(:,1:3)));

    %using Thalcort
    conn_matrix3=adjmat_mdl3_mean;
    conn_matrix3(conn_matrix3==0)=0.00000000001;

    gm_typ = GradientMaps('kernel', 'na', 'approach', 'dm');
    gm_typ = gm_typ.fit(conn_matrix3,'sparsity', 90 );
    scree_plot(gm_typ.lambda{1});
    
    project_detection_community_boview(gm_typ.gradients{1}(:,1),'', schaefer_200_label(1:10242,1)',surfL,1);
    BoSurfStatColLim([-0.1 0.16]); colormap((hcp_colormap(:,1:3)));
    project_detection_community_boview(gm_typ.gradients{1}(:,2),'', schaefer_200_label(1:10242,1)',surfL,1);
    BoSurfStatColLim([prctile(gm_typ.gradients{1}(:,2)*-1,10) prctile(gm_typ.gradients{1}(:,2)*-1,90)]); colormap((hcp_colormap(:,1:3)));


    %using uCGE
    conn_matrix5=adjmat_mdl5_mean;

    gm_typ = GradientMaps('kernel', 'na', 'approach', 'dm');
    gm_typ = gm_typ.fit(conn_matrix5,'sparsity', 90 );
    scree_plot(gm_typ.lambda{1});
    
    project_detection_community_boview(gm_typ.gradients{1}(:,1),'', schaefer_200_label(1:10242,1),surfL,1);
    BoSurfStatColLim([-0.1 0.15]); colormap((hcp_colormap(:,1:3)));
    project_detection_community_boview(gm_typ.gradients{1}(:,2),'', schaefer_200_label(1:10242,1),surfL,1);
    BoSurfStatColLim([-0.08 0.11]); colormap(hcp_colormap(:,1:3));
    
    %% Figure 5C - Comparison of network modularity
     [M_1,Q_1]=community_louvain(adjmat_mdl1_mean);
     [M_2,Q_2]=community_louvain(adjmat_mdl2_mean);
     [M_3,Q_3]=community_louvain(adjmat_mdl3_mean);
     [M_4,Q_4]=community_louvain(adjmat_mdl4_mean);
     [M_5,Q_5]=community_louvain(adjmat_mdl5_mean);
     [M_6,Q_6]=community_louvain(adjmat_mdl6_mean);
     [M_7,Q_7]=community_louvain(adjmat_mdl7_mean);

     for i = 1:603
        [M,Q]=community_louvain(temp1(:,:,i));
        Q_ind_1 (i) = Q;
        [M,Q]=community_louvain(temp2(:,:,i));
        Q_ind_2 (i) = Q;
        [M,Q]=community_louvain(temp3(:,:,i));
        Q_ind_3 (i) = Q;
        [M,Q]=community_louvain(temp4(:,:,i));
        Q_ind_4 (i) = Q;
        [M,Q]=community_louvain(temp5(:,:,i));
        Q_ind_5 (i) = Q;
        [M,Q]=community_louvain(temp6(:,:,i));
        Q_ind_6 (i) = Q;
        [M,Q]=community_louvain(temp7(:,:,i));
        Q_ind_7 (i) = Q;

     end

     % ANOVA 
     Q_ind_all = cat(2, Q_ind_3, Q_ind_5, Q_ind_1);
    t1 = ones(603,1);
    t2 = 2.*ones(603,1);
    t3 = 3.*ones(603,1);

     Group_ind_all  = cat(1, t1, t2, t3);

     [p,anovatab,stats] =  anova1(Q_ind_all, Group_ind_all);
     set(gcf, 'color', 'w');
     c= multcompare(stats);
     c= multcompare(stats,'CType','tukey-kramer') ;
     c= multcompare(stats,'CType','bonferroni') ;

         % violin plot     
         for for_violin_plot = 1
             data = [Q_ind_3', Q_ind_5', Q_ind_1'];
             xlabel_data = {'ThalCort','uCGE','Spatial'}
                defaultCmap = [102,103,171;...
                204,185,126;...
                210,147,128;]./255;

             figure; violin(data, 'xlabel', xlabel_data, 'facecolor',defaultCmap)
             set(gcf, 'color', 'w'); ylim([0 0.7]); grid
             set(gca, 'FontSize', 16); grid on;


         end
    %% Figure 5D: segregation index bar graph - individual variance
%Vis 1:14
%SomMot 15:30
%DorsAttn 31:43
%SalVentAttn 44:54
%Limbic 55:60
%Cont 61:73
%Default 74:100

   for age_all = 1
           
       for i=1:length(temp1)
               %spatial
            btn_mdl1_vandansen_allAges_ind(i)=mean(temp1(44:54, 31:43, i),'all');
            btn_mdl1_vandmn_allAges_ind(i)=mean(temp1(44:54, 74:100, i),'all');
               
            wtn_mdl1_van_allAges_ind(i)=mean(temp1(44:54, 44:54, i),'all');
            wtn_mdl1_dansen_allAges_ind(i)=mean(temp1(1:43, 1:43, i),'all')  ;             
            wtn_mdl1_dmn_allAges_ind(i)=mean(temp1(74:100, 74:100, i),'all');
            
            r_mdl1_vandmn_allAges_ind(i) = abs(mean([wtn_mdl1_van_allAges_ind(i) wtn_mdl1_dmn_allAges_ind(i)])-btn_mdl1_vandmn_allAges_ind(i));
            r_mdl1_vandansen_allAges_ind(i) = abs(mean([wtn_mdl1_van_allAges_ind(i) wtn_mdl1_dansen_allAges_ind(i)])-btn_mdl1_vandansen_allAges_ind(i));
        
                %thalcort
            btn_mdl3_vandansen_allAges_ind(i)=mean(temp3(44:54, 31:43, i),'all');
            btn_mdl3_vandmn_allAges_ind(i)=mean(temp3(44:54, 74:100, i),'all');
               
            wtn_mdl3_van_allAges_ind(i)=mean(temp3(44:54, 44:54, i),'all');
            wtn_mdl3_dansen_allAges_ind(i)=mean(temp3(1:43, 1:43, i),'all')  ;             
            wtn_mdl3_dmn_allAges_ind(i)=mean(temp3(74:100, 74:100, i),'all');
            
            r_mdl3_vandmn_allAges_ind(i) = abs(mean([wtn_mdl3_van_allAges_ind(i) wtn_mdl3_dmn_allAges_ind(i)])-btn_mdl3_vandmn_allAges_ind(i));
            r_mdl3_vandansen_allAges_ind(i) = abs(mean([wtn_mdl3_van_allAges_ind(i) wtn_mdl3_dansen_allAges_ind(i)])-btn_mdl3_vandansen_allAges_ind(i));
        
                %gene
            btn_mdl5_vandansen_allAges_ind(i)=mean(temp5(44:54, 31:43, i),'all');
            btn_mdl5_vandmn_allAges_ind(i)=mean(temp5(44:54, 74:100, i),'all');
               
            wtn_mdl5_van_allAges_ind(i)=mean(temp5(44:54, 44:54, i),'all');
            wtn_mdl5_dansen_allAges_ind(i)=mean(temp5(1:43, 1:43, i),'all')  ;             
            wtn_mdl5_dmn_allAges_ind(i)=mean(temp5(74:100, 74:100, i),'all');
            
            r_mdl5_vandmn_allAges_ind(i) = abs(mean([wtn_mdl5_van_allAges_ind(i) wtn_mdl5_dmn_allAges_ind(i)])-btn_mdl5_vandmn_allAges_ind(i));
            r_mdl5_vandansen_allAges_ind(i) = abs(mean([wtn_mdl5_van_allAges_ind(i) wtn_mdl5_dansen_allAges_ind(i)])-btn_mdl5_vandansen_allAges_ind(i));
        
           end
           
   a1= [r_mdl3_vandansen_allAges_ind, r_mdl5_vandansen_allAges_ind,r_mdl1_vandansen_allAges_ind ];
   a1_meanValues = [mean(r_mdl3_vandansen_allAges_ind), mean(r_mdl5_vandansen_allAges_ind), mean(r_mdl1_vandansen_allAges_ind)];
   a1_stdValues = [std(r_mdl3_vandansen_allAges_ind), std(r_mdl5_vandansen_allAges_ind), std(r_mdl1_vandansen_allAges_ind)];

   figure; 
   b=bar( a1_meanValues ); 
   ylim([0 0.5]);yticks(0:0.1:0.5);  % Sets y-axis ticks at intervals of 1 from 0 to 10.
   b.FaceColor = 'flat'; 
   b.CData(1,:) = [defaultCmap(1,:)];
   b.CData(2,:) = [defaultCmap(2,:)];
   b.CData(3,:) = [defaultCmap(3,:)];
   box off; set(gcf, 'color', 'white');
   set(gca, 'XTickLabel', [], 'XTick', [], 'FontSize', 16); grid on;
   hold on;    
   ngroups = length(a1_meanValues);
   xScatter = [];
   groupIndex = [];
   allData = {r_mdl3_vandansen_allAges_ind, r_mdl5_vandansen_allAges_ind, r_mdl1_vandansen_allAges_ind};
    for i = 1:ngroups
        currentGroupData = allData{i};
        n = length(currentGroupData);
        xScatter = [xScatter ; ones(n,1)*i];
        groupIndex = [groupIndex ; currentGroupData'];
    end
    scatter(xScatter, groupIndex, 10, 'filled', 'MarkerFaceAlpha', 0.3, 'MarkerFaceColor', [0.5 0.5 0.5], 'jitter','on', 'jitterAmount',0.3);
    hold on;     
   x = (1:ngroups)';
   errorbar(x, a1_meanValues, a1_stdValues, '.k');
   hold off;

   b1= [r_mdl3_vandmn_allAges_ind, r_mdl5_vandmn_allAges_ind, r_mdl1_vandmn_allAges_ind];
   b1_meanValues = [mean(r_mdl3_vandmn_allAges_ind), mean(r_mdl5_vandmn_allAges_ind), mean(r_mdl1_vandmn_allAges_ind)];
   b1_stdValues = [std(r_mdl3_vandmn_allAges_ind), std(r_mdl5_vandmn_allAges_ind), std(r_mdl1_vandmn_allAges_ind)];
   
   figure; 
   b=bar( b1_meanValues ); 
   ylim([0 0.5]);yticks(0:0.1:0.5);  % Sets y-axis ticks at intervals of 1 from 0 to 10.
   b.FaceColor = 'flat'; 
   b.CData(1,:) = [defaultCmap(1,:)];
   b.CData(2,:) = [defaultCmap(2,:)];
   b.CData(3,:) = [defaultCmap(3,:)];
   box off; set(gcf, 'color', 'white');
   set(gca, 'XTickLabel', [], 'XTick', [], 'FontSize', 16); grid on;
   hold on;    
   ngroups = length(b1_meanValues);
   xScatter = [];
   groupIndex = [];
   allData = {r_mdl3_vandmn_allAges_ind, r_mdl5_vandmn_allAges_ind, r_mdl1_vandmn_allAges_ind};
    for i = 1:ngroups
        currentGroupData = allData{i};
        n = length(currentGroupData);
        xScatter = [xScatter ; ones(n,1)*i];
        groupIndex = [groupIndex ; currentGroupData'];
    end
    scatter(xScatter, groupIndex, 10, 'filled', 'MarkerFaceAlpha', 0.3, 'MarkerFaceColor', [0.5 0.5 0.5], 'jitter','on', 'jitterAmount',0.3);
    hold on;     
   x = (1:ngroups)';
   errorbar(x, b1_meanValues, b1_stdValues, '.k');
   hold off;
           
        
    end
    