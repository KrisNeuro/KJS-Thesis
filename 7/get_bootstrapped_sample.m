function bootstats = get_bootstrapped_sample(variable,nboot,f_n)
    %This function performs a hierarchical bootstrap on the data present in 'variable'.
    %This function assumes that the data in 'variable' is in the format of a 2D array where
    %the rows represent the higher level (in this case, each row is a separate neuron) and
    %the number of columns represent repetitions within that level (trials).

    bootstats = zeros([nboot,f_n]);
    num_lev1 = size(variable,1);
    num_lev2 = size(variable,2);
    cou_lev1 = zeros([num_lev1,1]);
    
    for i = 1:num_lev1
        cou_lev1(i) = num_lev2-length(find(cellfun(@isempty, variable(i,:)))); % remove empty cell
    end
    clear i
    
    total_num = sum(cou_lev1);     % sample size
    pro_lev1 = cou_lev1/total_num; % calculate each neuron's weight
    
    %Matlab function 'randsrc'. Suppose you want to generate M by N matrix of W, X, Y, and Z with probabilities i,j,k,and l.
    
    lev_pro(1,:) = [1:num_lev1];
    lev_pro(2,:) = pro_lev1;
    
    boot_lev1 = randsrc(1,total_num,lev_pro);
    
    for i = 1:nboot
        temp = [];
        tic;
            for j = 1:total_num
                for k = 1:f_n
                    L = randi([1 cou_lev1(boot_lev1(j))],1);
                    temp_cell(k) = variable{boot_lev1(j),L}(k);
                end
                temp = [temp; temp_cell]; 
            end
            %bootstats = temp;
        bootstats(i,:) = mean(temp,1);
        
%         if mod(i, 1000) == 0 %uncomment if bootstrapping progress is  desired
%            disp(i);
%         end

    end
end
    