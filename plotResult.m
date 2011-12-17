% plot the epidemiological results for each run
h=figure();
subplot(1,2,1)
plot(1:time+1,rHIV,'y',1:time+1,rTBtot,'b',1:time+1,rTBact,'r',1:time+1,rMDRtot,'k')
xlabel('time (years)','FontSize',16);ylabel('prevalence','FontSize',16);
xlim([0 100]);
legend('HIV','TB total','TB disease','MDR-TB total');
subplot(1,2,2)
plot(1:time,inc,'b',1:time+1,ratioMDR,'r')
xlabel('time (years)','FontSize',16);ylabel('incidence','FontSize',16);
xlim([0 100]);
legend('incidence','proportion of disease due to MDR-TB')
