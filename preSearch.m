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
M=100; % size of map
time=30; % time span in years
run=10; % number of simulations

countryID=2; % select a country to be simulated
chemo=0; % 1 if chemoprophylaxis is chosen as a strategy to control TB, 0 if not
rateChemSuc=0.5; % estimated success rate of chemoprophylaxis

k=0;
for N=200:50:500
k=k+1;
inc=zeros(7,run,time);

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

for t=1:time  

    % agent update
    agents2=agents;order=randperm(length(agents));
    for i=1:length(agents)
        % agents update in regard to the endogenous reactivation
        inc(k,j,t)=inc(k,j,t)+agents2(order(i)).endoReact(probRct,probRctHIV);
        % agents update in regard to the natural cure
        agents2(order(i)).natCure(naturalCure);
        % agents update in regard to new infection by contact
        inc(k,j,t)=inc(k,j,t)+agents2(order(i)).infection(agents,probInf,probInfHIV,probPrm,probPrmHIV,probPrmMDR);
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

    % calculate the incidence
    inc(k,j,t)=inc(k,j,t)/length(agents);

end

end
end
save('China_preliminary','inc')
averInc=zeros(run,7);
for k=1:7
    for j=1:run
        for t=1:time
            averInc(j,k)=averInc(j,k)+inc(k,j,t);
        end
        averInc(j,k)=averInc(j,k)/time;
    end
end
subplot(1,2,1)
plot(200:50:500,averInc,'b')
set(gca,'FontSize',16)
xlabel('number of agents','FontSize',16)
ylabel('incidence','FontSize',16)
xlim([200 500])
subplot(1,2,2)
errorbar(200:50:500,mean(averInc),std(averInc),'k')
set(gca,'FontSize',16)
xlabel('number of agents','FontSize',16)
ylabel('incidence','FontSize',16)
