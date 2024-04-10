function [tau_up, currents_up, tau_down, currents_down] = get_tau_both()
options = optimset('MaxFunEvals',1000000, 'MaxIter', 10000);

% Read the txt files where the measurements are saved
currentFolder = pwd;
cd("measurements")
files = dir('*.txt');
cd(currentFolder)

% Extract from the file the value of voltage, current, position, time
for n_file = 1:length(files)
    nomefile = fopen(files(n_file).name);
    A_parziali{n_file} = (fscanf(nomefile, '%g %g', [4 inf]))';
end

A{1} = A_parziali{22};
A{2} = A_parziali{21};
A{3} = A_parziali{20};
A{4} = vertcat(A_parziali{18},A_parziali{19});
A{5} = A_parziali{17};
A{6} = vertcat(A_parziali{15},A_parziali{16});
A{7} = vertcat(A_parziali{13},A_parziali{14});
A{8} = vertcat(A_parziali{11},A_parziali{12});
A{9} = A_parziali{10};
A{10} = vertcat(A_parziali{8},A_parziali{9});
A{11} = A_parziali{7};
A{12} = vertcat(A_parziali{5},A_parziali{6});
A{13} = vertcat(A_parziali{3},A_parziali{4});
A{14} = vertcat(A_parziali{1},A_parziali{2});
A{15} = vertcat(A_parziali{25},A_parziali{26});
A{16} = vertcat(A_parziali{23},A_parziali{24});


current = cellfun(@(a) a(:,2), A,'uni',0);
time = cellfun(@(a) a(:,4), A,'uni',0);

for k = 1:length(A)
    Bup{k} = [];
    Cup{k} = [0.2];
    Bdown{k} = [];
    Cdown{k} = [3.85];
    
    start_point_up = find(time{k}==1);
    start_point_down = find(time{k}==16);
    count = 1;
        
    for i = 1:15
        if(i<=6)
            tau_approx_up = -34;
        elseif(i==8||i==7||i==9)
            tau_approx_up = -31.4;
         elseif(i==10)
            tau_approx_up = -47;
        elseif(i==11)
            tau_approx_up = -62.8;
        elseif(i==12)
            tau_approx_up = -76;
        elseif(i>=13)
            tau_approx_up = -126;
        end
        
        % Step raise
        curr_test_up = current{k}(start_point_up:start_point_up + 99);
        time_test_up = time{k}(start_point_up:start_point_up + 99);
        mean_C_test_up = mean(curr_test_up(20:100));
        
        t_up = time_test_up - time_test_up(1);
        f_up = @(b,t) b(1).*exp(b(2).*t)+b(3);
        Y_up = fminsearch(@(b) norm(curr_test_up - f_up(b,t_up)), [-(mean_C_test_up-0.2); tau_approx_up ; mean_C_test_up],options);
        
        Bup{k} = vertcat(Bup{k},Y_up(2));
        Cup{k} = vertcat(Cup{k},Y_up(3));
        
        f_up= Y_up(1)*exp(Y_up(2)*t_up)+Y_up(3);
        
        start_point_up = start_point_up+100;
        
        % Step drop
        tau_approx_down = [tau_approx_up(2:end) -126];

        if (start_point_down + 99 < length(time{k}) && count < 14)
            curr_test_down = current{k}(start_point_down:start_point_down + 99);
            time_test_down = time{k}(start_point_down:start_point_down + 99);
            mean_C_test_down = mean(curr_test_down(20:100));

            t_down = time_test_down - time_test_down(1);
            f_down = @(b,t) b(1).*exp(b(2).*t)+b(3);
            Y_down = fminsearch(@(b) norm(curr_test_down - f_down(b,t_down)), [-(mean_C_test_down-3.85); tau_approx_down ; mean_C_test_down],options);

            Bdown{k} = vertcat(Bdown{k},Y_down(2));
            Cdown{k} = vertcat(Cdown{k},Y_down(3));

            f_down= Y_down(1)*exp(Y_down(2)*t_down)+Y_down(3);

            start_point_down = start_point_down + 100;
            count = count+1;
        end
    end
end

B_up = cell2mat(Bup);
tau_up = -B_up.^(-1);
currents_up = cell2mat(Cup);
currents_up = currents_up(:,1);

B_down = cell2mat(Bdown);
tau_down = -B_down.^(-1);
currents_down = cell2mat(Cdown);
currents_down = currents_down(:,1);
end