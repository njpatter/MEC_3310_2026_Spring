classdef MovingSphere < handle
    % MovingSphere
    % Creates a sphere (via sphere command) and moves it along a ray.
    %
    % Position model:
    %   center(t) = origin + unit(rayDirection) * velocity * t
    %
    % Usage:
    %   ms = MovingSphere([0 0 0], [1 2 0], 0.5, 0, 0.2);
    %   axis equal; grid on; view(3);
    %   ms.update(2.0);  % move to time = 2 seconds

    properties (SetAccess = private)
        Origin          (1,3) double
        RayDirection    (1,3) double
        Velocity        (1,1) double
        Time            (1,1) double
        Radius          (1,1) double
        Resolution      (1,1) double {mustBeInteger, mustBePositive} = 20

        % Current center
        Center          (1,3) double

        % Base sphere mesh (centered at origin, radius 1)
        X0 double
        Y0 double
        Z0 double

        % Graphics handle
        SurfHandle (1,1) matlab.graphics.Graphics = gobjects(1);
    end

    methods
        function obj = MovingSphere(origin, rayDirection, velocity, timeSeconds, radius, resolution, parentAxes)
            % origin:        1x3
            % rayDirection:  1x3 (does not need to be unit)
            % velocity:      scalar (units of distance/sec)
            % timeSeconds:   scalar
            % radius:        scalar
            % resolution:    optional (default 30)
            % parentAxes:    optional axes handle (default gca)

            if nargin < 6 || isempty(resolution)
                resolution = 30;
            end
            if nargin < 7 || isempty(parentAxes) || ~isgraphics(parentAxes, 'axes')
                error("MovingSphere:BadAxes", "Provide a valid axes handle as parentAxes.");
            end

            obj.Origin = obj.ensureRow3(origin, "origin");
            obj.RayDirection = obj.ensureRow3(rayDirection, "rayDirection");
            obj.Velocity = velocity;
            obj.Time = timeSeconds;
            obj.Radius = radius;
            obj.Resolution = resolution;

            % Build base unit sphere mesh
            [x, y, z] = sphere(obj.Resolution);
            obj.X0 = x;
            obj.Y0 = y;
            obj.Z0 = z;

            % Initial position
            obj.Center = obj.computeCenter(obj.Time);

            % Create plotted sphere at initial position
            X = obj.Radius * obj.X0 + obj.Center(1);
            Y = obj.Radius * obj.Y0 + obj.Center(2);
            Z = obj.Radius * obj.Z0 + obj.Center(3);

            obj.SurfHandle = surf(parentAxes, X, Y, Z, ...
                'EdgeColor', 'none', ...
                'FaceAlpha', 1.0);

            % Nice default lighting (optional; comment out if unwanted)
            try
                lighting(parentAxes, 'gouraud');
                camlight(parentAxes, 'headlight');
            catch
                % ignore if running in minimal graphics context
            end
        end

        function update(obj, timeSeconds)
            % Recompute sphere center and update mesh coordinates.
            obj.Time = timeSeconds;
            obj.Center = obj.computeCenter(obj.Time);

            obj.SurfHandle.XData = obj.Radius * obj.X0 + obj.Center(1);
            obj.SurfHandle.YData = obj.Radius * obj.Y0 + obj.Center(2);
            obj.SurfHandle.ZData = obj.Radius * obj.Z0 + obj.Center(3);
        end

        function setAppearance(obj, varargin)
            % Convenience to pass name/value pairs to the surface handle:
            % obj.setAppearance('FaceColor',[0.2 0.6 1], 'FaceAlpha',0.7)
            set(obj.SurfHandle, varargin{:});
        end

        function c = getCenter(obj)
            c = obj.Center;
        end
    end

    methods (Access = private)
        function center = computeCenter(obj, t)
            d = obj.RayDirection;
            n = norm(d);
            if n < eps
                error("MovingSphere:BadRayDirection", ...
                    "rayDirection must be non-zero.");
            end
            u = d / n; % unit direction
            center = obj.Origin + u * (obj.Velocity * t);
        end

        function v = ensureRow3(~, vIn, name)
            vIn = double(vIn);
            if numel(vIn) ~= 3
                error("MovingSphere:BadInput", "%s must have 3 elements.", name);
            end
            v = reshape(vIn, 1, 3);
        end
    end
end