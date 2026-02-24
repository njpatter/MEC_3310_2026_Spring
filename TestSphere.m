%--- Create your figure/axes (the "scene") ---
fig = figure;
ax  = axes(fig);
hold(ax,'on'); grid(ax,'on'); axis(ax,'equal'); view(ax,3);

%--- Make a quiver3 plot (example vectors) ---
o  = [0 0 0];          % origin
d  = [1 1 0.2];        % direction (will normalize for display)
u  = d / norm(d);
L  = 3;                % arrow length

q = quiver3(ax, o(1),o(2),o(3), L*u(1),L*u(2),L*u(3), ...
    'LineWidth', 2, 'MaxHeadSize', 0.5);

% optional: fix axis limits so autoscale doesn't jump around
xlim(ax, [-1 5]); ylim(ax, [-2 4]); zlim(ax, [-2 4]);

%--- Create spheres in the SAME axes ---
s1 = MovingSphere([0 0 0],  [1 1 0.2], 1.0, 0, 0.25, 30, ax);
s2 = MovingSphere([0 0 0],  [1 0 0],   0.6, 0, 0.18, 25, ax);

s1.setAppearance('FaceColor',[0.2 0.6 1], 'FaceAlpha',0.7);
s2.setAppearance('FaceColor',[1.0 0.4 0.2], 'FaceAlpha',0.7);

objs = [s1 s2];

%--- Animate ---
for t = 0:0.05:5
    for k = 1:numel(objs)
        objs(k).update(t);
    end
    drawnow;
end