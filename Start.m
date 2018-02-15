function varargout = Start(varargin)
% START MATLAB code for Start.fig
%      START, by itself, creates a new START or raises the existing
%      singleton*.
%
%      H = START returns the handle to a new START or the handle to
%      the existing singleton*.
%
%      START('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in START.M with the given input arguments.
%
%      START('Property','Value',...) creates a new START or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Start_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Start_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Start

% Last Modified by GUIDE v2.5 15-Feb-2018 08:40:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Start_OpeningFcn, ...
    'gui_OutputFcn',  @Start_OutputFcn, ...
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


% --- Executes just before Start is made visible.
function Start_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Start (see VARARGIN)

% Choose default command line output for Start
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Start wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Start_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.fname = get(handles.edit1,'string');
handles.listing = dir(handles.fname);
guidata(hObject, handles);
if(~isempty(handles.listing))
    setappdata(0,'fname',handles.fname);
    loaddata(hObject, eventdata, handles);
else
    h = msgbox('Invalid Folder. Check the path and try again.','Error','Error');
    uiwait();
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fname = uigetdir();
if (fname)
    set(handles.edit1,'string',fname);
end

function loaddata(hObject, eventdata, handles)
i = 1; j = 1; k = 1;
for a = 1:size(handles.listing,1)
    if(~isempty(strfind(handles.listing(a).name,'Raw')) && ~handles.listing(a).isdir)
        raw_names{i} = handles.listing(a).name(1:strfind(handles.listing(a).name,'Raw')-1);
        i=i+1;
    elseif(~isempty(strfind(handles.listing(a).name,'ZSnsr')) && ~handles.listing(a).isdir)
        zsnsr_names{j} = handles.listing(a).name(1:strfind(handles.listing(a).name,'ZSnsr')-1);
        j=j+1;
    elseif(~isempty(strfind(handles.listing(a).name,'Defl')) && ~handles.listing(a).isdir)
        defl_names{k} = handles.listing(a).name(1:strfind(handles.listing(a).name,'Defl')-1);
        k=k+1;
    end 
end
fileroots = intersect(zsnsr_names, intersect(defl_names, raw_names));
setappdata(0,'fileroots',fileroots);
Analysis();
