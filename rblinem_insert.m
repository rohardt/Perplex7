function p=rblinem_insert(data,proj)
% See Perplex7.mlapp, Map tab, button [insert]; using mouse cursor to
% insert an waypoint in the map.
% data == data.pkt(1,:) starting lat/lon location
%         data.pkt(2,:) next lat/lon location

data.line=linem([data.LATLIM(1) data.LATLIM(1) data.LATLIM(1)],[data.LONLIM(1) data.LONLIM(1) data.LONLIM(1)],'k:');
ax = gca;
ax.ButtonDownFcn = [];

waitforbuttonpress;
set(gcf, 'Pointer', 'crosshair');
pause(1);
% Install call-back handler.
set (gcf, 'WindowButtonMotionFcn',  {@rubberband_move, data, proj});
waitforbuttonpress;
px=gcpmap;
p=[px(1,1) px(1,2)];
pause(1);
set (gcf, 'WindowButtonMotionFcn',  '');
set(gcf, 'Pointer', 'arrow');
delete(data.line);
%--------------------------------------------------------------------------
% Rubber-band call-back handler.
function data=rubberband_move(obj, event, data, proj)
px = gcpmap;
if ~isempty(data.pkt)
    % 
    % [X,Y] = mfwdtran([data.pkt(1,1) px(1,1) data.pkt(2,1)],...
    %     [data.pkt(1,2)  px(1,2) data.pkt(2,2)])

    % [X,Y] = projfwd(proj,[data.pkt(1,1) px(1,1) data.pkt(2,1)],...
    %     [data.pkt(1,2)  px(1,2) data.pkt(2,2)]);
    % set(data.line,'XData', X, 'YData', Y,...
    % 'ZData',zeros(1,3),'LineStyle','--',...
    %     'Visible','on');
    rbline = linem([data.pkt(1,1) px(1,1) data.pkt(2,1)],...
        [data.pkt(1,2)  px(1,2) data.pkt(2,2)], 'LineStyle','--', 'Visible','off');
    set(data.line,'XData', rbline.XData, 'YData', rbline.YData,...
     'ZData',zeros(1,3),'LineStyle','--',...
         'Visible','on');
    delete(rbline)    
end
