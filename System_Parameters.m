% Tape Drive System Parameters

% --- Motor & Capstan ---
J1 = 5e-5;    % motor and capstan inertia [kg*m^2] 
B1 = 1e-2;
r1 = 2e-2;    % capstan radius [m] 
Kt = 3e-2;    % motor torque constant [N*m/A] 

% --- Idler Wheel ---
J2 = 2e-5;    % idler inertia [kg*m^2] 
B2 = 2e-2;    % viscous damping, idler [N*m*sec] 
r2 = 2e-2;    % idler radius [m]

% --- Tape (Spring-Damper Model) ---
K = 2e4;      % stiffness [N/m] 
B = 20;       % damping [N/m*sec] 

% --- Tape (PID Model) ---
Kp = 50;
Ki = 6250;
Kd = 0.025;