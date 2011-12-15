classdef Country
    % a country is defined by several parameters that are taken into
    % account in evaluation of TB epidemiology
    
    properties
        prevHIV; % prevalence of HIV
        prevTB; % prevalence of all forms TB
        prevTBact; % prevalence of TB disease
        incTB; % incidnece of TB disease
        growth; % annual population growth rate
        death; % death rate per yr, estimated from adult mortality rate
        deathTB; % additional death rate due to TB per yr
        deathHIV; % additional death rate due to HIV
        rateDet; % case detection rate for all forms of TB
        rateDetMDR; % case detection rate in case of MDR-TB strains
        rateSuc; % TB treatment success rate
        rateSucMDR; % TB treatment success rate in case of MDR-TB strains
        ratioMDR; % ratio of the MDR-TB cases among new TB cases
    end
    
    methods
    end
    
end

