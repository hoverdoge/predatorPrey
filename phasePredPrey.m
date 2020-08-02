clear; clf; clc;

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
fVec = []; % for plotting

%%% WORLD %%%
endingTime = 365*20; % how many years

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
    fChange = round((-g * fPop) + (d * fPop * rPop));
    rPop += rChange;
    fPop += fChange; 
    % checks for lower than 0 to prevent impossible scenarios
    if (rPop <= 0) 
        rPop = 0;
    endif
    if (fPop <= 0)
        fPop = 0;
    endif
endfor

%%% normal data %%%
plot(rVec, fVec, "linewidth", 2, "color", "b");
hold on;

data = csvread("data_1900_1920.m", 1,0);
realrPop = data(:,2) * 1000;
realfPop = data(:,3) * 1000;

plot(realrPop, realfPop, "linewidth", 2, "color", "r", "--")

legend("Programmed data", "Real data");
xlabel("Rabbit population"); ylabel("Fox population");

