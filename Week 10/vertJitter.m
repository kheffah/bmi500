function vertJitter(handle,jitteramount)

for h = handle(:)'
	% jitter vertical axis
	switch h.Type
		case 'line'
			h.YData = h.YData + jitteramount*(rand(1)-0.5);
		case 'text'
			h.Position(2) = h.Position(2) + jitteramount*(rand(1)-0.5);
	end
end

end