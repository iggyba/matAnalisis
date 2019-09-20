function varargout = GUI2(varargin)
% GUI2 MATLAB code for GUI2.fig
%      GUI2, by itself, creates a new GUI2 or raises the existing
%      singleton*.
%
%      H = GUI2 returns the handle to a new GUI2 or the handle to
%      the existing singleton*.
%
%      GUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI2.M with the given input arguments.
%
%      GUI2('Property','Value',...) creates a new GUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI2

% Last Modified by GUIDE v2.5 19-Sep-2019 15:40:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI2_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI2_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before GUI2 is made visible.
function GUI2_OpeningFcn(hObject, eventdata, handles, varargin)


handles.output = hObject;

 
  N = imread('white.jpg');
  axes(handles.axes5);
  imshow(N);

  M = imread('vacio.jpg');
  axes(handles.axes1);
  imshow(M);

  handles.modoManual = true; %Empieza en modo Manual
      
  [handles.re, handles.reFs] = audioread('RE4.mp4');        
  [handles.sol, handles.solFs] = audioread('SOL3.mp4');        
  [handles.la, handles.laFs] = audioread('LA4.mp4');
        
  [handles.mi,handles.miFs] = audioread('MI5.mp4');
      
  handles.reFq = 293.7;
  handles.solFq = 196;
  handles.laFq = 440;
  handles.miFq = 659.3;

guidata(hObject, handles);

% UIWAIT makes GUI2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI2_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)

 I = imread('nota d.jpg');
 axes(handles.axes1);
 imshow(I);
 
if handles.modoManual
    
    sound(handles.re,handles.reFs);
    
else
    
    sfreq = num2str(handles.reFq)
    myString = append(sfreq,' ',"Hz")
    set(handles.text12, 'String', myString);
    
    grabacion = audiorecorder; 
    Fs = grabacion.SampleRate;
    disp('Hablá pariente');
    recordblocking(grabacion, 4);
    disp('Se acabó la grabación');

    y=  getaudiodata(grabacion);
    L = 32000;
    Y =fft(y);

    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);

    f = Fs*(0:(L/2))/L;
    %plot(handles.axes4,f,P1);

   [b,a]=ellip(5,0.1,40,[200 400]*2/Fs);
    [H,w]=freqz(b,a,512*20);
    %plot(handles.axes5,w*Fs/(2*pi),abs(H))

    sf1=filter(b,a,y);
    yFF=[Fs/length(y):Fs/length(y):floor(Fs/2)];
    yAF=abs(fft(sf1));
    yAFF=yAF(1:length(yFF));
    plot(handles.axes5,yFF,yAFF);
    
    xIndex = find(yAFF == max(yAFF), 1, 'first');
    frequencia = f(xIndex)
         
    freqStr = num2str(frequencia);
    freqS = append(freqStr,' ',"Hz");
    set(handles.text11, 'String', freqS);
    
    diff = abs(frequencia - handles.reFq);
    
    if diff < 2
        set(handles.text10,'String',"Afinada");
        set(handles.text10,'ForegroundColor',[0.635 0.078 0.184]);
    else
        set(handles.text10,'String',"Desafinada");
        
    end

            
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)

 J = imread('nota g.jpg');
 axes(handles.axes1);
 imshow(J);
 
 if handles.modoManual
    
    sound(handles.sol,handles.solFs);
 else
     
    sfreq = num2str(handles.solFq)
    myString = append(sfreq,' ',"Hz")
    set(handles.text12, 'String', myString);
    
     
    grabacion = audiorecorder; 
    Fs = grabacion.SampleRate;
    disp('Hablá pariente');
    recordblocking(grabacion, 4);
    disp('Se acabó la grabación');

    y=  getaudiodata(grabacion);
    L = 32000;
    Y =fft(y);

    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);

    f = Fs*(0:(L/2))/L;
    %plot(handles.axes4,f,P1);    
    
    
   [b,a]=ellip(5,0.1,40,[300 500]*2/Fs);
    [H,w]=freqz(b,a,512*20);
    %plot(handles.axes5,w*Fs/(2*pi),abs(H))
    
    sf1=filter(b,a,y);
    yFF=[Fs/length(y):Fs/length(y):floor(Fs/2)];
    yAF=abs(fft(sf1));
    yAFF=yAF(1:length(yFF));
    plot(handles.axes5,yFF,yAFF);
    
    xIndex = find(yAFF == max(yAFF), 1, 'first');
    frequencia = f(xIndex)
                
    freqStr = num2str(frequencia);
    freqS = append(freqStr,' ',"Hz");
    set(handles.text11, 'String', freqS);
    
    if diff < 2
        set(handles.text10,'String',"Afinada");
        set(handles.text10,'ForegroundColor',[0.635 0.078 0.184]);
    else
        set(handles.text10,'String',"Desafinada");
        
    end
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)

