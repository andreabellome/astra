function [LEGS_to_go, REVS_to_go, VINFd_to_go, VINFa_to_go, ...
    LEGS_to_ret, REVS_to_ret, VINFd_to_ret, VINFa_to_ret] = ...
    prune_sample_return(LEGS_to_go, REVS_to_go, VINFd_to_go, VINFa_to_go, ...
    LEGS_to_ret, REVS_to_ret, VINFd_to_ret, VINFa_to_ret, ...
    vinf_Earth_dep_min, dv_ast_arr_min, ...
    dv_ast_dep_min, vinf_Earth_arr_min, ...
    min_dep_date, max_dep_date )

% --> prune by VINF-DEP-EARTH and by DV-ARR-AST
indxs1                = find( VINFd_to_go >= vinf_Earth_dep_min | VINFa_to_go >= dv_ast_arr_min );
LEGS_to_go(indxs1,:)  = [];
REVS_to_go(indxs1,:)  = [];
VINFd_to_go(indxs1,:) = [];
VINFa_to_go(indxs1,:) = [];

% --> prune by launch date at Earth
if ~isempty(LEGS_to_go)
    
    indxs = find( LEGS_to_go(:,2) < min_dep_date | LEGS_to_go(:,2) > max_dep_date );

    LEGS_to_go(indxs,:)  = [];
    REVS_to_go(indxs,:)  = [];
    VINFd_to_go(indxs,:) = [];
    VINFa_to_go(indxs,:) = [];

end

% --> prune by DV-DEP-AST and by VINF-ARR-EARTH
indxs2                 = find( VINFd_to_ret >= dv_ast_dep_min | VINFa_to_ret >= vinf_Earth_arr_min );
LEGS_to_ret(indxs2,:)  = [];
REVS_to_ret(indxs2,:)  = [];
VINFd_to_ret(indxs2,:) = [];
VINFa_to_ret(indxs2,:) = [];

end