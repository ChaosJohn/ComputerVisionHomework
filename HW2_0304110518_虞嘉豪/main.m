function main(imgSrc) 
%输入参数: 图片路径 
  myRoberts(imgSrc); 
  mySobel(imgSrc); 
  myPrewitt(imgSrc); 
  myLog(imgSrc); 
  myCanny(imgSrc); 
end 
