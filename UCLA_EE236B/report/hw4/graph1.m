% use the following code to plot your trajectories
% plot the glide cone (don't modify)
% -------------------------------------------------------
p = x(4:6, :); f = x(7:9, 2:K+1);
x = linspace(-40,55,30); y = linspace(0,55,30);
[X,Y] = meshgrid(x,y);
Z = alpha*sqrt(X.^2+Y.^2);
figure; colormap autumn; surf(X,Y,Z);
axis([-40,55,0,55,0,105]);
grid on; hold on;

% INSERT YOUR VARIABLES HERE:
% -------------------------------------------------------
plot3(p(1,:),p(2,:),p(3,:),'b','linewidth',1.5);
quiver3(p(1,1:K),p(2,1:K),p(3,1:K),...
        f(1,:),f(2,:),f(3,:),0.3,'k','linewidth',1.5);