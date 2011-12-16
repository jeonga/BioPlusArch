% plot the epidemiological results for each run
time=100;
h=figure();

subplot(2,2,1)
plot(1:time+1,rHIV,'y',1:time+1,rTBtot,'b',1:time+1,rTBact,'r',1:time+1,rMDRtot,'k')
set(gca,'FontSize',16)
xlabel('time (years)','FontSize',16);ylabel('prevalence','FontSize',16);
xlim([0 100]);ylim([0 1]);

subplot(2,2,2)
errorbar(1:time+1,mean(rHIV),std(rHIV),'y')
hold on
errorbar(1:time+1,mean(rTBtot),std(rTBtot),'b')
errorbar(1:time+1,mean(rTBact),std(rTBact),'r')
errorbar(1:time+1,mean(rMDRtot),std(rMDRtot),'k')
set(gca,'FontSize',16)
xlabel('time (years)','FontSize',16);ylabel('prevalence','FontSize',16);
xlim([0 100]);ylim([0 1]);

subplot(2,2,3)
plot(1:time,inc,'b',1:time+1,ratioMDR,'r')
set(gca,'FontSize',16)
xlabel('time (years)','FontSize',16);ylabel('incidence','FontSize',16);
xlim([0 100]);ylim([0 1]);

subplot(2,2,4)
errorbar(1:time,mean(inc),std(inc),'b')
hold on
errorbar(1:time+1,mean(ratioMDR),std(ratioMDR),'r')
set(gca,'FontSize',16)
xlabel('time (years)','FontSize',16);ylabel('prevalence','FontSize',16);
xlim([0 100]);ylim([0 1]);

