function try_p3(method, varargin)
persistent flBtns fig distance offStopColor onStopColor;
persistent offDoorColor onDoorColor onColor offColor axesH numFloor;
persistent model stop_val;
persistent StopLight OpenLight;
    switch method
        case 'init'
            
            %MODEL_NAME
            model = 'a2_p3';
            
            
            %setting up the figure (UI)
            fig = figure('Name','A2-P3 Elevator Controller', 'DoubleBuffer', 'on'); 
            set(fig,'Position',[1000 150 500 500]);   
            axesH = axes('Color','w', ...
                            'XLim',[1 400], ...
                            'YLim',[1 200], ...
                            'DataAspectRatio',[1 1 1], ...
                            'XTick',[], ...
                            'YTick',[], ...
                            'Position',[0 1/8 1 0.8]);
            % Customize and setup buttons and lights
            
            numFloor = 4;
            flBtns = zeros(numFloor, 1);
            offColor = 'w';
            onColor = 'c';
            offDoorColor= 'k';
            onDoorColor= 'r'; %[1 0.3 0];
            onStopColor = [1 0.3 0];
            offStopColor = [0.6 0 0];
            stop_val = 0;
            distance = 100;
            btnSize = 20;
            signSize = 20;
            
            
            % Draw floor number sign, and the corresponding light
            for f = 1:numFloor
                floorBaseY = distance*(f-1);
                btnPosX = 50/2-btnSize/2;
                btnPosY = floorBaseY + distance/3;
                signPosX = btnPosX + 2*btnSize;
                signPosY = btnPosY;

                % floor lights
                flBtns(f) = rectangle('Parent',axesH, ...
                                        'Position',[btnPosY btnPosX btnSize btnSize], ...
                                        'FaceColor',offColor);
                                        
               % Elevator floor buttons
                text('Parent',axesH, ...
                     'Position',[signPosY signPosX], ...
                     'String',num2str(f), ...
                     'BackgroundColor','k', ...
                     'Color','w', ...
                     'FontName','FixedWidth', ...
                     'FontSize',signSize, ...
                     'ButtonDownFcn',...
                     ['try_p3(''change'',' num2str(f) ')'],...
                     'FontWeight','bold');
            end
            
            %Stop button
            Stopbtn = text( 'Parent',axesH, ...
                            'Position',[190 130], ...
                            'String','STOP', ...
                            'BackgroundColor','k', ...
                            'Color','w', ...
                            'FontSize',8, ...
                            'VerticalAlignment','bottom', ...
                            'HorizontalAlignment','right', ...
                            'EdgeColor','k', ...
                            'ButtonDownFcn','try_p3 change stop');
                        
            %Stop light
            StopLight = rectangle('Parent',axesH, ...
                         'Position',[200 125 btnSize btnSize], ...
                         'FaceColor',offStopColor);
                     
                     
            %Open sign
            Openbtn = text('Parent',axesH, ...
                         'Position',[50 130], ...
                         'String','OPEN', ...
                         'BackgroundColor','k', ...
                         'Color','w', ...
                         'FontSize',8, ...
                         'VerticalAlignment','bottom', ...
                         'HorizontalAlignment','right', ...
                         'EdgeColor','k');
           
            %Open light         
           OpenLight = rectangle('Parent',axesH, ...
                         'Position',[60 125 btnSize btnSize], ...
                         'FaceColor',offDoorColor);
                     
            set_param([model '/door'],'value','0');
           
        % Update the floor, stop  (output from the elevator)
        case 'change'
            if(varargin{1} <= numFloor)
                    set_param([model '/pressed'],'value',num2str(varargin{1}));
                    call_event = get_param([model '/call'],'value');
                    set_param([model '/call'],'value',num2str(~str2double(call_event)));
            end
            switch varargin{1}
                     case 'stop'
                         if (stop_val == 0)
                             set_param([model '/stop'],'value','1');
                             stop_val = 1;
                         else
                             set_param([model '/stop'],'value','0');
                             stop_val = 0;
                         end
            end
            
        %Turning on the floor, stop lights ( by controller)
        case 'on'
                 if(varargin{1} <= numFloor)
                    actv = flBtns(varargin{1});
                    set(actv,'FaceColor',onColor);
                 end
                 switch varargin{1}
                     case 'stop'
                         if (stop_val == 1)
                             actv = StopLight;
                             set(actv,'FaceColor',onStopColor);
                         else
                             try_p3('off','stop');
                         end
                 end
                 
        %Turning off the floor, stop lights ( by controller)
        case 'off'
                if(varargin{1} <= numFloor)
                    actv = flBtns(varargin{1});
                    set(actv,'FaceColor',offColor);
                end
                switch varargin{1}
                    case 'stop'
                        if (stop_val == 0)
                            actv = StopLight;
                            set(actv,'FaceColor',offStopColor);
                        end
                end
                
        %Turning on/off door lights (by controller)
        case 'open'
            actv = OpenLight;
            set(actv,'FaceColor',onDoorColor);
            set_param([model '/door'],'value','1');
        case 'close'
            actv = OpenLight;
            set(actv,'FaceColor',offDoorColor);
            set_param([model '/door'],'value','0');

    end
    
