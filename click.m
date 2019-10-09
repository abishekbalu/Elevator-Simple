function click(method, varargin)
persistent b;
switch method
    case 'init'
    fig = figure('Name','Stateflow Elevators', 'DoubleBuffer', 'on'); 
    oldUnits = get(fig,'Units');
    set(fig,'Units','normalized');
    ratioXY = 200/700;
    height = 0.80;
    width = ratioXY * height;
    left = (1 - width) / 2;
    top = (1 - height)/ 2;
    set(fig,'Position',[left top width height]);
    set(fig,'Units',oldUnits);
    
                axesH = axes('Color','w', ...
                            'XLim',[1 200], ...
                            'YLim',[1 700], ...
                            'DataAspectRatio',[1 1 1], ...
                            'XTick',[], ...
                            'YTick',[], ...
                            'Position',[0 1/8 1 7/8]);
    f = 1;                    
    b(f) = rectangle('Parent',axesH, ...
                                'Position',[50 50 55 100], ...
                                'FaceColor','w','ButtonDownFcn',...
                                ['click(''on'',' num2str(f) ')']);
          %basically you want to write 'click on f' but with parameters
                             
    case 'on'
        %fprintf(" %d", str2num(varargin{1}));
        actv = b((varargin{1}));
        set(actv,'FaceColor','g');
end