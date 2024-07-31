%  o o o o o o     
%    o o o o o                                           
%    o o o o o    Scale                           
%    o o o o o    Setup, Configuration and Analysis of Listening Experiements
%    o o o                                                                                               
%          
%
%    Cologne University of Applied Sciences             
%    
%
%
% Scale : Release R15-0416 
% -----------------------------------------------------------------------
% 
%
% 
% /// Feel free to modify and share BUT: Always mark your changes please!
%
%
% ----------------------------------------------------------------------
%  
% File name: Scale.m
%
% 
% Description:
% -Launches the GUI after some checkings
%
% Functionality:
% -Checks if matlab current folder is Scale folder 
% -Checks if Scale_code_files and Scale_user_folder are present 
% -Adds all the files in the folder Scale_code_files, 
% needed to use the Scale software.
% -Checks if the right files in Scale_user_folder are present
% -Saves some system information
% -Randomise the random seed
% -Launch the GUI
%
% Author: Arnau Vázquez



%%%check that the user is running the program with the "Scale" folder as
%%%current directory in Matlab and both Scale_user_folder and
%%%Scale_code_files are there present. If not, give and error message and
%%%stop
warning('off','all');
close all;
clear all;
clc;

current_directory=pwd;
if ~strcmp(current_directory(end-4:end),'Scale')
   warningMessage = sprintf(['Your current working directory in Matlab has to' ...
       'be set to "Scale" folder.']);
   uiwait(warndlg(warningMessage));
   return; 
end

contents=dir;
code_files_found=false;
user_folder_found=false;

for i=1:length(dir)
      code_files_found=code_files_found+strcmp(contents(i).name,'Scale_code_files');
      user_folder_found=user_folder_found+strcmp(contents(i).name,'Scale_user_folder');
end

if (~code_files_found || ~user_folder_found)
   warningMessage = sprintf(['The folder/s Scale_code_files and/or Scale_user_folder were not found' ...
       ' they are needed to run the program, please correct the problem.']);
   uiwait(warndlg(warningMessage));
   return; 
end

%%%add to the matlab search path all the folders and files inside Scale_code_files 
%%%and Scale_user_folde using addpath
Scale_user_folder_contents=genpath(fullfile(current_directory,'Scale_code_files'));
Scale_code_files_contents=genpath(fullfile(current_directory,'Scale_user_folder'));
addpath(Scale_user_folder_contents);
addpath(Scale_code_files_contents);


%%%Check if Scale_user_folder contains the right folders if files are 
%%%missing give error message and stop the program
 missing_folders= '-Folders:\n';
 missing_items=0;
  %%%Check if all folders exist  
   if ~exist(fullfile('Scale_user_folder','subjects'))
       missing_folders=[missing_folders, 'subjects\n'];
       missing_items=missing_items+1;
   end
    
   if ~exist(fullfile('Scale_user_folder','tests'))
       missing_folders=[missing_folders, 'tests\n'];
       missing_items=missing_items+1;
   end

if (missing_items)
   warningMessage = sprintf(missing_folders);
   uiwait(warndlg(warningMessage));
   return; 
end

%%%saves the Matlab version ,the OS of the system and the path to the
%%%Scale folder in the Scale_user_folder/system/system_info.mat struct, 
%%%if the system is not MAC or WIN an error is displayed. It also saves the
%%%Scale version information
system_info.os='UNDEFINED';
if ismac 
    system_info.os='MAC';
elseif ispc
    system_info.os='WIN';
end
if strcmp(system_info.os,'UNDEFINED')
   warningMessage = sprintf('Only Windows and Mac operating systems are supported in this version.');
   uiwait(warndlg(warningMessage));
   return; 
end

load(fullfile('Scale_user_folder','system','system_info'));

system_info.matlab_release=version('-release');
system_info.scale_dir=pwd;
system_info.scale_version='Release R15-0416';

save(fullfile('Scale_user_folder','system','system_info.mat'),'system_info');

%%%"randomise" the random seed
rng('shuffle');

%%%start the program by launching the GUI_animation
clear all;
clc;
GUI_Start_intro();

    
    