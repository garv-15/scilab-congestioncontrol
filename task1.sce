clc;
clear;

k = 1;
j = 1;

for n = 5:5:100

    b(k) = n;              // store node size
    L = 1000;              // network area
    dmax = 120;            // locality radius

    // Generate random connected topology
    [g] = NL_T_LocalityConnex(n,L,dmax);

    source = NL_F_RandInt1n(length(g.node_x));

    ind = 2;
    g.node_diam(source)=40;
    g.node_border(source)=10;
    g.node_color(source)=5;

    figure(2);
    NL_G_ShowGraphN(g,ind);

    for i = 1:5
        timer();
        [dist1,pred1] = NL_R_BellmanFord(g,source);
        A(i) = timer();
    end
    bf_time(j) = mean(A);

    // -------------------------
    // Dijkstra Timing
    // -------------------------
    for i = 1:5
        timer();
        [dist2,pred2] = NL_R_Dijkstra(g,source);
        B(i) = timer();
    end
    dj_time(j) = mean(B);

    disp(bf_time(j),n,"Bellman-Ford Time for nodes");
    disp(dj_time(j),n,"Dijkstra Time for nodes");

    j = j + 1;
    k = k + 1;

end
// Tabular Display
m = length(b);

disp(" Node Size | Bellman-Ford Time | Dijkstra Time ");
disp("------------------------------------------------");

for i = 1:m
    mprintf(" %10d | %17.6f | %13.6f \n", b(i), bf_time(i), dj_time(i));
end

figure(1);
clf();

plot(b, bf_time, 'r-o');
plot(b, dj_time, 'b-s');

xlabel("Number of Nodes");
ylabel("Average Execution Time");
legend(["Bellman-Ford","Dijkstra"]);
title("Performance Comparison");
xgrid();
