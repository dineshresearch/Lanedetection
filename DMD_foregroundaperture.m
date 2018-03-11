%F:\dmd_pendrive\DMD_Output\Foregroundaperture
clc;clear all;close all;

Frames = zeros(540, 960, 40);
c = 0;
%for t=470:519
for t=1:100
    c = c + 1;
% 	name=sprintf('lightswicth/%d.bmp', t);
%   name = strcat('foregroundaperture/b00',num2str(t),'.bmp');
    name = strcat('vid/Image',num2str(t),'.jpg');
	display(name)
	img=imread(name);
	imggray=rgb2gray(img);
	Frames(:, :, c)=imggray;
end


sizeOfFrames = size(Frames);
assert(length(sizeOfFrames) == 3, 'Input must be a three dimensional matrix')
heightFrame = sizeOfFrames(1);
widthFrame = sizeOfFrames(2); 
numberFrames = sizeOfFrames(3);
FramesVectorized = zeros(heightFrame * widthFrame, numberFrames);


for i=1:numberFrames
    temp = Frames(:,:,i);
    FramesVectorized(:, i)= temp(:); 
end

%display(['Total number of frames are ', num2str(numberFrames)]);
%numberFrames = input('How many frames to use? ');
X1 = FramesVectorized(:,1:numberFrames-1);
X2 = FramesVectorized(:,2:numberFrames);

[U, E, V] = svd(X1, 'econ');

Stild = U' * X2 * V * pinv(E);
[EigVec, EigVal] = eig(Stild);
omega = log(EigVal);
Omega = exp(omega);
Psi = U * EigVec;
b = pinv(Psi)*X1(:, 1);
%XDMDt = Psi * Omega * b;

omegaD = abs(diag(omega));
LowRank = exp(min(omegaD));

XDMD = zeros(heightFrame * widthFrame, numberFrames - 1);

for t = 1:numberFrames - 1
    XDMD(:, t) = Psi * Omega.^t * b;
end

XLow = zeros(heightFrame * widthFrame, numberFrames - 1);

for t = 1 :numberFrames - 1
        XLow(:, t) = Psi * LowRank.^t * b;
end

XLow = abs(XLow);
XSparse = abs(XDMD - XLow);

Foreground = uint8(reshape(XSparse, [heightFrame, widthFrame, numberFrames-1]));
Background = uint8(reshape(XLow, [heightFrame, widthFrame, numberFrames-1]));

figure;
%for i = 1:49
for i = 1:90    
%imshow(Background(:,:,i))
%imshow(Foreground(:,:,i))
subplot(1,2,1), subimage(Background(:,:,i)); title('Low-Rank');
subplot(1,2,2), subimage(Foreground(:,:,i)); title('Sparse');

 pause(1)
i
end