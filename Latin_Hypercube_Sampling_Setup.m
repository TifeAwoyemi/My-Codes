function VRep = Latin_Hypercube_Sampling_Setup(m, a, name)
close all,

% R0min = 0.01;
% R0max = 1;
% 
% C0min = 0.01;
% C0max = 1;
% 
% 
% N = 20; 
% LH = lhsdesign(N,2);
% LH(:,1)=R0min+LH(:,1)*(R0max-R0min);
% LH(:,2)=C0min+LH(:,2)*(C0max-C0min);
% Vs = zeros(N, 1);
% 
% for n = 1:N
%    y0 = LH(n,:);
%    v = Hybrid_Model_Analysis(y0, m, a, name);
%    Vs(n) = v;
% end
% 
% VRep = uniquetol(Vs); 
% save([name, '-', num2str(m), '-', num2str(a), '.mat'], 'Vs', 'LH', 'VRep')
load([name, '-', num2str(m), '-', num2str(a), '.mat'], 'Vs', 'LH', 'VRep')
end





