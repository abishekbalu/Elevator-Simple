function try_p3(method, varargin)

persistent flBtns fig floorHeight offStopColor onStopColor;
persistent offDoorColor onColor offColor axesH numFloor;
persistent model Stopbtn stop_val;
    switch method
        case 'init'
            
            %setting up the figure (canvas)
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
            % Customize and setup floor,buttons,signs,elevator
            model = 'Copy_of_a2_p3';
            numFloor = 4;
            flBtns = zeros(numFloor, 1);
            offColor = 'w';
            onColor = 'c';
            offDoorColor= 'k';
            onDoorColor= [1 0.3 0];
            onStopColor = [1 0.3 0];
            offStopColor = [0.6 0 0];
            stop_val = 0;
            floorHeight = 700/numFloor;
            btnSize = 8;
            signSize = 10;
            % Draw each floor level, the floor number sign, and the elevator request button
            for f = 1:numFloor
                floorBaseY = floorHeight*(f-1);
                btnPosX = 50/2-btnSize/2;
                btnPosY = floorBaseY + floorHeight/3;
                signPosX = btnPosX;
                signPosY = floorBaseY + 5*floorHeight/8;

                % Elevator request buttons
                flBtns(f) = rectangle('Parent',axesH, ...
                                        'Position',[btnPosX btnPosY btnSize btnSize], ...
                                        'FaceColor',onColor, ...
                                        'ButtonDownFcn',...
                                        ['try_p3(''on'',' num2str(f) ')']);
               % Floor number signs
                text('Parent',axesH, ...
                     'Position',[signPosX signPosY], ...
                     'String',num2str(f), ...
                     'BackgroundColor','k', ...
                     'Color','w', ...
                     'FontName','FixedWidth', ...
                     'FontSize',signSize, ...
                     'FontWeight','bold');

                % Floor levels
                line([1 200],[floorBaseY floorBaseY],'Parent',axesH);
            end
            boxWidth = 60;
            boxHeight = floorHeight*0.6;
            boxAxes = 400/4;
            boxX = boxAxes-boxWidth/2;
            boxY = 0;
            boxA = rectangle('Parent',axesH, ...
                             'Position',[boxX boxY boxWidth boxHeight], ...
                             'FaceColor','b', ...
                             'LineWidth',1, ...
                             'EdgeColor','k');

            boxAdoor = rectangle('parent',axesH, ...
                                 'Position',[boxAxes boxY 1 boxHeight], ...
                                 'FaceColor','y', ...
                                 'LineWidth',1, ...
                                 'EdgeColor','k'); 
            Stopbtn = text( 'Parent',axesH, ...
                            'Position',[190 30], ...
                            'String','STOP', ...
                            'BackgroundColor',offStopColor, ...
                            'Color','w', ...
                            'FontSize',8, ...
                            'VerticalAlignment','bottom', ...
                            'HorizontalAlignment','right', ...
                            'EdgeColor','k', ...
                            'ButtonDownFcn','try_p3 on stop');
            Openbtn = text('Parent',axesH, ...
                         'Position',[50 10], ...
                         'String','OPEN', ...
                         'BackgroundColor',offDoorColor, ...
                         'Color','w', ...
                         'FontSize',8, ...
                         'VerticalAlignment','bottom', ...
                         'HorizontalAlignment','right', ...
                         'EdgeColor','k');     
        case 'on'
                 if(varargin{1} <= numFloor)
                    actv = flBtns(varargin{1});
                    set(actv,'FaceColor',offColor);
                    set_param([model '/pressed'],'value',num2str(varargin{1}));
                 end
                 switch varargin{1}
                     case 'stop'
                         if (stop_val == 0)
                             actv = Stopbtn;
                             set(actv,'BackgroundColor',onStopColor);
                             set_param([model '/stop'],'value','1');
                             stop_val = 1;
                         else
                             try_p3('off','stop');
                         end
                 end
        case 'off'
            switch varargin{1}
                case 'stop'
                    actv = Stopbtn;
                    set(actv,'BackgroundColor',offStopColor);
                    set_param([model '/stop'],'value','0');
                    stop_val = 0;
            end
        end
    end
    
