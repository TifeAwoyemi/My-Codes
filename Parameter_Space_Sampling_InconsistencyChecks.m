function VRep_SPSA_Checks

close all,
name = 'FineParametersAII';

load('FineParametersReading', 'Presence', 'mspan', 'aspan', 'checks');

checks = [0, 1, 2, 3, 4, 8, 16];

%%% This part of the code checks for birth-death parameter sets with a 
%%% different value from its neigboring parameter pairs and saves this pairs.

% for c = checks + 1
%     Pold = Presence{c};
%     Pnew = Pold(1:length(aspan), 1:length(mspan));
%     Presence{c} = Pnew;
% end 

% create aindices={}
% aindicesA = {};
% CheckedPresence = {Presence{1, 1}, Presence{1, 2}, Presence{1, 3}, ...
%     Presence{1, 4}, Presence{1, 5}, Presence{1, 9}, Presence{1, 17}};
% for pc = 1:length(CheckedPresence)
%     Presence = CheckedPresence{pc};
%     for mc  = 2:length(mspan)-1
%         m = mspan(mc);
%         %create aindcurr=[]
%         aindcurr = [];
%         for ac  = 2:length(aspan)-1
%             a = aspan(ac);
%             if Presence(ac - 1, mc - 1) ~= Presence(ac, mc)
%                aindcurr = [aindcurr, ac];
%             elseif Presence(ac - 1, mc) ~= Presence(ac, mc)
%                 aindcurr = [aindcurr, ac];
%             elseif Presence(ac - 1, mc + 1) ~= Presence(ac, mc)
%                 aindcurr = [aindcurr, ac];
%             elseif Presence(ac, mc + 1) ~= Presence(ac, mc)
%                 aindcurr = [aindcurr, ac];
%             elseif Presence(ac + 1, mc + 1) ~= Presence(ac, mc)
%                 aindcurr = [aindcurr, ac];
%             elseif Presence(ac + 1, mc) ~= Presence(ac, mc)
%                 aindcurr = [aindcurr, ac];
%             elseif Presence(ac + 1, mc - 1) ~= Presence(ac, mc)
%                 aindcurr = [aindcurr, ac];
%             elseif Presence(ac, mc - 1) ~= Presence(ac, mc)
%                 aindcurr = [aindcurr, ac];
%             end
%         end
%         aindicesA{mc} = aindcurr;
%     end
    % saveaindices
    % save(['aindicesA', '-', num2str(pc), '.mat'], 'aindicesA')
    % aindicesA = {};
% end

%%% This part of the code re-runs all the saved parameter sets from the code snipet 
%%% above for a much longer time to see if there is any change in the population behavior

Presencenew = {Presence{1, 1}, Presence{1, 2}, Presence{1, 3}, ...
    Presence{1, 4}, Presence{1, 5}, Presence{1, 9}, Presence{1, 17}};
for pc = 1:length(checks)
    load(['aindicesA', '-', num2str(pc)', '.mat'])
    if isempty(aindicesA) == 0
        for mindex  = 1:length(aindicesA)
            m = mspan(mindex);
            if isempty(aindicesA{1, mindex}) == 0
                for n = 1:length(aindicesA{1, mindex})
                    aindex  = aindicesA{1, mindex}(n);
                    a = aspan(aindex);
                    if isfile([name, '-', num2str(m), '-', num2str(a), '.mat']) == 0
                        VRep = lhsdesign_tife_SPSA(m, a, name);
                        for c = checks
                            if sum(c == VRep) > 0
                                Presencenew{c + 1}(aindex, mindex) = 1;
                            else
                                Presencenew{c + 1}(aindex, mindex) = 0; 
                            end
                        end
                    end
                end
            end
        end
    end
end
save([name, '.mat'], 'Presencenew', 'checks')

end
% X = ['no mu=', num2str(m), ' a= ', num2str(a), ' P= ', num2str(Presence(ac -1, mc - 1))];
%                disp(X)   
