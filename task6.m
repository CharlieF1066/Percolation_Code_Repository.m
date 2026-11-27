%assign the dimension of the lattice
L = 100;
%generates 100 equally spaced values of p between 0 and 1
p_values = linspace(0,1,100);
%initialises a zero array to store the spanning cluster density for each
%value of p
P = zeros(size(p_values));

%loops through each value of p
for i = 1:length(p_values)
    p = p_values(i);
    %generates a matrix of size L x L with random numbers between 0 and 1 
    r = rand(L,L);
    %defines that site is occupied if the random number<p and it is empty if
    %random number>p
    z = r<p;
    %labels each connected cluster 
    lw = bwlabel(z,4);
    %extracts the properties of each labelled cluster
    props = regionprops(lw);
    %initialises area to 0
    area = 0;
    %creates assumption that no spanning cluster exists
    spanning = false;
    %loops through each connected cluster
    for j = 1:length(props)
        %extracts the bounding box of the current cluster(bounding box is
        %the smallest rectangle enclosing the sites in that cluster)
        bbox = props(j).BoundingBox;

        %checks if the cluster spans the lattice
        if or(bbox(3) == L, bbox(4) == L)
            %gives the number of occupied sites in the spanning cluster
            area = props(j).Area;
            %sets spanning to true
            spanning = true;
            break;
        end
    end
    %calculates density of the spanning cluster
    P(i) = area / L^2;
end
%plots the graph of spanning cluster density against occupation probability
%
plot(p_values,P);
xlabel('occupation probability p');
ylabel('spanning cluster density P(p,L)');
title("spanning cluster density against occupation probability for L=100");
grid on;

