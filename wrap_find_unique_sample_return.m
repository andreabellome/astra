function [ov_LEG_TO_GO, ov_REVS_TO_GO, ov_VINF_DEP_TO_GO, ov_VINF_ARR_TO_GO, ...
         ov_LEG_TO_RE, ov_REVS_TO_RE, ov_VINF_DEP_TO_RE, ov_VINF_ARR_TO_RE, ...
         ov_STAY_DAYS, ov_TOF_YEARS_TOT] = wrap_find_unique_sample_return( structure )

if ~isempty(structure)

    % --> now fix launch and arrival dates --> only save those that have the minimum overall DV
    ov_LEG_TO_GO      = cell2mat({structure.LEG_TO_GO}');
    ov_REVS_TO_GO     = cell2mat({structure.REVS_TO_GO}');
    ov_VINF_DEP_TO_GO = cell2mat({structure.VINF_DEP_TO_GO}');
    ov_VINF_ARR_TO_GO = cell2mat({structure.VINF_ARR_TO_GO}');
    
    ov_LEG_TO_RE      = cell2mat({structure.LEG_TO_RE}');
    ov_REVS_TO_RE     = cell2mat({structure.REVS_TO_RE}');
    ov_VINF_DEP_TO_RE = cell2mat({structure.VINF_DEP_TO_RE}');
    ov_VINF_ARR_TO_RE = cell2mat({structure.VINF_ARR_TO_RE}');
    
    ov_STAY_DAYS      = cell2mat({structure.STAY_DAYS}');
    ov_TOF_YEARS_TOT  = cell2mat({structure.TOF_YEARS_TOT}');
    
    if ~isempty(ov_LEG_TO_GO)

        ov_COST_TOT = ov_VINF_DEP_TO_GO + ov_VINF_ARR_TO_GO + ov_VINF_DEP_TO_RE + ov_VINF_ARR_TO_RE;
        NODES       = [ ov_LEG_TO_GO( :,1:2 ) ov_LEG_TO_RE( :,end-1:end )  ];
        
        ov_mat = sortrows( [ NODES, ov_COST_TOT, [1:1:size(ov_COST_TOT,1)]' ], 5 );
        
        [~, ia] = unique(ov_mat(:,1:4), "rows", "stable");
        
        ov_LEG_TO_GO      = ov_LEG_TO_GO(ia,:);
        ov_REVS_TO_GO     = ov_REVS_TO_GO(ia,:);
        ov_VINF_DEP_TO_GO = ov_VINF_DEP_TO_GO(ia,:);
        ov_VINF_ARR_TO_GO = ov_VINF_ARR_TO_GO(ia,:);
        
        ov_LEG_TO_RE      = ov_LEG_TO_RE(ia,:);
        ov_REVS_TO_RE     = ov_REVS_TO_RE(ia,:);
        ov_VINF_DEP_TO_RE = ov_VINF_DEP_TO_RE(ia,:);
        ov_VINF_ARR_TO_RE = ov_VINF_ARR_TO_RE(ia,:);
        
        ov_STAY_DAYS      = ov_STAY_DAYS(ia,:);
        ov_TOF_YEARS_TOT  = ov_TOF_YEARS_TOT(ia,:);
    
    else

        ov_LEG_TO_GO      = [];
        ov_REVS_TO_GO     = [];
        ov_VINF_DEP_TO_GO = [];
        ov_VINF_ARR_TO_GO = [];
        
        ov_LEG_TO_RE      = [];
        ov_REVS_TO_RE     = [];
        ov_VINF_DEP_TO_RE = [];
        ov_VINF_ARR_TO_RE = [];
        
        ov_STAY_DAYS      = [];
        ov_TOF_YEARS_TOT  = [];

    end

else

    ov_LEG_TO_GO      = [];
    ov_REVS_TO_GO     = [];
    ov_VINF_DEP_TO_GO = [];
    ov_VINF_ARR_TO_GO = [];
    
    ov_LEG_TO_RE      = [];
    ov_REVS_TO_RE     = [];
    ov_VINF_DEP_TO_RE = [];
    ov_VINF_ARR_TO_RE = [];
    
    ov_STAY_DAYS      = [];
    ov_TOF_YEARS_TOT  = [];

end

end
