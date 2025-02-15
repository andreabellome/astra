function [seq_to_go, seq_to_re, res_to_go, res_to_re, leg_to_go, revs_to_go, ...
 vinf_dep_to_go, vinf_arr_to_go, leg_to_re, revs_to_re, vinf_dep_to_re, ...
 vinf_arr_to_re, stay_days, tof_years_tot, tof_days_to_go, tof_days_to_re, ...
 cost_tot, dep_dates] = extract_info_sample_return(SAMPLE_RETURN, ind_sample)

seq_to_go       = SAMPLE_RETURN(ind_sample).seq_to_go;
seq_to_re       = SAMPLE_RETURN(ind_sample).seq_to_re;

res_to_go       = SAMPLE_RETURN(ind_sample).res_to_go;
res_to_re       = SAMPLE_RETURN(ind_sample).res_to_re;

leg_to_go       = SAMPLE_RETURN(ind_sample).LEG_TO_GO;
revs_to_go      = SAMPLE_RETURN(ind_sample).REVS_TO_GO;
vinf_dep_to_go  = SAMPLE_RETURN(ind_sample).VINF_DEP_TO_GO;
vinf_arr_to_go  = SAMPLE_RETURN(ind_sample).VINF_ARR_TO_GO;

leg_to_re       = SAMPLE_RETURN(ind_sample).LEG_TO_RE;
revs_to_re      = SAMPLE_RETURN(ind_sample).REVS_TO_RE;
vinf_dep_to_re  = SAMPLE_RETURN(ind_sample).VINF_DEP_TO_RE;
vinf_arr_to_re  = SAMPLE_RETURN(ind_sample).VINF_ARR_TO_RE;

stay_days       = SAMPLE_RETURN(ind_sample).STAY_DAYS;
tof_years_tot   = SAMPLE_RETURN(ind_sample).TOF_YEARS_TOT;

tof_days_to_go  = SAMPLE_RETURN(ind_sample).tof_days_to_go;
tof_days_to_re  = SAMPLE_RETURN(ind_sample).tof_days_to_re;

cost_tot  = vinf_dep_to_go + vinf_arr_to_go + vinf_dep_to_re + vinf_arr_to_re;
dep_dates = leg_to_go(:,2);

end