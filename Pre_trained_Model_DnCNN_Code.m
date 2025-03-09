 clc; clear;

filePath = '/MATLAB Drive/Comparison-of-denoising-the-Cameraman-image-with-7-7-Gaussian-blur-and-additive.jpg'; 
F = imread(filePath); 

disp('Select Noise Type:');
disp('1: Gaussian Noise');
disp('2: Salt and Pepper Noise');
disp('3: Speckle Noise');
disp('4: No Noise');
noiseChoice = input('Enter choice (1-4): ');

switch noiseChoice
    case 1
        noisyImg = imnoise(F, 'gaussian', 0, 0.5); 
        noiseType = 'Gaussian';
    case 2
        noisyImg = imnoise(F, 'salt & pepper', 0.5); 
        noiseType = 'Salt and Pepper';
    case 3
        noisyImg = imnoise(F, 'speckle', 0.5); 
        noiseType = 'Speckle';
    case 4
        noisyImg = F;  
        noiseType = 'No Noise';
    otherwise
        disp('Invalid noise type.');
        return;
end

G_gray = rgb2gray(noisyImg);  
F_gray = rgb2gray(F);  

try
    net = denoisingNetwork("DnCNN");
catch ME
    disp(['Error loading the denoising network: ', ME.message]);
end

G_gray = single(G_gray); 
F_gray = single(F_gray);  

G_gray = G_gray / 255;  
F_gray = F_gray / 255;  

try
    denoised_image = denoiseImage(G_gray, net); 
catch ME
    disp(['Error during denoising: ', ME.message]);
end

mse_noisy = mean((F_gray(:) - G_gray(:)).^2) * 100; 
mse_denoised = mean((F_gray(:) - denoised_image(:)).^2) * 100; 

figure;
subplot(1, 3, 1);
imshow(F_gray);
title('Original Image (Grayscale)');

subplot(1, 3, 2);
imshow(G_gray);
title([noiseType ' Noisy Image']);

subplot(1, 3, 3);
imshow(denoised_image);
title('Denoised Image');

disp(['MSE between original and noisy image: ', num2str(mse_noisy)]);
disp(['MSE between original and denoised image: ', num2str(mse_denoised)]);