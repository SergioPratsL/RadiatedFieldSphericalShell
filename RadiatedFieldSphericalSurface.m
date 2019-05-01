% This script pretends to evaluate the field radiated by a spherical 
% surface under a constant acceleration considering the surface is at rest.

% The aim of this test was to compare the radiated field with the induce
% field and check how is it inside the sphere or outside of it in the
% proximity.

% The position where the field is evaluated should be always on the X axis
% the direction of the accelaration can be changed.

% Charge is considered to be unit.


Acceleration = [0, 1, 0];

Velocity = [0, 0, 0];   
SphereRadius = 1;         


X_Offset = 0.51;
EvaluatedPosition = [SphereRadius+X_Offset, 0, 0];

% When we are calculating points below this distance we will reduce
% resolution to enfatize the contributions from the nearest points.
NextReductionDistanceInitial = 0.25;
NextReductionDistance = NextReductionDistanceInitial;

% In fact Thetha is creating slices at constant X, not constant Y!!
NumberIterationsThethaInitial = 200;
NumberIterationsThetha = NumberIterationsThethaInitial;
% 
% Rho works on YZ planes.
NumberIterationsRhoInitial = 180;
NumberIterationsRho = NumberIterationsRhoInitial;

DistanceReductionCoeficient = 4;
ThethaIncrementationCoeficient = 2;
RhoIncrementatationCoeficient = 2;

RhoResolution = (2*pi) / NumberIterationsRho;
ThethaResolution = pi / NumberIterationsThetha;

NumberOfIterationsDone = 0;
AccumulatedSurface = 0;
E_rad_tot = [0,0,0];
B_rad_tot = [0,0,0];

% It starts with Thethe almost 180º
ThethaInicial = pi - ThethaResolution/2;

Thetha = ThethaInicial;
while Thetha > 0
    
    % Let's measure the distance to decide if resolutions needs to be
    % increased
    Distancia = sqrt((1 + X_Offset - cos(Thetha))^2 + sin(Thetha)^2);
    if (Distancia < NextReductionDistance)
        NextReductionDistance = NextReductionDistance / DistanceReductionCoeficient;
        NumberIterationsThetha = NumberIterationsThetha * ThethaIncrementatationCoeficient;
        NumberIterationsRho = NumberIterationsRho * RhoIncrementatationCoeficient;
        RhoResolution = (2*pi) / NumberIterationsRho;
        ThethaResolution = pi / NumberIterationsThetha;
    end
    
    % SurfaceUnit is used to control how much charge compute each itearion,
    % its sum should be 4*pi
    SurfaceUnit = abs(sin(Thetha)) * RhoResolution * ThethaResolution;
    
    Rho = RhoResolution/2;   
    while(Rho <= (2*pi))
    
        Pos = [cos(Thetha), abs(sin(Thetha))*sin(Rho), abs(sin(Thetha))*cos(Rho)];
        VectorOrigienDestino = EvaluatedPosition - Pos;
        
        [E, B] = CampoRadiadoCargaAcelerada2(VectorOrigienDestino, Velocity, Acceleration);
        E_rad_tot = E_rad_tot + E * SurfaceUnit;
        B_rad_tot = B_rad_tot + B * SurfaceUnit;
        
        Rho = Rho + RhoResolution; 
        NumberOfIterationsDone = NumberOfIterationsDone + 1;
        AccumulatedSurface = AccumulatedSurface + SurfaceUnit;
    end
    
   Thetha = Thetha - ThethaResolution;
end

% Show results
NumberOfIterationsDone = NumberOfIterationsDone
AccumulatedSurface = AccumulatedSurface

% Can be used to compare with the field that the charge would do if it were
% at the center
% [E_rad_centro, B_rad_centro] = CampoRadiadoCargaAcelerada2(EvaluatedPosition, Velocity, Acceleration);
% 
% E_rad_centro = E_rad_centro * AccumulatedSurface
% B_rad_centro = B_rad_centro * AccumulatedSurface

E_rad_tot = E_rad_tot
B_rad_tot = B_rad_tot 

%S = cross(E_rad_tot, B_rad_tot)

