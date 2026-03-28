clc;
clear;

// ========= NETWORK SIZES =========
Nlist = [100 200 300 400 500];

// ========= Topology Methods =========
methods = ["Tree","Random","Ring","Grid","Star"];
M = length(length(methods));

TimeTable = zeros(5,5) + 0;
// ================= MAIN LOOP =================
for m = 1:M

    for k = 1:length(Nlist)

        N = Nlist(k);
        tic();

        // ========= Generate Coordinates =========
        nodx = grand(1,N,'unf',0,5000);
        nody = grand(1,N,'unf',0,5000);

        // ========= Build Topology =========
        A = zeros(N,N);

        select methods(m)

        case "Tree"
            // Binary tree structure
            for i=2:N
                p = floor(i/2);
                A(p,i)=1;
                A(i,p)=1;
            end

        case "Random"
            // Random graph
            p = 0.05;
            for i=1:N
                for j=i+1:N
                    if rand() < p then
                        A(i,j)=1;
                        A(j,i)=1;
                    end
                end
            end

        case "Ring"
            for i=1:N
                j = modulo(i,N)+1;
                A(i,j)=1;
                A(j,i)=1;
            end

        case "Grid"
            // approximate sqrt grid
            g = floor(sqrt(N));
            for i=1:N
                if i+1<=N & modulo(i,g)<>0 then
                    A(i,i+1)=1;
                    A(i+1,i)=1;
                end
                if i+g<=N then
                    A(i,i+g)=1;
                    A(i+g,i)=1;
                end
            end

        case "Star"
            for i=2:N
                A(1,i)=1;
                A(i,1)=1;
            end

        end

        // ========= ARC Propagation =========
        source = 1;
        flow = zeros(N,1);
        visited = zeros(N,1);

        queue = [];
        queue($+1) = source;
        visited(source) = 1;
        flow(source) = 1;

        while queue <> []

            node = queue(1);
            queue(1) = [];

            neigh = find(A(node,:)==1);

            for nb = neigh
                if visited(nb)==0 then
                    visited(nb)=1;
                    flow(nb) = flow(node)/max(length(neigh),1);
                    queue($+1) = nb;
                end
            end

        end

        TimeTable(m,k) = toc();

        // ========= Plot Topology =========
        scf(m*10 + k);
        plot(nodx,nody,'o');

        for i=1:N
            neigh = find(A(i,:)==1);
            for nb = neigh
                xpoly([nodx(i) nodx(nb)],...
                      [nody(i) nody(nb)]);
            end
        end

        xtitle("Topology="+methods(m)+" N="+string(N));

        // Console output        mprintf("Method: %s | Nodes: %d | Time: %f sec\n",...
                methods(m),N,TimeTable(m,k));

    end

end

// ================= TIME PLOT =================
scf();

colors = [5 2 3 6 1];   // Scilab color indexes

for m=1:M
    plot(Nlist, TimeTable(m,:), '-o');
    h = gce();                 // get current entity
    h.children.foreground = colors(m);
end
legend(methods);
xlabel("Number of Nodes");
ylabel("ARC Propagation Time (seconds)");
title("ARC Timing Across Topologies");
xgrid();
