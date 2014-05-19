%输入
% trainingSize: 每个人用于训练的图片数目
%输出
% eigenMatrix: 变换矩阵W
% trainingVector: 每张训练图像在W作用下的特征脸系数向量
% avatarXAverage: 训练样本的均值
% eigenSize: 特征脸的个数(主成分个数)
function [eigenMatrix, trainingVector, avatarXAverage, eigenSize] = getEigenVectors(trainingSize) 
  folderPath = 'yalefaces/'; 
  personFixs = {'01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15'};  
  categories = {'centerlight', 'glasses', 'happy', 'leftlight', 'noglasses', 'normal', 'rightlight', 'sad', 'sleepy', 'surprised', 'wink'};  

  scale = 1; 
  personSize = max(size(personFixs)); 
  categorySize = max(size(categories)); 
  avatarX = zeros(0); 

  imageSize = personSize * trainingSize;

  for i = 1 : personSize 
    for j = 1 : trainingSize
      %读入图像
      avatarSrcs{i, j} = [folderPath, 'subject', personFixs{i}, '.', categories{j}, '.gif']; 
      avatarRaws{i, j} = imresize(imread(avatarSrcs{i, j}), scale); 
      imageHeight = min(size(avatarRaws{i, j})); 
      imageWidth = max(size(avatarRaws{i, j})); 
      avatarRawsVectors{i, j} = avatarRaws{i, j}(:)'; 
      avatarX = [avatarX; avatarRawsVectors{i, j}]; 
    end 
  end 

  %计算样本均值
  avatarXAverage = double(mean(avatarX)); 
  A = zeros(0); 
  avatarX = double(avatarX); 
  %样本减去均值
  for i = 1 : imageSize 
    A = [A; avatarX(i, :) - avatarXAverage]; 
  end 

  covOfA = A * A'; 

  %得到主成分
  [V, D] = eig(covOfA); 
  D_vector = diag(D); 
  [drop, perm] = sort(D_vector, 'descend'); 
  D_sum = sum(D_vector); 
  i = 0; 
  sink = 0; 
  while( sink / D_sum < 0.99) 
    i = i + 1; 
    sink = sink + drop(i); 
  end 
  p = i;
  eigenSize = i; 

  %计算变换矩阵W
  eigenMatrix = []; 
  for j = 1 : p  
    eigenvector = A' * V(:, perm(j)) ./ sqrt(drop(j)); 
    eigenMatrix = [eigenMatrix eigenvector]; 
    engenface = uint8(reshape(eigenvector, imageHeight, imageWidth)); 
    %figure; 
    %imshow(engenface); 
  end 

  %计算每个测试图片的特征脸系数向量
  for i = 1 : personSize 
    for j = 1 : trainingSize 
      trainingVector{i, j} = eigenMatrix' * (double(avatarRawsVectors{i, j}) - avatarXAverage)'; 
    end 
  end 
end 
