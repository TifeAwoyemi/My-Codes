function Parameter_Space_Sampling

close all,

name = 'FineParametersD';

mspan = 0.01:0.01:1; 
aspan = 15:-0.1:0.1;

Presence = {};
checks = [0, 1, 2, 3, 4, 8, 16];

for c = checks + 1
    Presence{c} = zeros(length(mspan), length(aspan));
end

for mc  = 1:length(mspan)
    m = mspan(mc);
    for ac  = 1:length(aspan)
        a = aspan(ac);
        VRep = Parameter_Space_Sampling(m, a, name);
        for c = checks
            if sum(c == VRep) > 0
                Presence{c + 1}(ac, mc) = 1;
            else
                Presence{c + 1}(ac, mc) = 0; 
            end
        end
    end
end

save([name, '.mat'], 'Presence', 'mspan', 'aspan', 'checks')

% load([name, '.mat'], 'Presence', 'mspan', 'aspan', 'checks')
for c = checks + 1
    Pold=Presence{c};
    Pnew=Pold(1:length(aspan),1:length(mspan));
    Presence{c} = Pnew;
end

checks = [0, 1, 2, 3, 4, 8, 16];
% checks = 0:1:16;
plotVs(checks, mspan, aspan, Presence)

end

function plotVs(checks, mspan, aspan, Presence)
for c = checks
    P = Presence{c + 1};
    figure,
    imagesc(P),
    xticks(0:10:100)
    mspanshort={'0','0.1','0.2', '0.3','0.4', '0.5', '0.6','0.7','0.8', ...
        '0.9','1'};
    yticks(0:10:150)
    aspanshort={'15', '14', '13', '12', '11', '10', '9','8', '7', '6', ...
        '5', '4', '3', '2','1', '0'};
    set(gca,'YtickLabel', aspanshort)
    set(gca,'XtickLabel', mspanshort)
    xlabel('mu'), ylabel('alpha'),
    colorbar
    title(['Possibility of ', num2str(c), ' final value'])
    % Save the figure
    saveas(gcf, ['Po', num2str(c), '.fig'])
    saveas(gcf, ['Po', num2str(c), '.png'])
end

end
