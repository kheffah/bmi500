function circle(centers,radii,numpts)
% circle(centers,radii,numpts)
%   circle([1 2],0.5,50);  numpts is optional
%   circle([1 2;1 4],0.1);
%   circle([1 2;1 4],[0.1;0.3]);

holdwason = ishold;

hold on

if(nargin < 3)
  numpts = 50;
end
if sum(size(radii))==2, %just one radii given. Convert to column vector
  radii = ones(size(centers,1),1)*radii;
end

theta = 0:2*pi/(numpts-1):2*pi;
for i = 1:size(centers,1)
  XData = centers(i,1)+radii(i).*cos(theta);
  YData = centers(i,2)+radii(i).*sin(theta);
  plot(XData,YData); 
end;

if ~holdwason
  hold off
end

