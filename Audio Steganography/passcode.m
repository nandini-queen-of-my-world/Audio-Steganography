function CurrWord = passcode(action);

if nargin == 0 
   ScreenSize = get(0,'ScreenSize');
   h = figure('Menubar','none', ...
              'Units','Pixels', ...
              'Resize','off', ...
              'NumberTitle','off', ...
              'CloseRequestFcn','set(findobj(''Tag'',''password''),''UserData'',[]);uiresume', ...
              'Name',['enter 4 bit key'], ...
              'KeyPressFcn', 'passcode(''KeyPress_Callback'');', ...       
              'Position',[ (ScreenSize(3:4)-[300 75])/2 300 75 ], ...
              'Color',[0.8 0.8 0.8], ...
              'WindowStyle','modal');
   uicontrol( 'Parent',h, ...
              'Style','Edit', ...
              'Enable','inactive', ...
              'Units','Pixels','Position',[49 28 202 22], ...
              'FontSize',15, ...
              'BackGroundColor',[0.7 0.7 0.7]);
   uicontrol( 'Parent',h, ...
              'Style','Text', ...
              'Tag','password', ...
              'Units','Pixels','Position',[51 30 198 18], ...
              'FontSize',15, ...
              'BackGroundColor',[1 1 1]);
   uicontrol( 'Parent',h, ...
              'Style','Text', ...
              'Tag','error', ...
              'Units','Pixels','Position',[50 2 200 20], ...
              'FontSize',8, ...
              'String','character not allowed',...
              'Visible','off',...
              'ForeGroundColor',[1 0 0], ...              
              'BackGroundColor',[0.8 0.8 0.8]);
   uiwait
   CurrWord = get(findobj('Tag','password'),'UserData');      
   delete(h)
else
   switch action
   case 'KeyPress_Callback'
      CurrChar = get(gcf,'CurrentCharacter');
      CurrWord = get(findobj('Tag','password'),'UserData');
      
      if int8(CurrChar) == 8
          CurrWord = CurrWord(1:end-1);
      elseif int8(CurrChar) == 13
         uiresume
         return
      elseif ~isempty(CurrChar)
         if any(allowed_characters==CurrChar)
            CurrWord = [CurrWord CurrChar];
          else
            set(findobj('Tag','error'),'Visible','on')
            pause(0.5)
            set(findobj('Tag','error'),'Visible','off')   
         end
      end
      set(findobj('Tag','password'),'UserData',CurrWord, ...
          'String',char('*'*ones(1,length(CurrWord))))      
   end
end
function tmp = allowed_characters
tmp = ['ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789' ...
       '<>[]{}()@!?*#=~-+_.,;:�$%&/|\'];   


