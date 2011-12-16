clear
% set the parameters varying dependent on countries
countrySetup
country=Country.empty(size(countries,2),0);
for i=1:size(countries,2)
    country(i).prevHIV=countries(2,i);
    country(i).prevTB=0.33;
    country(i).prevTBact=countries(3,i);
    country(i).incTB=countries(4,i);
    country(i).growth=countries(5,i);
    country(i).death=countries(6,i);
    country(i).deathTB=countries(7,i);
    country(i).deathHIV=countries(8,i);
    country(i).rateDet=countries(9,i);
    country(i).rateDetMDR=0.06;
    country(i).rateSuc=countries(10,i);
    country(i).rateSucMDR=0.6;
    country(i).ratioMDR=countries(11,i);
end

% set the pamameters about the TB itself
parameterSetup 

% set the simulation conditions
N=675; % number of agents
M=100; % size of map
time=100; % time span in years
run=3; % number of simulations

countryID=2; % select a country to be simulated
chemo=1; % 1 if chemoprophylaxis is chosen as a strategy to control TB, 0 if not
rateChemSuc=0.5; % estimated success rate of chemoprophylaxis

% preallocate variables for epidemiological data concerned
rHIV=zeros(run,time+1);
rTBtot=zeros(run,time+1);rTBlat=zeros(run,time+1);rTBact=zeros(run,time+1);
rMDRtot=zeros(run,time+1);rMDRlat=zeros(run,time+1);rMDRact=zeros(run,time+1);
ratioMDR=zeros(run,time+1);
inc=zeros(run,time);

% initialize movie
mov = avifile('TB_movie.avi');

for j=1:run

% initialization of agents
agents=Agent.empty(N,0);

for i=1:N;
    agents(i).alive=1;
    agents(i).w=M;
    agents(i).h=M;
    agents(i).x=rand*M;
    agents(i).y=rand*M;
    % HIV and TB status of new born agents are determined according to the
    % prevalences in the country chosen to be simulated
    if rand<country(countryID).prevHIV
        agents(i).HIVstatus=1;
    end
    if rand<country(countryID).prevTB
        agents(i).TBstatus=1;
        if rand<country(countryID).ratioMDR 
            agents(i).MDRstatus=1;
        end
    end
    if rand<country(countryID).prevTBact
        agents(i).TBstatus=2;
        if rand<country(countryID).ratioMDR
            agents(i).MDRstatus=1;
        end
    end

end

% calculate the realized prevalence and incidence after initialization
[rHIV(j,1) rTBtot(j,1) rTBlat(j,1) rTBact(j,1) rMDRtot(j,1) rMDRlat(j,1) rMDRact(j,1)]=realPrevalence(agents);
ratioMDR(j,1)=rMDRact(j,1)/rTBact(j,1);

figure()
for t=1:time  
    % draw agents in the space
    drawAgentsInSpace

    % agent update
    agents2=agents;order=randperm(length(agents));
    for i=1:length(agents)
        % agents update in regard to the endogenous reactivation
        inc(j,t)=inc(j,t)+agents2(order(i)).endoReact(probRct,probRctHIV);
        % agents update in regard to the natural cure
        agents2(order(i)).natCure(naturalCure);
        % agents update in regard to new infection by contact
        inc(j,t)=inc(j,t)+agents2(order(i)).infection(agents,probInf,probInfHIV,probPrm,probPrmHIV,probPrmMDR);
        % agents update in regard to standard therapies
        agents2(order(i)).stdTherapy(country(countryID).rateDet,country(countryID).rateDetMDR,country(countryID).rateSuc,country(countryID).rateSucMDR);
        % agents update in regard to chemoprophylaxis only if the strategy
        % is chosen
        if chemo==1
            agents2(order(i)).chemoProphylaxis(rateChemSuc,country(countryID).rateDet);
        end
    end
    agents=agents2;

    % birth and death of agents
    for i=1:length(agents)
        agents(i).mortality(country(countryID).death,country(countryID).deathTB,country(countryID).deathHIV);
    end
    N2=round(country(countryID).growth*length(agents)+0.1*(rand-0.5));
    if N2>0
        for i=N+1:N+N2
            agents(i)=Agent;
        end
        N=N+N2;
    end
    % initialization of new born agents
    for i=1:length(agents)
        if agents(i).alive==0
            agents(i).alive=1;
            agents(i).w=M;
            agents(i).h=M;
            agents(i).x=rand*M;
            agents(i).y=rand*M;
            agents(i).HIVstatus=0;
            agents(i).TBstatus=0;
            agents(i).MDRstatus=0;
            if rand<country(countryID).prevHIV
                agents(i).HIVstatus=1;
            end
            if rand<country(countryID).prevTB
                agents(i).TBstatus=1;
                if rand<country(countryID).ratioMDR
                    agents(i).MDRstatus=1;
                end
            end
            if rand<country(countryID).prevTBact
                agents(i).TBstatus=2;
                if rand<country(countryID).ratioMDR
                    agents(i).MDRstatus=1;
                end
            end
        end
    end
    
    % move agents
    for i=1:length(agents) 
        agents(i)=agents(i).move();
    end

    % calculate the realized prevalence of HIV, TB and MDR-TB every year
    [rHIV(j,t+1) rTBtot(j,t+1) rTBlat(j,t+1) rTBact(j,t+1) rMDRtot(j,t+1) rMDRlat(j,t+1) rMDRact(j,t+1)]=realPrevalence(agents);
    pause(0.01);
    ratioMDR(j,1)=rMDRact(j,1)/rTBact(j,1);
    inc(j,t)=inc(j,t)/length(agents);

    % create movie
    F = getframe(gca);
    mov=addframe(mov,F);
end

end
% close video file
mov=close(mov);
% save the result
save('China_with_Chemo18_20','rHIV','rTBtot','rTBlat','rTBact','rMDRtot','rMDRlat','rMDRact','ratioMDR','inc')
plotResult