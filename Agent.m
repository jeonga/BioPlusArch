classdef Agent < handle  
    % an agent is equivalent to an individual which belongs to
    % S(susceptible),E(latently infected),I(active disease),Em(latently
    % infected with MDR-TB strains) or Im(active disease with MDR-TB
    % strains)
    
    properties
        alive=0; % 0:dead, 1:alive
        x;y;w;h; % coordinates
        HIVstatus=0; % 0:HIV-negative, 1:HIV-positive
        TBstatus=0; % 0:susceptible, 1:latently infected, 2:active disease
        MDRstatus=0; % 0:drug-susceptible TB, 1:MDR-TB
        speed=2.0;
        angle=0.0;
        maxD=5; % distance up to which contagion may occur
    end
    
    methods
        function newcase=endoReact(agent,probRct,probRctHIV)
            % determine whether the latently infected individual will
            % progress into the active TB
            % probability is dependent on the individual's HIV status
            newcase=0;
            if (agent.TBstatus==1)&&(agent.HIVstatus==0)
                if rand<probRct
                    agent.TBstatus=2;newcase=newcase+1;
                end
            end
            if (agent.TBstatus==1)&&(agent.HIVstatus==1)
                if rand<probRctHIV
                    agent.TBstatus=2;newcase=newcase+1;
                end
            end
        end

        function agent=natCure(agent,rate)
            % determine whether the active TB will be cured naturally
            if (agent.TBstatus==2)&&(rand<rate)
                agent.TBstatus=0;agent.MDRstatus=0;
            end
        end
           
        function newcase=infection(agent,agents,probInf,probInfHIV,probPrm,probPrmHIV,probPrmMDR)
            % determine whether the susceptible individual will be infected
            % by contact with the neighbors who have TB disease
            % newly infected individuals could develop primary TB disease,
            % instead of entering latency
            % the probabilities depend on the HIV status and drug
            % susceptibility of the TB strain infected
            newcase=0;
            if agent.TBstatus==0
            for i=1:length(agents)
                dx=agent.x-agents(i).x;
                dy=agent.y-agents(i).y;
                d=sqrt(dx*dx+dy*dy);
                if d<agent.maxD
                   % patch([agent.x agents(i).x],[agent.y agents(i).y],'k','EdgeColor','b')
                    if agent.HIVstatus==0
                        if (agents(i).TBstatus==2)&&(rand<probInf)
                            agent.TBstatus=1;
                            agent.MDRstatus=agents(i).MDRstatus;
                            if (agent.MDRstatus==0)&&(rand<probPrm)
                                agent.TBstatus=2;newcase=newcase+1;
                            elseif (agent.MDRstatus==1)&&(rand<probPrmMDR)
                                agent.TBstatus=2;newcase=newcase+1;
                            end
                        end
                    elseif agent.HIVstatus==1
                        if (agents(i).TBstatus==2)&&(rand<probInfHIV)
                            agent.TBstatus=1;
                            agent.MDRstatus=agents(i).MDRstatus;
                            if (agent.MDRstatus==0)&&(rand<probPrmHIV)
                                agent.TBstatus=2;newcase=newcase+1;
                            elseif (agent.MDRstatus==1)&&(rand<probPrmMDR)
                                agent.TBstatus=2;newcase=newcase+1;
                            end
                        end
                    end
                end
            end
            end
        end
        
        function agent=stdTherapy(agent,rateDet,rateDetMDR,rateSuc,rateSucMDR)
            % determine whether the individual with active TB will be cured
            % by standard drug therapy
            % TB can be cured only when the disease is correctly diagnosed
            % and the drug regimen succeeds
            % if the drug regimen fails, the originally drug-susceptible TB
            % strains become resistant
            if (agent.TBstatus==2)&&(agent.MDRstatus==0)
                if (rand<rateDet)
                    if (rand<rateSuc)
                        agent.TBstatus=0;agent.MDRstatus=0;
                    else
                        agent.MDRstatus=1;
                    end
                end
            elseif (agent.TBstatus==2)&&(agent.MDRstatus==1)
                if (rand<rateDetMDR)&&(rand<rateSucMDR)
                    agent.TBstatus=0;agent.MDRstatus=0;
                end
            end
            
        end
        
        function agent=chemoProphylaxis(agent,rate,rateDet)
            % determine whether the TB in latency will be eliminated from 
            % the individual by chemoprophylaxis
            % if the regimen fails, the originally drug-susceptible TB
            % strains become resistant
            % if the indivual is infected with MDR-TB strains, it won't be
            % eliminated
            if (agent.TBstatus==1)&&(agent.MDRstatus==0)
                if rand<rate
                    agent.TBstatus=0;
                else
                    agent.MDRstatus=1;
                end
            elseif (agent.TBstatus==2)&&(agent.MDRstatus==0)&&(rand>rateDet)
                agent.MDRstatus=1;
            end
        end
        
        function agent=move(agent)
            % agents move once a year in a continuous space
            agent.angle=agent.angle+(rand-0.5)*pi;
           
            agent.x=agent.x+agent.speed*cos(agent.angle);
            agent.y=agent.y+agent.speed*sin(agent.angle);
            
            if agent.x>agent.w
                agent.x=agent.x-agent.w;
            end
            if agent.y>agent.h
                agent.y=agent.y-agent.h;
            end
            if agent.x<0
                agent.x=agent.w+agent.x;
            end
            if agent.y<0
                agent.y=agent.h+agent.y;
            end
            
        end
        
        function agent=mortality(agent,death,deathTB,deathHIV)
            % determine whether the individual will die in this year
            % mortality depends on TB and HIV status of the individual
            rate=death;
            if agent.TBstatus==2
                rate=rate+deathTB;
            end
            if agent.HIVstatus==1
                rate=rate+deathHIV;
            end
            if rand<rate
                agent.alive=0;
            end
        end
                
    end
    
end