K = imread('nota a.jpg');
 axes(handles.axes1);
 imshow(K);
 
 if handles.modoManual
    
    sound(handles.la,handles.laFs);
 else
    sfreq = num2str(handles.laFq)
    myString = append(sfreq,' ',"Hz")
    set(handles.text12, 'String', myString);
    
    grabacion = audiorecorder; 
    Fs = grabacion.SampleRate;
    disp('Hablá pariente');
    recordblocking(grabacion, 4);
    disp('Se acabó la grabación');

    y=  getaudiodata(grabacion);
    L = 32000;
    Y =fft(y);

    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);

    f = Fs*(0:(L/2))/L;
    %plot(handles.axes4,f,P1); 
    
    
    [b,a]=ellip(5,0.1,40,[330 530]*2/Fs);
    [H,w]=freqz(b,a,512*20);
    %plot(handles.axes5,w*Fs/(2*pi),abs(H))
    
    sf1=filter(b,a,y);
    yFF=[Fs/length(y):Fs/length(y):floor(Fs/2)];
    yAF=abs(fft(sf1));
    yAFF=yAF(1:length(yFF));
    plot(handles.axes5,yFF,yAFF);
    
    xIndex = find(yAFF == max(yAFF), 1, 'first');
    frequencia = f(xIndex);   
        
    freqStr = num2str(frequencia);
    freqS = append(freqStr,' ',"Hz");
    set(handles.text11, 'String', freqS);
    
    
    if diff < 2
        set(handles.text10,'String',"Afinada");
        set(handles.text10,'ForegroundColor',[0.635 0.078 0.184]);
    else
        set(handles.text10,'String',"Desafinada");
        
    end
            
    
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
L = imread('nota e.jpg');
 axes(handles.axes1);
 imshow(L);
 
  if handles.modoManual

    sound(handles.mi,handles.miFs);
  else
      
    sfreq = num2str(handles.miFq)
    myString = append(sfreq,' ',"Hz")
    set(handles.text12, 'String', myString);
    
    grabacion = audiorecorder; 
    Fs = grabacion.SampleRate;
    disp('Hablá pariente');
    recordblocking(grabacion, 4);
    disp('Se acabó la grabación');

    y=  getaudiodata(grabacion);
    L = 32000;
    Y =fft(y);

    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);

    f = Fs*(0:(L/2))/L;
    %plot(handles.axes4,f,P1);
    
    [b,a]=ellip(5,0.1,40,[2*550 2*750]*2/Fs);
    [H,w]=freqz(b,a,512*20);
   % plot(handles.axes5,w*Fs/(2*pi),abs(H))
    
    sf1=filter(b,a,y);
    yFF=[Fs/length(y):Fs/length(y):floor(Fs/2)];
    yAF=abs(fft(sf1));
    yAFF=yAF(1:length(yFF));
    plot(handles.axes5,yFF,yAFF);
    
    xIndex = find(yAFF == max(yAFF), 1, 'first');
    frequencia = f(xIndex);
    
    freqStr = num2str(frequencia);
    freqS = append(freqStr,' ',"Hz");
    set(handles.text11, 'String', freqS);
    
    
    if diff < 2
        set(handles.text10,'String',"Afinada");
        set(handles.text10,'ForegroundColor',[0.635 0.078 0.184]);
    else
        set(handles.text10,'String',"Desafinada");
        
    end

    
  end


function pushbutton6_Callback(hObject, eventdata, handles)

handles.modoManual = ~handles.modoManual;

if handles.modoManual
    handles.pushbutton6.String = "Manual";
    guidata(hObject, handles);
else 
    handles.pushbutton6.String = "Auto";
    guidata(hObject, handles);
end
