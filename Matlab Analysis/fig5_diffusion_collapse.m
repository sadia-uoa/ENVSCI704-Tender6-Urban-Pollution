%% fig5_diffusion_collapse.m  -  Fig 5. Diffusion rate vs collapse time
% ENVSCI 704 Tender 6 - Urban pollution
% Reads fig5_diffusion_collapse.xlsx (columns: level, level_order, run, collapse_time) and draws:
%   grey dots = each single run (jittered sideways so they do not overlap)
%   blue line = mean of the runs that were included
% Empty cells in the Excel file = runs left out (read as NaN) and are not plotted or averaged.
% HOW TO RUN: keep this file and the .xlsx in the same folder, then press Run (F5).

clear; clc; close all;
rng(1);                                      % same jitter every time

T  = readtable('fig5_diffusion_collapse.xlsx');   % read the data
y  = T.collapse_time;                        % values to plot
x  = T.level_order;                          % 1,2,3... = position of each level on the x axis
lv = string(T.level);                        % level names (used as x labels)
ok = ~isnan(y);                              % true for runs that were included
n  = max(x);                                 % number of levels

labels = strings(1, n);                      % x axis labels
m      = nan(1, n);                          % mean of each level
for k = 1:n
    labels(k) = lv(find(x == k, 1));
    m(k) = mean(y(x == k & ok));             % mean of included runs only
end

jit = (rand(size(x)) - 0.5) * 0.3;           % random sideways shift

figure('Color', 'w', 'Position', [100 100 620 420]); hold on;
scatter(x(ok) + jit(ok), y(ok), 22, [0.6 0.6 0.6], 'filled', 'MarkerFaceAlpha', 0.8);
plot(1:n, m, '-o', 'Color', [0 0.447 0.741], 'LineWidth', 2, 'MarkerFaceColor', [0 0.447 0.741]);
set(gca, 'XTick', 1:n, 'XTickLabel', labels, 'Box', 'on');
grid on; xlim([0.5 n + 0.5]);
xlabel('diffusion-rate'); ylabel('Ticks until everyone is gone (collapse time)');
title('Fig 5. Diffusion rate vs collapse time', 'FontSize', 10);
legend({'single runs', 'mean of included runs'}, 'Location', 'best', 'Box', 'off');

saveas(gcf, 'fig5_diffusion_collapse.png');  % save the picture

% numbers for the report (n, mean, median, min, max per level)
for k = 1:n
    v = y(x == k & ok);
    fprintf('%-10s n=%2d  mean=%9.4f  median=%9.4f  min=%9.4f  max=%9.4f\n', labels(k), numel(v), mean(v), median(v), min(v), max(v));
end