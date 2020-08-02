clear; clf;
dayVec = [];
%################
%%% Variables %%%
%################
rPop = 30000; % rabbit starting/current population
fPop = 4000; % fox starting/current population  
totalPop = (fPop + rPop);

%%% RABBITS %%%
a = 0.0069 / 4; % growth rate
b = 0.011 / 4 / totalPop; % death rate due to foxes
rVec = []; % for plotting

%%% FOXES %%%
g = 0.008 / 4; % starve rate 
d = 0.01 / 4 / totalPop; % growth rate
h = 0.013; % hunted rate (only nov->feb) [with margin it is 1%]
fVec = []; % for plotting

%%% WORLD %%%
endingTime = 365*20; % how many years
dayN = 1;
dayV = [];

%################
%%% Simulation %%
%################

for day = 1:endingTime
    % updating vectors
    rVec = [rVec, rPop];
    fVec = [fVec, fPop];
    
    % goes through equations
    rChange = round((a * rPop) - (b * fPop * rPop));
    
    %%% Accounts for fox hunting when necessary
    if (dayN >= 305) || (dayN <= 59)
        fChange = round((-g * fPop) + (d * fPop * rPop) - (h * fPop));
    else
        fChange = round(((-g * fPop) + (d * fPop * rPop)));
    endif
    
    %%% resets days if needed 
    if (dayN >= 365)
        dayN = 1;
    elseif (dayN >= 1)
        dayN = dayN + 1;
    endif
    
    %%% adds population changes to final population
    rPop += rChange;
    fPop += fChange; 
    
    %%% checks for extinct
    if (rPop <= 50) 
        rPop = 0;
        error("rabbits went extinct");
    endif
    if (fPop <= 50)
        fPop = 0;
        error("foxes went extinct");
    endif
endfor

dayV = [1900:1920];
yearsv = [(1:endingTime)/365] + 1900;
%%% Plotting
plot(yearsv,rVec, "linewidth", 2, "color", "b");
hold on;
plot(yearsv,fVec, "linewidth", 2, "color", "r");

%%% normal data %%%
data = csvread("data_1900_1920.m", 1,0);

realrPop = data(:,2) * 1000;
realfPop = data(:,3) * 1000;

plot(dayV, realrPop, "linewidth", 1, "color", "b", "--"); 
plot(dayV, realfPop, "linewidth", 1, "color", "r", "--");

%%% Formatting
legend("Rabbit Population", "Fox Population", "R-rabbit", "R-fox");
xlabel("Year"); ylabel("Population");
title("Predator-Prey relationship with Foxes and Rabbits");

%###########################
%%% Displaying Variables %%%
%###########################

%%% Animal Rates %%%
disp("%%% Animal Rates %%%")
fprintf("Rabbit birth rate: %d\n", a);
fprintf("Rabbit death rate: %d\n", b);
fprintf("Fox birth rate: %d\n", g);
fprintf("Fox death rate: %d\n", d);
disp(" ");

%%% Initial Populations %%%
disp("%%% Initial Population %%%");
fprintf("Initial number of rabbits: %i \n", rVec(1));
fprintf("Initial number of foxes: %i \n", fVec(1));
disp(" ");

%%% Model Stats %%%
disp("%%% Model Statistics %%%");
fprintf("Days plotted: %i \n", endingTime);
fprintf("Average Rabbit Population: %i \n", round(mean(rVec)));
fprintf("Average Fox Population: %i \n", round(mean(fVec)));
disp(" ");
