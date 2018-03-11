clc;clear all;close all;

load('Foreground_foregroundaperture.mat');
load('Background_foregroundaperture.mat');

figure;
for i = 1:49
% imshow(Background(:,:,i))
% imshow(Foreground(:,:,i))
subplot(1,2,1), subimage(Background(:,:,i)); title('Low-Rank');
subplot(1,2,2), subimage(Foreground(:,:,i)); title('Sparse');

 pause(0.5)
i
end