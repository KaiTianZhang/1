x=imread('Trial 4.jpg');
%Coverts the read image to grayscale
x1=rgb2gray(x);

%Resizes the image to a lower resolution so Canny works better 
x2=imresize(x1,[320, NaN]);

%Increasing contrast
px=localcontrast(x2, 0.2, 0.8);
%adjust brightness
px1=px-15;
px2=edge(px,'canny',[0.16 0.18],0.8);




%overlay
dx=localcontrast(x2, 0.2, 0.8);
dx1=dx-15;
dx2=edge(dx1,'canny', 0.2,2.5);
dx3=imresize(dx2,[2988,NaN]);

%px3=imrotate(px2,270);
px4=imresize(px2,[2988,NaN]);


composite=imfuse(px4,dx3,'blend');
imshow(composite)


imshowpair(composite,x,'blend')
imsave