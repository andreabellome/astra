function [ LEGSn, VASn, VINFn ] = prune_vilt_tour( LEGSprev, VASprev, VINFprev, LEGSn, VASn, VINFn, indleg, INPUT )

if ~isempty(find(indleg == INPUT.vilt_seq_index))

    if ~isnan(INPUT.decrease) 
    
        if ~isempty(INPUT.decrease) 
    
            if ~isempty(LEGSprev)
            
                if ~isempty(LEGSn)
                    
                    INDECES_TO_DEL = [];
                    for indl = 1:size(LEGSprev,1)
                        
                        pl_prev   = LEGSprev(indl,end-1);
                        t_prev    = LEGSprev(indl,end);
                        vinf_prev = VINFprev(indl,end);
            
                        indxs     = find( LEGSn(:,end-4) == pl_prev & LEGSn(:,end-3) == t_prev );
            
                        if ~isempty(indxs)
            
                            vinf_next = VINFn(indxs,end);
            
                            if INPUT.decrease == 1 % --> keep only those that DECREASE the infinity velocity
                                
                                inds_to_del = find( vinf_next > vinf_prev );
            
                                if ~isempty(inds_to_del)
                                    INDECES_TO_DEL = [ INDECES_TO_DEL; indxs(inds_to_del) ];
                                end
            
                            else % --> keep only those that INCREASE the infinity velocity
            
                                inds_to_del = find( vinf_next < vinf_prev );
            
                                if ~isempty(inds_to_del)
                                    INDECES_TO_DEL = [ INDECES_TO_DEL; indxs(inds_to_del) ];
                                end
            
                            end
            
                        end
            
                    end
                    
                    if ~isempty(INDECES_TO_DEL)
                        
                        LEGSn(INDECES_TO_DEL,:) = [];
                        VASn(INDECES_TO_DEL,:)  = [];
                        VINFn(INDECES_TO_DEL,:) = [];
            
                    end
            
                end
            
            end
    
        end
    
    end

end

end
