
% set the simulation conditions
time=30; % time span in years
run=10; % number of simulations

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
xlim([200 500])
ylim([0 0.05])
