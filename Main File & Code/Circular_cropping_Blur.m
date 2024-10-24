%% blurwithcircularcropping

clc; clear all; close all;

image = imread('davis_hall_building.jpeg');
imshow(image);
title('Original Image');

disp('Click to select the center of the circular crop area.');
[x_center, y_center] = ginput(1); 

disp('Click on the edge of the desired circular crop area.');
[x_edge, y_edge] = ginput(1); 

radius = round(sqrt((x_edge - x_center)^2 + (y_edge - y_center)^2));

[height, width, ~] = size(image);
[X, Y] = meshgrid(1:width, 1:height);
circularMask = (X - x_center).^2 + (Y - y_center).^2 <= radius^2;

% Create a Gaussian filter
hsize = 21; % Size of the Gaussian kernel
sigma = 10; % Standard deviation for the Gaussian kernel
h = fspecial('gaussian', hsize, sigma);

% blurred image with the same size as the original
im_blur = zeros(size(image), 'uint8');

% Apply the Gaussian filter to each color channel
for channel = 1:size(image, 3) % Loop through each color channel
    im_blur(:, :, channel) = uint8(filter2(h, double(image(:, :, channel)))); % Filter each channel
end

% Create an output image initialized to the original image
Final_image = image;

% Replace the area of the original image with the blurred area using the circular mask
for channel = 1:size(image, 3)
    temp_channel = Final_image(:, :, channel); % Get the current channel
    temp_channel(circularMask) = im_blur(circularMask); % Apply the blur where the mask is true
    Final_image(:, :, channel) = temp_channel; % Update the output image with the modified channel
end

% Display the modified image
figure;
imshow(Final_image);
title('Modified Image with Circular Crop');
