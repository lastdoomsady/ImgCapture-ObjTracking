clear
close all
clc
%cam
cam=webcam;
cam2=webcam(2);
set(cam,'Resolution','320x240');
set(cam2,'Resolution','320x240');
r=1;
rr=1;
f=1;
%snapshot
for n=1:60
    I(:,:,:,n) = fliplr(snapshot(cam));
    II(:,:,:,n) = snapshot(cam2);
end
%process
for n=1:60
 %   I(:,:,:,n) = fliplr(snapshot(cam));
 %   II(:,:,:,n) = snapshot(cam2);
    [BW,R]=createMask(I(:,:,:,n));
    [BW2,R2]=createMask2(II(:,:,:,n));
    se1=strel('disk',2);
    se2=strel('disk',10);
    BW=imerode(BW,se1);
    BW=imdilate(BW,se2);
    BW=imfill(BW,'holes');
    s  = regionprops(BW,'centroid');
    BW2=imerode(BW2,se1);
    BW2=imdilate(BW2,se2);
    BW2=imfill(BW2,'holes');
    s2  = regionprops(BW2,'centroid');
    if isempty(s) == false
        pnts(r,:)=s.Centroid;
        r=r+1;
    end
    if isempty(s2) == false
        pnts2(rr,:)=s2.Centroid;
        rr=rr+1;
    end
end
%real path 1
figure(2),subplot(2,2,1),imshow(I(:,:,:,1))
hold on,plot(pnts(:,1),pnts(:,2),'b')
scatter(pnts(:,1),pnts(:,2),'b')
%real path 2
figure(2),subplot(2,2,2),imshow(II(:,:,:,1))
hold on,plot(pnts2(:,1),pnts2(:,2),'b')
scatter(pnts2(:,1),pnts2(:,2),'b')
%ployfit
pf=polyfit(pnts(:,1),pnts(:,2),8);
pf2=polyfit(pnts2(:,1),pnts2(:,2),3);
%display polyfit
subplot(2,2,3),imshow(I(:,:,:,1)),hold on,flip(scatter(pnts(:,1),pnts(:,2),'g+'));
plot(0:0.1:320,polyval(pf,0:0.1:320));
subplot(2,2,4),imshow(II(:,:,:,1)),hold on,flip(scatter(pnts2(:,1),pnts2(:,2),'g+'));
plot(0:0.1:320,polyval(pf2,0:0.1:320));
%scatter3
pv1=polyval(pf,0:0.1:320);
pv2=polyval(pf2,0:0.1:320);
for k=1:20:3200
    figure(1),subplot(2,2,[2,4]),scatter3(k/10,pv2(k),-pv1(k),'o'),hold on,axis([0 320 0 240 -240 0])
    view(2+k/100,30)
    subplot(2,2,1),imshow(I(:,:,:,ceil(k/54))),hold on
    subplot(2,2,3),imshow(II(:,:,:,ceil(k/54))),hold on
    frame(f)=getframe(gcf);
    f=f+1;
    pause(0.0001)
end

myVideo=VideoWriter('Savedvideo10.avi');
myVideo.FrameRate = 10;
myVideo.Quality = 100;
open(myVideo)
writeVideo(myVideo,frame(5:159));
close(myVideo)
