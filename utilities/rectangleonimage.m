function ent=rectangleonimage(pic,sw,n,c, scale)
% sw: the location of the up-left, down-right
% n: the width of the line
% c: the color of the line: c=1(white or red); c=2(black or green);
% c=3(blue);c=others
% scale: the salce of zooming in for SR
% e.g.,: ent=rectangleonimage(pic,[x1 x2 y1 y2],1,3, 2)
if nargin< 5
    scale = [];
end
x0=sw(1);x1=sw(2);y0=sw(3);y1=sw(4);
[p q ch]=size(pic);
pic_true = pic ;
%ch=1:gray image; ch=3: color image
if ch==1
    if c==1
pic(x0:x1,y0:y0+n)=255;
        pic(x0:x1,y1-n:y1)=255;
        pic(x0:x0+n,y0:y1)=255;
        pic(x1-n:x1,y0:y1)=255;
elseif c==2
pic(x0:x1,y0:y0+n)=0;
        pic(x0:x1,y1-n:y1)=0;
        pic(x0:x0+n,y0:y1)=0;
        pic(x1-n:x1,y0:y1)=0;
else
pic(x0:x1,y0:y0+n)=255-pic(x0:x1,y0:y0+n); %È¡·´
        pic(x0:x1,y1-n:y1)=255- pic(x0:x1,y1-n:y1);
        pic(x0:x0+n,y0:y1)=255-pic(x0:x0+n,y0:y1);
        pic(x1-n:x1,y0:y1)=255-pic(x1-n:x1,y0:y1);
end
end

if ch==3
    if c==1
% r=[255,0,0]; %% method 1 ;
% pic(x0:x1,y0:y0+n,1:3)=r;
%         pic(x0:x1,y1-n:y1,1:3)=r;
%         pic(x0:x0+n,y0:y1,1:3)=r;
%         pic(x1-n:x1,y0:y1,1:3)=r;
       
pic(x0:x1,y0:y0+n,1)=255;pic(x0:x1,y0:y0+n,2)=0;pic(x0:x1,y0:y0+n,3)=0; %% method 2 ;
pic(x0:x1,y1-n:y1,1)=255;pic(x0:x1,y1-n:y1,2)=0;pic(x0:x1,y1-n:y1,3)=0;
pic(x0:x0+n,y0:y1,1)=255;pic(x0:x0+n,y0:y1,2)=0;pic(x0:x0+n,y0:y1,3)=0;
pic(x1-n:x1,y0:y1,1)=255;pic(x1-n:x1,y0:y1,2)=0;pic(x1-n:x1,y0:y1,3)=0;      
        
elseif c==2
% g=[0,255,0]; %% method 2
% pic(x0:x1,y0:y0+n,1:3)=g;
%         pic(x0:x1,y1-n:y1,1:3)=g;
%         pic(x0:x0+n,y0:y1,1:3)=g;
%         pic(x1-n:x1,y0:y1,1:3)=g;
        
pic(x0:x1,y0:y0+n,1)=0;pic(x0:x1,y0:y0+n,2)=255;pic(x0:x1,y0:y0+n,3)=0; 
pic(x0:x1,y1-n:y1,1)=0;pic(x0:x1,y1-n:y1,2)=255;pic(x0:x1,y1-n:y1,3)=0;
pic(x0:x0+n,y0:y1,1)=0;pic(x0:x0+n,y0:y1,2)=255;pic(x0:x0+n,y0:y1,3)=0;
pic(x1-n:x1,y0:y1,1)=0;pic(x1-n:x1,y0:y1,2)=255;pic(x1-n:x1,y0:y1,3)=0;

elseif c==3   
% b=[0,0,255];
% pic(x0:x1,y0:y0+n,1:3)=b;
%         pic(x0:x1,y1-n:y1,1:3)=b;
%         pic(x0:x0+n,y0:y1,1:3)=b;
%         pic(x1-n:x1,y0:y1,1:3)=b;

pic(x0:x1,y0:y0+n,1)=0;pic(x0:x1,y0:y0+n,2)=0;pic(x0:x1,y0:y0+n,3)=255;
pic(x0:x1,y1-n:y1,1)=0;pic(x0:x1,y1-n:y1,2)=0;pic(x0:x1,y1-n:y1,3)=255;
pic(x0:x0+n,y0:y1,1)=0;pic(x0:x0+n,y0:y1,2)=0;pic(x0:x0+n,y0:y1,3)=255;
pic(x1-n:x1,y0:y1,1)=0;pic(x1-n:x1,y0:y1,2)=0;pic(x1-n:x1,y0:y1,3)=255;
else                          %inverse
pic(x0:x1,y0:y0+n,1:3)=255-pic(x0:x1,y0:y0+n,1:3);
        pic(x0:x1,y1-n:y1,1:3)=255-pic(x0:x1,y1-n:y1,1:3);
        pic(x0:x0+n,y0:y1,1:3)=255-pic(x0:x0+n,y0:y1,1:3);
        pic(x1-n:x1,y0:y1,1:3)=255-pic(x1-n:x1,y0:y1,1:3);
end
end

ent=pic; %% %% Original setting

%  put zoom in image on the down-left of an image
sampIm = pic(x0:x1, y0:y1, :);
SampIm = imresize(sampIm, scale,'nearest');
%SampIm = imresize(sampIm, scale);
[a, b, third] = size(SampIm); %% Original setting


ent((p-a+1):p,1:b, :) = SampIm;

%% Remove the original rectangle
% if ch ==1
%    ent(x0:x1,y0:y0+n)=pic_true(x0:x1,y0:y0+n);
%         ent(x0:x1,y1-n:y1)=pic_true(x0:x1,y1-n:y1);
%         ent(x0:x0+n,y0:y1)=pic_true(x0:x0+n,y0:y1);
%         ent(x1-n:x1,y0:y1)=pic_true(x1-n:x1,y0:y1);
% end
%     
% if ch==3   
%   ent(x0:x1,y0:y0+n,1:3)=pic_true(x0:x1,y0:y0+n,1:3);
%        ent(x0:x1,y1-n:y1,1:3)=pic_true(x0:x1,y1-n:y1,1:3);
%         ent(x0:x0+n,y0:y1,1:3)=pic_true(x0:x0+n,y0:y1,1:3);
%         ent(x1-n:x1,y0:y1,1:3)=pic_true(x1-n:x1,y0:y1,1:3);             
% end




