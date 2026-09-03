
clc;
clear;
close all;



%پارت اول
%پارت اول خوندن فایل و اعمال FFTD2 یا تبدیل فوریه دو بعدی 

%خوندن اولین تصویر     
% من آدرس ذخیره شده در فولدر روی لپ تاپ خودم را دادم 
I1 = imread('C:\Users\ArminI\Documents\project matlab_Armin Ilat_403249010\pic1.png');        
if size(I1, 3) == 3
    % اگه رنگی بود اینجا اومدم طوسی کردمش 
    I1 = rgb2gray(I1);
end
% تبدیل به دابل میکنه بین [0,1]
I1 = im2double(I1);           
%همه مراحل تصویر یک را برای دو هم انجام می دهیم 
% تصویر دوم را میخونه
I2 = imread('C:\Users\ArminI\Documents\project matlab_Armin Ilat_403249010\pic2.png');     
if size(I2, 3) == 3
% اگه رنگی بود طوسی میکنه 
    I2 = rgb2gray(I2);
end
% دابل میکند بین [0,1]
I2 = im2double(I2);
% اگر اندازه‌ها متفاوت بود، یکی‌شون رو تغییر اندازه میدیم
%البته الزامی نیست برای کامل تر شدن کدم این را آوردم تا در شرایطی که شکل ها
%اندازه یکسانی داشتند نیز کد من به طور کامل و بی نقص کار کند
if ~isequal(size(I1), size(I2))
% خب اینجا مطمین می شویم که دقیقا اندازه جفتشون یکی است 
    I2 = imresize(I2, size(I1));
end
% انجا می اید تصویر طوسی شده را ذخیره میکند
imwrite(I1, 'pic1_original_gray.png');   % تصویر اصلی 1
imwrite(I2, 'pic2_original_gray.png');   % تصویر اصلی 2

%وقت اعمال FFTD2 رسیده
F1 = fft2(I1);    % تبدیل فوریه شکل 1
F2 = fft2(I2);    % تبدیل فوریه شکل 2

% اندازه و فاز هر دو شکل را محاسبه می کنیم 
Mag1   = abs(F1);        % اندازه شکل 1
Phase1 = angle(F1);      % فاز شکل 1

Mag2   = abs(F2);        % اندازه شکل 2
Phase2 = angle(F2);      % فاز شکل 2

% برای انکه بهتر دیده شودشیفت دادن و لگاریتمی کردن دامنه
Mag1_vis = log(1 + abs(fftshift(F1)));
Mag2_vis = log(1 + abs(fftshift(F2)));

% نرمال کردن برای اینکه بتونم تبدیلشون کنم به تصویر
Mag1_vis = mat2gray(Mag1_vis);
Mag2_vis = mat2gray(Mag2_vis);

% طیف دامنه رو ذخیره میکنیم
imwrite(Mag1_vis, 'pic1_magnitude_spectrum.png');
imwrite(Mag2_vis, 'pic2_magnitude_spectrum.png');





% پارت ب
%تغییر اندازه و فاز 
%برای این کار اول شکل 1 را بدین صورت تعریف میکنیم که اندازه 1 و فاز 2 
%برای شکل 2 اینگونه تعریف میکنیم که اندازه 2 و فاز 1

% حالا خواسته سوال را می سازیم
% که زاویه و فاز را جا به جا کنیم
%به عبارتی ساخت تبدیل فوریه ترکیبی
% طبق فرمول: F = |F| * exp(j * phase)
F_12 = Mag1 .* exp(1j * Phase2);   %اندازه 1 و فاز 2
F_21 = Mag2 .* exp(1j * Phase1);   % اندازه 2 و فاز 1

% معکوس فوریه میگیریم تا بیاد رو حالت مکان
I_12 = ifft2(F_12);   % نتیجه بصورت مختلط است و خب عدد حققی تصویر واقعی ما میشود
I_21 = ifft2(F_21);

% پارت حقیقی را نگه می داریم
% طبق تحقیقی که انجام دادم پارت موهومی بصورت نویز است و فایده ای برای ما
% ندارد
I_12 = real(I_12);
I_21 = real(I_21);

% به اصطلاح نرمالایز میکنیم در بازه ی [0,1] 
I_12_norm = mat2gray(I_12);
I_21_norm = mat2gray(I_21);

% حالا ذخیره می کنیم
imwrite(I_12_norm, 'img_mag1_phase2.png');   % |F1| + angle(F2)
imwrite(I_21_norm, 'img_mag2_phase1.png');   % |F2| + angle(F1)

%هر چهار شکل را رسم میکنیم 

figure('Name', 'Original and Phase/Magnitude-Swapped Images');

% تصویر اصلی 1
subplot(2, 2, 1);
imshow(I1, []);
title('تصویر اصلی 1');

% تصویر اصلی 2
subplot(2, 2, 2);
imshow(I2, []);
title('تصویر اصلی 2');

% اندازه 1 و فاز 2
subplot(2, 2, 3);
imshow(I_12_norm, []);
title(' اندازه 1 و فاز 2');

% اندازه 2 و فاز 1
subplot(2, 2, 4);
imshow(I_21_norm, []);
title('اندازه 2 و فاز 1');
