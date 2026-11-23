%setting no. simulations to perform, the length of the lattice and
%probability of each site being occupied
nsamp = 1000;
L = 1000;
p = 0.90;

%create an empty array to store the sizes of all the clusters
allarea = [];

%perform simulation nsamp times 
for i= 1:nsamp
    %generate L random numbers between 0 and 1 and  a site is occupied if
    %its random number is less than p (otherwise it is unoccupied)
    z = rand(1,L);
    m = z<p;

    %start counting consecutive occupied sites
    size = 0;
    %loop through every site in the lattice and if the current site is
    %occupied then increase cluster size by 1
    for j = 1:L
        if m(j) == 1
            size = size+1;
        else 
            %if current site is unoccupied then it is the end of a cluster
            %and clusters are only recorded if size>0
            if size>0
               allarea = [allarea,size];
               %reset size for next cluster
               size = 0;
            end
        end
    end
    %record the cluster if it ends on the last site in the lattice
    if size >0
        allarea = [allarea, size];
    end 
end 
%an array is created containing all possible cluster sizes in ascending
%order
s = 1:max(allarea);
%another array is created to store the number of clusters that are that
%size
n = zeros(1,length(s));
%counts how many clusters are each size
for i=1:length(s)
    n(i) = sum(allarea == s(i));
end 

%calculates cluster number density 
nsp = n / (L*nsamp);
%calculates theoretical characteristic cluster size 
sxi = -1/log(p);
%calculates theoretical cluster number density 
nsptheory = (1-p)^2 * exp(-s/sxi);

%plots the simulated and theoretical distributions of cluster number density
figure;
plot(s,nsp,'r');
hold on;
plot(s, nsptheory,'go');
xlabel("s");
ylabel("n(s,p)");
title('Cluster Number Density at p =0.90')
legend("Simulation", "Theory");

%sets number of simulations, number of sites in the lattice and the
%different occupation probabilities used
nsamp = 1000;
L = 1000;
pv = [0.5 0.7 0.8 0.9 0.95 0.98];
%S stores the average cluster size for each probability
S = zeros(1,length(pv));
%sxi stores the characteristic cluster size for each probability
sxi = zeros(1,length(pv));
%creates a plot to compare cluster number densities
figure;
hold on;
%repeats for each occupation probability
for k =1:length(pv)
    p = pv(k);
    allarea = [];

    for i=1:nsamp
        z = rand(1,L);
        m =z<p;

        cluster = 0;

        for j = 1:L
            if m(j) ==1
                cluster = cluster+1;
            else
                if cluster >0
                    allarea = [allarea, cluster];
                    
                end 
                cluster = 0;
            end 
        end 
        if cluster>0
            allarea = [allarea, cluster];
        end 
    end 
    s = 1:max(allarea);
    n = zeros(1,length(s));

    for j = 1:length(s)
        n(j) = sum(allarea == s(j));
    end 
    %calculates cluster number density for the current occupied probability
    nsp = n/(L*nsamp);
    %calculates average cluster size
    S(k) = sum(s.^2 .* nsp) / sum(s.*nsp);
    %calculates theoretical characteristic cluster size
    sxi(k) = -1/log(p);

    semilogy(s,nsp, 'DisplayName',['p = ', num2str(p)]);

end 
xlim([1 150]);
yscale('log')
title("Cluster Number Density for Different Occupation Probabilites");
xlabel("Cluster Size s")
ylabel("Cluster Number Density n(s,p)")
legend;
hold off;
%plots the average and characteristic cluster sizes against occupation
%probability
figure;
plot(pv, S, 'bo-', pv, sxi, 'r*-');
title("Average and Characteristic Cluster Sizes");
xlabel('p');
ylabel(' Cluster Size');
legend('Average Cluster Size', 'Characteristic Cluster Size', 'Location', 'Best');
grid on;
%estimates gamma       
a = polyfit(log(1-pv), log(S), 1);
gamma = -a(1);
%estimates sigma 
b = polyfit(log(1-pv), log(sxi), 1);
sigma = -1/b(1);
%prints the critical exponents
disp(["gamma = ", num2str(gamma)])
disp(["sigma = ", num2str(sigma)])

  
