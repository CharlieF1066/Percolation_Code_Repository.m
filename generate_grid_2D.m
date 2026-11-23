function grid = generate_grid(L,p)
    grid = zeros(L,L);
    label = 1;
    % run a 1D percolation in each row of the grid
    for i = 1:L
        grid(i,1)= label;
        for j = 2:L
            x = rand;
            if x < p
                grid(i,j) = label;
            else
                label = label + 1;
                grid(i,j) = label;
            end
        end
            label = label + 1;
    end

    %Check if each square is connected to the cluster below it
    for i = 2:L
        for j =1:L
            x = rand;
            if x < p && grid(i-1,j) ~= grid(i,j) 
                %If the two sites are already in the same cluster, 
                % we do not have to change the labels
                % Otherwise, the cluster below is relabeled to match the cluster above,
                % becoming one cluster
                new_label = grid(i-1,j);
                old_label = grid(i,j);
                grid(grid == old_label) = new_label;
            end
        end
    end
    %Relabel every cluster so it is 1,2,...,n
    cluster_labels = unique(grid);
    n = length(cluster_labels);
    %Shuffling the order of the new labels will make distinguishing the
    %clusters easier on a color map
    cluster_labels = cluster_labels(randperm(n));
    for i = 1:n
        grid(grid == cluster_labels(i)) = i + 0.5;
    end
    grid = grid - 0.5;
    % The 0.5 is used to prevent the new labels overlapping with the old
    % labels and connecting two clusters which should not be joined





end


