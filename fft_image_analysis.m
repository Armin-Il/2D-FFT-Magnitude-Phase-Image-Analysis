%% FFT Magnitude/Phase Swap Between Two Images
%
% This script takes two grayscale images, computes their 2D Fourier
% Transforms, and then reconstructs two new "hybrid" images by swapping
% magnitude and phase between them:
%
%   Hybrid 1 = |F1| * exp(j * phase(F2))
%   Hybrid 2 = |F2| * exp(j * phase(F1))
%
% This is a classic demonstration of how much visual information in an
% image is actually carried by the phase spectrum rather than the
% magnitude spectrum: the hybrid images end up looking much more like
% the image that donated its phase than the one that donated its
% magnitude.
%
% Author:   Armin Ilat
% GitHub:   https://github.com/Armin-Il
% LinkedIn: https://www.linkedin.com/in/armin-ilat/

clc;
clear;
close all;

%% ------------------------------------------------------------------
%  Configuration
%  --------------------------------------------------------------------
% Just point these at your two input images. They don't need to be the
% same size -- the script will resize the second image to match the
% first if needed.

img1Path = 'pic1.png';
img2Path = 'pic2.png';

outputDir = 'output';
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

%% ------------------------------------------------------------------
%  Step 1: Load images and convert to grayscale, double precision
%  --------------------------------------------------------------------

I1 = loadAsGrayDouble(img1Path);
I2 = loadAsGrayDouble(img2Path);

% Match sizes if the two images differ, so the FFTs are comparable.
if ~isequal(size(I1), size(I2))
    I2 = imresize(I2, size(I1));
end

% Save the grayscale versions on their own.
imwrite(I1, fullfile(outputDir, 'pic1_gray.png'));
imwrite(I2, fullfile(outputDir, 'pic2_gray.png'));

%% ------------------------------------------------------------------
%  Step 2: 2D FFT, then split into magnitude and phase
%  --------------------------------------------------------------------

F1 = fft2(I1);
F2 = fft2(I2);

Mag1   = abs(F1);
Phase1 = angle(F1);

Mag2   = abs(F2);
Phase2 = angle(F2);

% Log-scaled, shifted magnitude spectra, purely for visualization.
Mag1_vis = mat2gray(log(1 + abs(fftshift(F1))));
Mag2_vis = mat2gray(log(1 + abs(fftshift(F2))));

imwrite(Mag1_vis, fullfile(outputDir, 'pic1_magnitude_spectrum.png'));
imwrite(Mag2_vis, fullfile(outputDir, 'pic2_magnitude_spectrum.png'));

%% ------------------------------------------------------------------
%  Step 3: Swap magnitude and phase, then invert the FFT
%  --------------------------------------------------------------------
% F = |F| * exp(j * phase)

F_mag1_phase2 = Mag1 .* exp(1i * Phase2);   % magnitude of img1, phase of img2
F_mag2_phase1 = Mag2 .* exp(1i * Phase1);   % magnitude of img2, phase of img1

I_mag1_phase2 = real(ifft2(F_mag1_phase2));  % imaginary part is just numerical noise
I_mag2_phase1 = real(ifft2(F_mag2_phase1));

I_mag1_phase2 = mat2gray(I_mag1_phase2);
I_mag2_phase1 = mat2gray(I_mag2_phase1);

imwrite(I_mag1_phase2, fullfile(outputDir, 'hybrid_mag1_phase2.png'));
imwrite(I_mag2_phase1, fullfile(outputDir, 'hybrid_mag2_phase1.png'));

%% ------------------------------------------------------------------
%  Step 4: Combined figure with all 4 results side by side
%  --------------------------------------------------------------------

resultsFig = figure('Name', 'Original vs Magnitude/Phase-Swapped Images', ...
                     'Color', 'w');

subplot(2, 2, 1);
imshow(I1, []);
title('Original Image 1');

subplot(2, 2, 2);
imshow(I2, []);
title('Original Image 2');

subplot(2, 2, 3);
imshow(I_mag1_phase2, []);
title('Magnitude 1 + Phase 2');

subplot(2, 2, 4);
imshow(I_mag2_phase1, []);
title('Magnitude 2 + Phase 1');

sgtitle('FFT Magnitude/Phase Swap Result');

exportgraphics(resultsFig, fullfile(outputDir, 'combined_results.png'), ...
                'Resolution', 200);

fprintf('Done. All outputs saved in "%s".\n', outputDir);

%% ------------------------------------------------------------------
%  Helper function
%  --------------------------------------------------------------------
function img = loadAsGrayDouble(path)
    % Reads an image from disk, converts it to grayscale if needed, and
    % returns it as a double-precision array scaled to [0, 1].
    img = imread(path);
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    img = im2double(img);
end
