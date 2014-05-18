function mySobel(imgSrc) 
  sourcePic=imread(imgSrc);%读取原图像
  grayPic=mat2gray(sourcePic);%转换成灰度图像
  [m,n]=size(grayPic);
  newGrayPic=grayPic;%为保留图像的边缘一个像素
  sobelNum=0;%经sobel算子计算得到的每个像素的值
  sobelThreshold=0.8;%设定阈值
  for j=2:m-1 %进行边界提取
  for k=2:n-1
  sobelNum=abs(grayPic(j-1,k+1)+2*grayPic(j,k+1)+grayPic(j+1,k+1)-grayPic(j-1,k-1)-2*grayPic(j,k-1)-grayPic(j+1,k-1))+abs(grayPic(j-1,k-1)+2*grayPic(j-1,k)+grayPic(j-1,k+1)-grayPic(j+1,k-1)-2*grayPic(j+1,k)-grayPic(j+1,k+1));
  if(sobelNum > sobelThreshold)
  newGrayPic(j,k)=255;
  else
  newGrayPic(j,k)=0;
  end
  end
  end
  figure,imshow(newGrayPic);
  title('Sobel算子的处理结果')
end 
