% UROS Project (July 2017) - Photometric Seed Analysis
% Peter Leonard Hart - HAR12421031
% Staff Supervisor: Wenting Duan

% LOAD IMAGE
close all; clc; clear; % Reset

% Dialog box for file selection (filter = .jpg,.png)
[fileNames, pathName, filterIndex] = uigetfile({'*.jpg;*.png;','All Image Files';'*.*','All Files'},'Select Input Images...','MultiSelect', 'on');

% Check if only one file is selected
if ~iscell(fileNames)
    fileNames = {fileNames}; % If only one file is selected, ensure the file name is cell and not character
end 

totalFiles = size(fileNames,2); % Store total count for how many files are going to be processed.

for i=1:totalFiles % Iterate until processed all selected files
    selectedFile = strcat(pathName,char(fileNames(i))); %concatenate selected file and the folder path
    im = double(imread(selectedFile)); % Gather input
    imStruct = size(im(:,:,:));  % Store the structural data about the image
    imRows = (imStruct(1)); imColumns = (imStruct(2)); % Store structure data into separate variables (for clarity)

    %     % IMAGE ENHANCEMENT
    %     %im2 = imtophat(im,strel('disk',10));
    if size(im,3)==3
        im = rgb2gray(im); % Greyscale conversion formula: 0.2989 * R + 0.5870 * G + 0.1140 * B 4
        im = double(im);
    end
    imAdj = imadjust(im);
    imHist = adapthisteq(im); %histogram equalisation

    %     im = im+0.03*randn(size(im));
    %     im(im<0) = 0; im(im>1) = 1;
    % 
    %     % SEGMENTATION
    % 
    % 
    %     % CANNY
    %     % Canny with Gaussian filter
    %     BW = edge(imAdj,'Canny',[],20);
    %     BW = imdilate(BW,strel('square',2));
    %     BW = imfill(BW,'holes');
    % 
    %     % Canny with Bilateral filter (preserve edges)
    %     T_Low = 0.075; %Value for Thresholding
    %     T_High = 0.175;
    % 
    %     w     = 5;       % bilateral filter half-width
    %     sigma = [3 0.1]; % bilateral filter standard deviations
    % 
    %     A = int32(bfilter2(im,w,sigma)); % Apply bilateral filter to each image.
    %     %Filter for horizontal and vertical direction
    %     KGx = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
    %     KGy = [1, 2, 1; 0, 0, 0; -1, -2, -1];
    % 
    %     %Convolution by image by horizontal and vertical filter
    %     Filtered_X = conv2(A, KGx, 'same');
    %     Filtered_Y = conv2(A, KGy, 'same');
    % 
    %     %Calculate directions/orientations
    %     arah = atan2 (Filtered_Y, Filtered_X);
    %     arah = arah*180/pi;
    % 
    %     pan=size(A,1);
    %     leb=size(A,2);
    % 
    %     %Adjustment for negative directions, making all directions positive
    %     for i=1:pan
    %         for j=1:leb
    %             if (arah(i,j)<0) 
    %                 arah(i,j)=360+arah(i,j);
    %             end;
    %         end;
    %     end;
    % 
    %     arah2=zeros(pan, leb);
    % 
    %     %Adjusting directions to nearest 0, 45, 90, or 135 degree
    %     for i = 1  : pan
    %         for j = 1 : leb
    %             if ((arah(i, j) >= 0 ) && (arah(i, j) < 22.5) || (arah(i, j) >= 157.5) && (arah(i, j) < 202.5) || (arah(i, j) >= 337.5) && (arah(i, j) <= 360))
    %                 arah2(i, j) = 0;
    %             elseif ((arah(i, j) >= 22.5) && (arah(i, j) < 67.5) || (arah(i, j) >= 202.5) && (arah(i, j) < 247.5))
    %                 arah2(i, j) = 45;
    %             elseif ((arah(i, j) >= 67.5 && arah(i, j) < 112.5) || (arah(i, j) >= 247.5 && arah(i, j) < 292.5))
    %                 arah2(i, j) = 90;
    %             elseif ((arah(i, j) >= 112.5 && arah(i, j) < 157.5) || (arah(i, j) >= 292.5 && arah(i, j) < 337.5))
    %                 arah2(i, j) = 135;
    %             end;
    %         end;
    %     end;
    % 
    %     figure, imagesc(arah2); colorbar;
    % 
    %     %Calculate magnitude
    %     magnitude = (Filtered_X.^2) + (Filtered_Y.^2);
    %     magnitude2 = sqrt(magnitude);
    % 
    %     BW = zeros (pan, leb);
    % 
    %     %Non-Maximum Supression
    %     for i=2:pan-1
    %         for j=2:leb-1
    %             if (arah2(i,j)==0)
    %                 BW(i,j) = (magnitude2(i,j) == max([magnitude2(i,j), magnitude2(i,j+1), magnitude2(i,j-1)]));
    %             elseif (arah2(i,j)==45)
    %                 BW(i,j) = (magnitude2(i,j) == max([magnitude2(i,j), magnitude2(i+1,j-1), magnitude2(i-1,j+1)]));
    %             elseif (arah2(i,j)==90)
    %                 BW(i,j) = (magnitude2(i,j) == max([magnitude2(i,j), magnitude2(i+1,j), magnitude2(i-1,j)]));
    %             elseif (arah2(i,j)==135)
    %                 BW(i,j) = (magnitude2(i,j) == max([magnitude2(i,j), magnitude2(i+1,j+1), magnitude2(i-1,j-1)]));
    %             end;
    %         end;
    %     end;
    % 
    %     BW = BW.*magnitude2;
    %     figure, imshow(BW);
    % 
    %     %Hysteresis Thresholding
    %     T_Low = T_Low * max(max(BW));
    %     T_High = T_High * max(max(BW));
    % 
    %     T_res = zeros (pan, leb);
    % 
    %     for i = 1  : pan
    %         for j = 1 : leb
    %             if (BW(i, j) < T_Low)
    %                 T_res(i, j) = 0;
    %             elseif (BW(i, j) > T_High)
    %                 T_res(i, j) = 1;
    %             %Using 8-connected components
    %             elseif ( BW(i+1,j)>T_High || BW(i-1,j)>T_High || BW(i,j+1)>T_High || BW(i,j-1)>T_High || BW(i-1, j-1)>T_High || BW(i-1, j+1)>T_High || BW(i+1, j+1)>T_High || BW(i+1, j-1)>T_High)
    %                 T_res(i,j) = 1;
    %             end;
    %         end;
    %     end;
    % 
    %     edge_final = uint8(T_res.*255);



    % WATERSHED

    imBin = im2bw(imHist,graythresh(imHist));
    imBinC = ~imBin;
    imBinED = bwdist(imBinC,'euclidean'); 
    L = watershed(-imBinED); %label matrix
    w = L == 0;
    g2 = imBin & ~w;
    im2 = imopen(imBinED,strel('disk',4));

    figure;
    imshow(imBinED);
    figure;
    imshow(~im2);
    % K-MEANS CLUSTERING
    % cform = makecform('srgb2lab');
    % lab_he = applycform(im,cform);
    % 
    % ab = double(lab_he(:,:,2:3));
    % nrows = size(ab,1);
    % ncols = size(ab,2);
    % ab = reshape(ab,nrows*ncols,2);
    % 
    % nColors = 3; %LAB
    % [cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean','Replicates',3);
    % pixel_labels = reshape(cluster_idx,nrows,ncols);
    % segmented_images = cell(1,3);
    % rgb_label = repmat(pixel_labels,[1 1 3]);
    % 
    % for k = 1:nColors
    %     color = im;
    %     color(rgb_label ~= k) = 0;
    %     segmented_images{k} = color;
end
%end of script