function myRoberts(imgSrc) 
  sourcePic=imread(imgSrc); %读取原图像
  grayPic=mat2gray(sourcePic); %转换成灰度图像
  [m,n]=size(grayPic);
  newGrayPic=grayPic;%为保留图像的边缘一个像素
  robertsNum=0; %经roberts算子计算得到的每个像素的值
  robertThreshold=0.2; %设定阈值
  for j=1:m-1 %进行边界提取
  for k=1:n-1
  robertsNum = abs(grayPic(j,k)-grayPic(j+1,k+1)) + abs(grayPic(j+1,k)-grayPic(j,k+1));
  if(robertsNum > robertThreshold)
  newGrayPic(j,k)=255;
  else
  newGrayPic(j,k)=0;
  end
  end
  end
  figure,imshow(newGrayPic);
  title('roberts算子的处理结果')
end 
