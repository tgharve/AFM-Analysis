    function varargout = Analysis(varargin)
% ANALYSIS MATLAB code for Analysis.fig
%      ANALYSIS, by itself, creates a new ANALYSIS or raises the existing
%      singleton*.
%
%      H = ANALYSIS returns the handle to a new ANALYSIS or the handle to
%      the existing singleton*.
%
%      ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALYSIS.M with the given input arguments.
%
%      ANALYSIS('Property','Value',...) creates a new ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Analysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Analysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Analysis

% Last Modified by GUIDE v2.5 03-Oct-2017 11:45:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Analysis_OpeningFcn, ...
    'gui_OutputFcn',  @Analysis_OutputFcn, ...
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


% --- Executes just before Analysis is made visible.
function Analysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Analysis (see VARARGIN)

% Choose default command line output for Analysis
handles.output = hObject;
g = gausswin(100); % <-- this value determines the width of the smoothing window
handles.g = g/sum(g);

% Update handles structure
handles.fileroots = getappdata(0,'fileroots');
handles.fname = getappdata(0,'fname');
handles.step = 2;
guidata(hObject, handles);

% UIWAIT makes Analysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Analysis_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
fname = getappdata(0,'fname');
fileroots = getappdata(0,'fileroots');
curve = get(hObject,'Value');
fid = fopen(strcat(fname,'\',fileroots{curve},'Force.txt'),'r');
if(fid == -1)
    fid = fopen(strcat(fname,'\',fileroots{curve},'ZSnsr.txt'),'r');
    currentx = fscanf(fid,'%f')*10^9;
    fclose(fid);
    fid = fopen(strcat(fname,'\',fileroots{curve},'Defl.txt'),'r');
    y = fscanf(fid,'%f')*10^9;
    currenty = conv(y,handles.g,'same');
    fclose(fid);
    xtitle = 'Z Sensor Displacement (nm)';
    ytitle = 'Deflection (nm)';
    handles.step=2;
else
    sizeA = [2 Inf];
    A = fscanf(fid,'%f %f',sizeA)*10^9;
    fclose(fid);
    A=A';
    currentx = A(:,1);
    currenty = A(:,2);
    xtitle = 'Indentation Depth (nm)';
    ytitle = 'Force (nN)';
    handles.step = 6;
end

set(handles.P,'xdata',currentx,'ydata',currenty);
set(handles.O,'xdata',currentx,'ydata',zeros(size(currentx)));
set(handles.Ov,'xdata',zeros(size(currenty)),'ydata',currenty);


xlabel(xtitle);
ylabel(ytitle);
drawnow();
clear handles.currentx handles.currenty handles.Ecell;
set(handles.edit2,'String','');
handles.fname = fname;
handles.currentx = currentx;
handles.currenty = currenty;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String', getappdata(0,'fileroots'));
set(hObject,'Value',1);
guidata(hObject,handles);



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x = get(handles.listbox1, 'Value');
if (x>1)
    x = x-1;
else
    x = size(handles.fileroots,2);
end
set(handles.listbox1,'Value',x);
fname = getappdata(0,'fname');
fileroots = getappdata(0,'fileroots');
curve = x;
fid = fopen(strcat(fname,'\',fileroots{curve},'Force.txt'),'r');
if(fid == -1)
    fid = fopen(strcat(fname,'\',fileroots{curve},'ZSnsr.txt'),'r');
    currentx = fscanf(fid,'%f')*10^9;
    fclose(fid);
    fid = fopen(strcat(fname,'\',fileroots{curve},'Defl.txt'),'r');
    y = fscanf(fid,'%f')*10^9;
    currenty = conv(y,handles.g,'same');
    fclose(fid);
    xtitle = 'Z Sensor Displacement (nm)';
    ytitle = 'Deflection (nm)';
    handles.step=2;
else
    sizeA = [2 Inf];
    A = fscanf(fid,'%f %f',sizeA)*10^9;
    fclose(fid);
    A=A';
    currentx = A(:,1);
    currenty = A(:,2);
    xtitle = 'Indentation Depth (nm)';
    ytitle = 'Force (nN)';
    handles.step = 6;
end

set(handles.P,'xdata',currentx,'ydata',currenty);
set(handles.O,'xdata',currentx,'ydata',zeros(size(currentx)));
set(handles.Ov,'xdata',zeros(size(currenty)),'ydata',currenty);

xlabel(xtitle);
ylabel(ytitle);
drawnow();
clear handles.currentx handles.currenty;
handles.currentx = currentx;
handles.currenty = currenty;
handles.step = 2;
guidata(hObject,handles);



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x = get(handles.listbox1, 'Value');
if (x<size(handles.fileroots,2))
    x = x+1;
else
    x = 1;
end
set(handles.listbox1,'Value',x);
fname = getappdata(0,'fname');
fileroots = getappdata(0,'fileroots');
curve = x;
fid = fopen(strcat(fname,'\',fileroots{curve},'Force.txt'),'r');
if(fid == -1)
    fid = fopen(strcat(fname,'\',fileroots{curve},'ZSnsr.txt'),'r');
    currentx = fscanf(fid,'%f')*10^9;
    fclose(fid);
    fid = fopen(strcat(fname,'\',fileroots{curve},'Defl.txt'),'r');
    y = fscanf(fid,'%f')*10^9;
    currenty = conv(y,handles.g,'same');
    fclose(fid);
    xtitle = 'Z Sensor Displacement (nm)';
    ytitle = 'Deflection (nm)';
    handles.step=2;
else
    sizeA = [2 Inf];
    A = fscanf(fid,'%f %f',sizeA)*10^9;
    fclose(fid);
    A=A';
    currentx = A(:,1);
    currenty = A(:,2);
    xtitle = 'Indentation Depth (nm)';
    ytitle = 'Force (nN)';
    handles.step = 6;
end

set(handles.P,'xdata',currentx,'ydata',currenty);
set(handles.O,'xdata',currentx,'ydata',zeros(size(currentx)));
set(handles.Ov,'xdata',zeros(size(currenty)),'ydata',currenty);

xlabel(xtitle);
ylabel(ytitle);
drawnow();
clear handles.currentx handles.currenty;
handles.currentx = currentx;
handles.currenty = currenty;
handles.step=2;
guidata(hObject,handles);



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


choice = questdlg('Are you sure want to do that? Any unsaved data will be lost.','Warning','Yes','No','No');
switch choice
    case 'No'
        %do nothing
    case 'Yes'
        delete(handles.figure1)
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.step >= 2 && handles.step <6)
    uiwait(msgbox('Click on the plot to draw a box around a portion of the baseline. Double-click the box when finished.','Baseline Offset','modal'));
    bl = false;
    while (bl == false)
        b = imrect;
        pos = wait(b);
        answer = questdlg('Is this box you drew correct?','Baseline Offset','Yes','Try Again','Cancel','Try Again');
        switch answer
            case 'Yes'
                bl = true;
                delete(b);
            case 'Cancel'
                delete(b);
                break
            case 'Try Again'
                delete(b);
        end
    end
    if (bl)
        currentx = handles.currentx;
        currenty = handles.currenty;
        [currenty, base] = BaseLineFit(currenty,currentx, pos(1), pos(1)+pos(3));
        set(handles.P,'xdata',currentx,'ydata',currenty);
        set(handles.O,'xdata',currentx,'ydata',zeros(size(currentx)));
        set(handles.Ov,'xdata',zeros(size(currenty)),'ydata',currenty);

        drawnow();
        clear handles.currenty;
        handles.currenty = currenty;
        handles.base = base;
    end
    handles.step=3;
elseif (handles.step == 6)
    h = msgbox('This curve was already converted to a force.','Error','Error');

else
    h = msgbox('No curve loaded.', 'Error', 'Error');
end
guidata(hObject,handles);



% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.step == 5 && handles.step < 6)
    k = str2num(get(handles.edit1,'String'));
    currentx = handles.currentx;
    currenty = handles.currenty;
    if (isempty(k) || k <= 0)
        h=msgbox('Invalid spring constant! Check the value you entered in step 1.','Error','Error');
    else
        handles.k = k;
        currenty = currenty * k;
        set(handles.P,'xdata',currentx,'ydata',currenty);
        set(handles.O,'xdata',currentx,'ydata',zeros(size(currentx)));
        set(handles.Ov,'xdata',zeros(size(currenty)),'ydata',currenty);

        ylabel('Force (nN)');
        drawnow();
        clear handles.currenty;
        handles.currenty = currenty;
    end
    handles.step = 6;
elseif (handles.step == 6)
    h = msgbox('This curve was already converted to a force.','Error','Error');
else
    h = msgbox('You must define the contact point first.','Error','Error');
end
guidata(hObject, handles);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.step >= 4 && handles.step <6)
    currentx = handles.currentx;
    currenty = handles.currenty;
    ind = find(currenty > 0.01*(max(currenty)));
    ContactPoint = currentx(min(ind));
    currentx = currentx - ContactPoint;
    set(handles.P,'xdata',currentx,'ydata',currenty);
    set(handles.O,'xdata',currentx,'ydata',zeros(size(currentx)));
    set(handles.Ov,'xdata',zeros(size(currenty)),'ydata',currenty);

    xlabel('Indentation Depth (nm)');
    drawnow();
    clear handles.currentx;
    handles.currentx = currentx;
    handles.step = 5;
elseif (handles.step == 6)
    h = msgbox('This curve was already converted to a force.','Error','Error');

else
    h = msgbox('You must convert the x-axis to tip deflection first.','Error','Error');
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
currentx = handles.currentx - 0.005*(max(handles.currentx)-min(handles.currentx));
currenty = handles.currenty;
set(handles.P,'xdata',currentx,'ydata',currenty);
set(handles.O,'xdata',currentx,'ydata',zeros(size(currentx)));
set(handles.Ov,'xdata',zeros(size(currenty)),'ydata',currenty);

drawnow();
clear handles.currentx;
handles.currentx = currentx;
guidata(hObject, handles);

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
currentx = handles.currentx + 0.005*(max(handles.currentx)-min(handles.currentx));
currenty = handles.currenty;
set(handles.P,'xdata',currentx,'ydata',currenty);
set(handles.O,'xdata',currentx,'ydata',zeros(size(currentx)));
set(handles.Ov,'xdata',zeros(size(currenty)),'ydata',currenty);

drawnow();
clear handles.currentx;
handles.currentx = currentx;
guidata(hObject, handles);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.step>=3 && handles.step <4)
    currentx = handles.currentx;
    currenty = handles.currenty;
    currentx = currentx - currenty;
    set(handles.P,'xdata',currentx,'ydata',currenty);
    set(handles.O,'xdata',currentx,'ydata',zeros(size(currentx)));
    set(handles.Ov,'xdata',zeros(size(currenty)),'ydata',currenty);

    xlabel('Tip-Sample Separation Distance (nm)');
    drawnow();
    clear handles.currentx;
    handles.currentx = currentx;
    handles.step = 4;
elseif (handles.step == 6)
    h = msgbox('This curve was already converted to a force.','Error','Error');
elseif (handles.step == 4 || handles.step == 5)
    h = msgbox('This curve was already converted to tip deflection.','Error','Error');
else
    h = msgbox('You must remove the baseline offset first.','Error','Error');
end
guidata(hObject, handles);



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
currenty = handles.currenty + 0.005*(max(handles.currenty)-min(handles.currenty));
currentx = handles.currentx;
set(handles.P,'xdata',currentx,'ydata',currenty);
set(handles.O,'xdata',currentx,'ydata',zeros(size(currentx)));
set(handles.Ov,'xdata',zeros(size(currenty)),'ydata',currenty);

drawnow();
clear handles.currenty;
handles.currenty = currenty;
guidata(hObject, handles);

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
currenty = handles.currenty - 0.005*(max(handles.currenty)-min(handles.currenty));
currentx = handles.currentx;
set(handles.P,'xdata',currentx,'ydata',currenty);
set(handles.O,'xdata',currentx,'ydata',zeros(size(currentx)));
set(handles.Ov,'xdata',zeros(size(currenty)),'ydata',currenty);

drawnow();
clear handles.currenty;
handles.currenty = currenty;
guidata(hObject, handles);

% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.step >= 6)
    Rtip = str2num(get(handles.edit3,'String'));
    currentx = handles.currentx;
    currenty = handles.currenty;
    if (isempty(Rtip) || Rtip <= 0)
        h=msgbox('Invalid Tip Radius! Check the value you entered in step 1.','Error','Error');
    else
        handles.Rtip = Rtip;
        [E, Q] = FitHertzModel(currenty,currentx,Rtip);
        Ecell = E * 10^-3;
        set(handles.edit2,'String',Ecell);
        set(handles.edit4,'String',Q);
        handles.Ecell = Ecell;
    end
elseif (handles.step == 6)
    h = msgbox('This curve was already converted to a force.','Error','Error');    
else
    h = msgbox('You must convert the curve to a force first.','Error','Error'); 
end
guidata(hObject,handles);


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.step == 6)
   currenty = 1E-9*handles.currenty;
   currentx = 1E-9*handles.currentx;
   roots = get(handles.listbox1,'String');
   root = roots{get(handles.listbox1,'Value')};
   filename = strcat(handles.fname,'/',root,'Force.txt');
    s = fopen(filename,'w');
    fprintf(s,'%e\t%e\r\n',[currentx,currenty]');
    fclose(s);
    h = msgbox('Force curve sucessfully saved.');
else 
    h = msgbox('You must convert this to a force curve before saving.','Error','Error');
end

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate axes1


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.axes1 = hObject;
g = gausswin(100); % <-- this value determines the width of the smoothing window
handles.g = g/sum(g);
fname = getappdata(0,'fname');
fileroots = getappdata(0,'fileroots');
curve = 1;
fid = fopen(strcat(fname,'\',fileroots{curve},'Force.txt'),'r');
if(fid == -1)
    fid = fopen(strcat(fname,'\',fileroots{curve},'ZSnsr.txt'),'r');
    currentx = fscanf(fid,'%f')*10^9;
    fclose(fid);
    fid = fopen(strcat(fname,'\',fileroots{curve},'Defl.txt'),'r');
    y = fscanf(fid,'%f')*10^9;
    currenty = conv(y,handles.g,'same');
    fclose(fid);
    xtitle = 'Z Sensor Displacement (nm)';
    ytitle = 'Deflection (nm)';
    handles.step=2;
else
    sizeA = [2 Inf];
    A = fscanf(fid,'%f %f',sizeA)*10^9;
    fclose(fid);
    A=A';
    currentx = A(:,1);
    currenty = A(:,2);
    xtitle = 'Indentation Depth (nm)';
    ytitle = 'Force (nN)';
    handles.step = 6;
end

handles.P = plot(hObject,currentx,currenty,'b');
hold on
handles.O = plot(hObject,currentx,zeros(size(currentx)),':k');
handles.Ov = plot(hObject,zeros(size(currenty)),currenty,':k');

xlabel(xtitle);
ylabel(ytitle);
%hObject.XAxisLocation = 'origin';
%hObject.YAxisLocation = 'origin';
clear handles.currentx handles.currenty;
handles.currentx = currentx;
handles.currenty = currenty;
handles.step = 2;
guidata(hObject,handles);
% Hint: place code in OpeningFcn to populate axes2


% --- Executes during object creation, after setting all properties.
function pushbutton4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
