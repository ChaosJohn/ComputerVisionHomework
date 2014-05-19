%训练图片数
categorySizeForTraining = 7; 

folderPath = 'yalefaces/'; 
personFixs = {'01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15'};  
categories = {'centerlight', 'glasses', 'happy', 'leftlight', 'noglasses', 'normal', 'rightlight', 'sad', 'sleepy', 'surprised', 'wink'};  

personSize = max(size(personFixs)); 
categorySize = max(size(categories)); 
%用于测试的图片数
categorySizeForTesting = categorySize - categorySizeForTraining; 

%得到矩阵W(eigenMatrix)，训练图片在特征脸上的系数(trainingVectors)，训练样本的均值(avatarXAverage)，特征脸的个数(eigenSize) 
[eigenMatrix, trainingVectors, avatarXAverage, eigenSize] = getEigenVectors(categorySizeForTraining); 

mu = []; 
for i = 1 : personSize 
  tsum = zeros(eigenSize, 1); 
  for j = 1 : categorySizeForTraining 
    tsum = tsum + trainingVectors{i, j}; 
  end 
  mu = [mu tsum ./ categorySizeForTraining]; 
end

muAll = mean(mu, 2); 

sw = 0; 
for i = 1 : personSize 
  for j = 1 : categorySizeForTraining 
    sub = trainingVectors{i, j} - mu(:, i); 
    sw = sw + sub * sub'; 
  end 
end 
sb = 0; 
for i = 1 : personSize 
  sub = mu(:, i) - muAll; 
  sb = sb + sub * sub'; 
end 


matrix = inv(sw) * sb; 
[V, D] = eig(matrix); 
D_vector = diag(D); 
[drop, perm] = sort(D_vector, 'descend'); 
D_sum = sum(D_vector); 
%accurate(1, i)=>选取i个lda特征向量时的识别正确率
accurate = zeros(1, length(sw)); 
for i = 1 : length(sw) 
  %计算lda变换矩阵
  ldaMatrix = []; 
  for j = 1 : i  
    ldavector = matrix * V(:, perm(j)); 
    ldaMatrix = [ldaMatrix ldavector]; 
  end 
  %计算每个人的lda系数向量
  ldaTrainingVector = []; 
  for z = 1 : personSize 
    ldaTrainingVector = [ldaTrainingVector ldaMatrix' * mu(:, z)]; 
  end 
  %计算正确率
  accurateArray = zeros(personSize, categorySizeForTesting); 
  for x = 1 : personSize 
    for y = 1 : categorySizeForTesting 
      %拼接文件名
      testSrcs{x, y} = [folderPath, 'subject', personFixs{x}, '.', categories{y + categorySizeForTraining}, '.gif']; 
      I = imread(testSrcs{x, y}); 
      I = I(:)'; 
      I = double(I) - avatarXAverage;
      %计算特征脸系数向量
      testVector = eigenMatrix' * I';
      %计算lda系数向量
      ldaTestVector = ldaMatrix' * testVector; 
      %求与每个人的在lda系数向量上的欧式距离
      delta = zeros(1, personSize); 
      for n = 1 : personSize 
        for k = 1 : i 
          delta(1, n) = delta(1, n) + (ldaTestVector(k) - ldaTrainingVector(k, n)) .^ 2; 
        end 
      end 
      [a, b] = sort(delta, 'ascend'); 
      if b(1) == x 
        accurateArray(x, y) = 1; 
      end 
    end 
  end 
  %计算正确率
  accurate(1, i) = sum(accurateArray(:)) / (personSize * categorySizeForTesting); 
end 

%求得最大正确率
sprintf('Max accuracy up to: %4f%%', 100 * max(sort(accurate, 'descend')))
