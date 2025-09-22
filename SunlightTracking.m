% MATLAB Script to Simulate a Sunlight Tracking System over a Whole Day
% and Visualize Results Using Enhanced Plots

% Parameters for PID Controller
Kp = 1.0; % Proportional gain
Ki = 0.1; % Integral gain
Kd = 0.05; % Derivative gain
setpoint = 0; % Desired sensor value

% Simulation Time for a Whole Day
minutes_per_day = 24 * 60; % Total minutes in a day
t = 0:1:minutes_per_day - 1; % Time vector from 0 to 1439 minutes
dt = 1; % Time step in minutes

% Simulate Sunlight Intensity (Typical Daily Pattern with Noise)
% Sunlight intensity follows a Gaussian pattern peaking around noon
sunlight_intensity = 100 * exp(-((t - 720).^2) / (2 * (200)^2)) + randn(size(t)) * 5;

% Initialize Variables for PID Control
controller_output = zeros(size(t));
panel_position = zeros(size(t));
integral = 0;
previous_error = 0;

% PID Control Loop
for i = 2:length(t)
% Compute Error
error = sunlight_intensity(i) - setpoint;
% Compute Integral
integral = integral + error * dt;
% Compute Derivative
derivative = (error - previous_error) / dt;
% Compute Control Signal
controller_output(i) = Kp * error + Ki * integral + Kd * derivative;
% Update Panel Position
panel_position(i) = panel_position(i-1) + controller_output(i) * dt;
% Update Previous Error
previous_error = error;
end

% Convert Time for Plotting (Hours and Minutes)
hours = floor(t / 60);
minutes = mod(t, 60);
time_str = arrayfun(@(h, m) sprintf('%02d:%02d', h, m), hours, minutes, 'UniformOutput', false);

% Create a new figure
figure;

% Subplot 1: Sunlight Intensity vs. Time
subplot(3, 1, 1);
plot(t, sunlight_intensity, 'b-', 'LineWidth', 1.5);
xlabel('Time (minutes)');
ylabel('Sunlight Intensity');
title('Sunlight Intensity Throughout the Day');
grid on;
xlim([0 minutes_per_day-1]);

% Subplot 2: PID Controller Output vs. Time
subplot(3, 1, 2);
plot(t, controller_output, 'r-', 'LineWidth', 1.5);
xlabel('Time (minutes)');
ylabel('Control Signal');
title('PID Controller Output Throughout the Day');
grid on;
xlim([0 minutes_per_day-1]);

% Subplot 3: Panel Position vs. Time
subplot(3, 1, 3);
plot(t, panel_position, 'g-', 'LineWidth', 1.5);
xlabel('Time (minutes)');
ylabel('Panel Position');
title('Panel Position Throughout the Day');
grid on;
xlim([0 minutes_per_day-1]);

% Improve x-axis ticks to show hours and minutes
for i = 1:3
subplot(3, 1, i);
ax = gca;
ax.XTick = linspace(0, minutes_per_day-1, 5); % 5 ticks for a full day
ax.XTickLabel = time_str(round(linspace(1, length(time_str), 5)));
ax.XTickLabelRotation = 45; % Rotate labels for better readability
end

% Overall Title
sgtitle('Sunlight Tracking System: Daily Simulation');
