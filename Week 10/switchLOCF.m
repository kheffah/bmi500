function switchLOCF(src,~)


% isolate original data
LOCF = src.UserData.LOCF;
SrcData = src.UserData.SrcData;
LOCFData = src.UserData.LOCFData;

% isolate plotted data (in case of jitter)
YData = src.YData;

switch LOCF
	case true
		jitteramount = nanmean(YData(:) - LOCFData(:));
		src.YData = SrcData + jitteramount;
	case false
		jitteramount = nanmean(YData(:) - SrcData(:));
		src.YData = LOCFData + jitteramount;
end

src.UserData.LOCF = ~LOCF;

end