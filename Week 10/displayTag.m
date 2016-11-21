function displayTag(src,~)

if src.UserData.DisplayTag
	return
else
	src.UserData.DisplayTag = true;
end

% identify the tag of the selected line
tag = src.UserData.Tag;

% identify the "parent" axis
ax = src.Parent;

% get dimensions of the parent axis
xl = ax.XLim;
yl = ax.YLim;

% get datapoints of the selected line
xdata = src.XData;
ydata = src.YData;

% create a label annotation
t = text(max(xl),nanmean(ydata),tag);
t.Color = src.Color;
t.FontSize = 6;
t.UserData.side = 'right';

% enable functionality to switch sides
t.ButtonDownFcn = @switchSides;

% change the linestyle of the figure
src.LineStyle = '--';


end

function switchSides(src,~)

% identify the "parent" axis
ax = src.Parent;

% get dimensions of the parent axis
xl = ax.XLim;
yl = ax.YLim;

% switch sides
switch src.UserData.side
	case 'left'
		src.Position(1) = xl(end);
		src.HorizontalAlignment = 'left';
		src.UserData.side = 'right';
	case 'right'
		src.Position(1) = xl(1);
		src.HorizontalAlignment = 'right';
		src.UserData.side = 'left';
end

end