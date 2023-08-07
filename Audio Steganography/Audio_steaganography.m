function varargout = Audio_steaganography(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Audio_steaganography_OpeningFcn, ...
                   'gui_OutputFcn',  @Audio_steaganography_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function Audio_steaganography_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
a=ones(300,512);
axes(handles.axes1);
imshow(a);
axes(handles.axes2);
imshow(a);
guidata(hObject, handles);

function varargout = Audio_steaganography_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function playaudio_Callback(hObject, eventdata, handles)
a=handles.a;
sound(a,44100);

function exit_Callback(hObject, eventdata, handles)
exit;

%%%%%%
function inputaudio_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile('*.wav', 'Pick an audio');
if isequal(filename,0) || isequal(pathname,0)
    warndlg('Audio is not selected');  
else                                     
    a=audioread(filename);
    axes(handles.axes1);                  
    plot(a);
    handles.filename=filename; 
    handles.a=a;
    guidata(hObject, handles);  
    helpdlg('Input audio is Selected'); 
end

%%%%%
function secretdata_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile('*.txt', 'Pick any txt file'); 
if isequal(filename,0) || isequal(pathname,0) 
	warndlg('text file is not selected'); 
else 
    fid = fopen(filename,'r'); 
	F = fread(fid);  
	s = char(F'); 
	fclose(fid);  
end  
handles.s=s;
handles.F=F;
guidata(hObject, handles);
helpdlg('Text File is Selected'); 

%%%%%%
function embedding_Callback(hObject, eventdata, handles)     
a=handles.a; 
s=handles.s; 
F=handles.F;  
Q_SIZE = 3;
c=round(a*(10^Q_SIZE)); 
i=1;
ii=51; 
while i <=length(s)
	if c(ii,1)<0  
        sbit1 = -1; 
    else
        sbit1 =  1; 
	end
    iii = ii+2; 
	if c(iii,1)<0
        sbit2 = -1;
    else
        sbit2 =  1;
	end
	c(ii,1) = abs(c(ii,1));
	c(iii,1) = abs(c(iii,1)); 
	[c(ii,1),c(iii,1)]=Enc_Char(c(ii,1),c(iii,1),F(i));
	c(ii,1) = sbit1*c(ii,1); 
    c(iii,1) = sbit2*c(iii,1); 
    i=i+1; 
    ii = iii+2;
end
            n  = length(F); 
			d=c/(10^Q_SIZE);
            axes(handles.axes2);
            plot(d);
			audiowrite('Embedded.WAV',d,44100); 
			helpdlg('Embedding process completed'); 
pass=passkey;
s2 = char(pass); 
ss = length(s2);
if  ss==4       
    helpdlg('Password Sucessesfully added'); 
else
    errordlg('Enter the Valid password');
end
num = dec2bin(s2,8); 
disp(num);
handles.pass = num;
handles.d=d;
handles.n = n;
guidata(hObject, handles);

%%%%%%
function extraction_Callback(hObject, eventdata, handles)
n=handles.n; 
pass=handles.pass;
pass1=passkey;
s2 = char(pass1);
ss = length(s2);
if  ss==4
    helpdlg('Password Sucessesfully added');
else
    errordlg('Enter the Valid password');
end
pass1 = dec2bin(s2,8); 
temp=0;
for i=1:4 
    for j=1:8 
        if pass(i,j)==pass1(i,j) 
            temp=temp+1; 
        else
            temp = 0;
        end
    end
end

if temp == 32
	else
    errordlg('Password missmached');
	exit;
end
               
a=audioread('Embedded.wav');
Q_SIZE = 3;
c=round(a*(10^Q_SIZE));

i = 1;
TXT_LENGTH = n;
ii=51;
while i <= TXT_LENGTH
c(ii,1) = abs(c(ii,1));
iii = ii+2;
c(iii,1) = abs(c(iii,1));
s(i)=Dec_Char(c(ii,1),c(iii,1));
i = i+1;
ii = iii+2;
end
fid = fopen('output.txt','wb');
fwrite(fid,char(s'),'char');
fclose(fid);
helpdlg('Extraction process completed');

function viewoutput_Callback(hObject, eventdata, handles)
open 'output.txt'; 

function playaudio1_Callback(hObject, eventdata, handles)
d = handles.d;
sound(d,44100);

function edit1_Callback(hObject, eventdata, handles)

function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','blue');
end

function edit2_Callback(hObject, eventdata, handles)

function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','blue');
end

function validation_Callback(hObject, eventdata, handles)
inpaud = handles.a;
embaud = handles.d; 

[Y,Z]=psnr(inpaud,embaud);
set(handles.edit1,'string',Y);
set(handles.edit2,'string',Z);
