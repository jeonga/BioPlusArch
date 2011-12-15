function [ rHIV,rTBtot,rTBlat,rTBact,rMDRtot,rMDRlat,rMDRact ] = realPrevalence( agents )
% calculate the realized prevalence of HIV, TB and MDR-TB
HIV=zeros(length(agents),1);
TBtot=zeros(length(agents),1);
TBlat=zeros(length(agents),1);
TBact=zeros(length(agents),1);
MDRtot=zeros(length(agents),1);
MDRlat=zeros(length(agents),1);
MDRact=zeros(length(agents),1);
for i=1:length(agents)
    HIV(i)=agents(i).HIVstatus==1;
    TBtot(i)=(agents(i).TBstatus==1)||(agents(i).TBstatus==2);
    TBlat(i)=agents(i).TBstatus==1;
    TBact(i)=agents(i).TBstatus==2;
    MDRtot(i)=agents(i).MDRstatus==1;
    MDRlat(i)=(agents(i).TBstatus==1)&&(agents(i).MDRstatus==1);
    MDRact(i)=(agents(i).TBstatus==2)&&(agents(i).MDRstatus==1);
end
rHIV=sum(HIV)/length(agents);
rTBtot=sum(TBtot)/length(agents);
rTBlat=sum(TBlat)/length(agents);
rTBact=sum(TBact)/length(agents);
rMDRtot=sum(MDRtot)/length(agents);
rMDRlat=sum(MDRlat)/length(agents);
rMDRact=sum(MDRact)/length(agents);

end

